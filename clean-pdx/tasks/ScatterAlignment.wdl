version 1.0

task SamSplitter {
  input {
    File input_bam
    Int n_reads
    Int preemptible_tries
    Int compression_level
  }

  Float unmapped_bam_size = size(input_bam, "GB")
  # Since the output bams are less compressed than the input bam we need a disk multiplier that's larger than 2.
  Float disk_multiplier = 2.5
  Int disk_size = ceil(disk_multiplier * unmapped_bam_size + 20)

  #command <<<
  #  set -e
  #  mkdir output_dir
  #  total_reads=$(samtools view -c ~{input_bam})
  #  java -Dsamjdk.compression_level=~{compression_level} -Xms3000m -jar /usr/gitc/picard.jar SplitSamByNumberOfReads \
  #  INPUT=~{input_bam} \
  #  OUTPUT=output_dir \
  #  SPLIT_TO_N_READS=~{n_reads} \
  #  TOTAL_READS_IN_INPUT=$total_reads
  #>>>

  command <<<
    set -o pipefail
    set -e
    samtools split -u /dev/null -v ~{input_bam} > output_dir
  >>>


  output {
    Array[File] split_bams = glob("output_dir/*.bam")
  }

  runtime {
    docker: "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.3-1564508330"
    preemptible: true
    maxRetries: preemptible_tries
    memory: "3.75 GB"
    disk: disk_size + " GB"
  }
}


# Convert input_bam to paired fastq reads and aligns to a combined mouse/human reference
task SamToFastqAndBwaMem {
	input {
      File input_bam
      String bwa_commandline
      String bwa_version
      String output_bam_basename
    	
      File mouse_human_genome_fasta
      File mouse_human_genome_fasta_index
      File mouse_human_genome_dict

      File mouse_human_genome_sa
      File mouse_human_genome_amb
      File mouse_human_genome_ann
      File mouse_human_genome_bwt
      File mouse_human_genome_pac
      File? mouse_human_genome_alt

      Int compression_level
      Int preemptible_tries
	}

    Float unmapped_bam_size = size(input_bam, "GB")

    # Since ref_size/bwa_ref_size don't like getting the size of the input ref files, just estimate that total is ~15GB and add to disk_size

    # Sometimes the output is larger than the input, or a task can spill to disk.
    # In these cases we need to account for the input (1) and the output (1.5) or the input(1), the output(1), and spillage (.5).
    Float disk_multiplier = 2.5
    Int disk_size = ceil(unmapped_bam_size + 16 + (disk_multiplier * unmapped_bam_size) + 100)

	command <<<
      set -o pipefail
      set -e
      # set the bash variable needed for the command-line
      bash_ref_fasta=~{mouse_human_genome_fasta}
      java -Xms3000m -jar /usr/gitc/picard.jar \
      SamToFastq \
      INPUT=~{input_bam} \
      FASTQ=/dev/stdout \
      INTERLEAVE=true \
      VALIDATION_STRINGENCY=LENIENT \
      NON_PF=true | \
      /usr/gitc/~{bwa_commandline} /dev/stdin - 2> >(tee ~{output_bam_basename}.bwa.stderr.log >&2) | \
      samtools view -1 - > ~{output_bam_basename}.bam
	>>>

	runtime {
	  docker: "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.3-1564508330"
	  preemptible: true
	  maxRetries: preemptible_tries
	  memory: "14 GB"
	  cpu: 16
	  disk: disk_size + " GB"
	}

	output {
      File output_bam = "~{output_bam_basename}.bam"
      File bwa_stderr_log = "~{output_bam_basename}.bwa.stderr.log"
   	}
}
