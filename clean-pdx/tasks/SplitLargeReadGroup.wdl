version 1.0

## Copyright Broad Institute, 2018
##
## This WDL pipeline implements a split of large readgroups for human whole-genome and exome sequencing data.
##
## Runtime parameters are often optimized for Broad's Google Cloud Platform implementation.
## For program versions, see docker containers.
##
## LICENSING :
## This script is released under the WDL source code license (BSD-3) (see LICENSE in
## https://github.com/broadinstitute/wdl). Note however that the programs it calls may
## be subject to different licenses. Users are responsible for checking that they are
## authorized to run all programs before running this script. Please see the docker
## page at https://hub.docker.com/r/broadinstitute/genomes-in-the-cloud/ for detailed
## licensing information pertaining to the included programs.

import "https://raw.githubusercontent.com/jliebe-bccrc/cromwell-workflows/main/clean-pdx/tasks/Alignment.wdl" as Alignment

workflow SplitLargeReadGroup {
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
    Int reads_per_file = 48000000
  }

  call Alignment.SamSplitter as SamSplitter {
    input :
      input_bam = input_bam,
      n_reads = reads_per_file,
      preemptible_tries = preemptible_tries,
      compression_level = compression_level
  }

  scatter(unmapped_bam in SamSplitter.split_bams) {
    Float current_unmapped_bam_size = size(unmapped_bam, "GB")
    String current_name = basename(unmapped_bam, ".bam")

    call Alignment.SamToFastqAndBwaMemAndMba as SamToFastqAndBwaMemAndMba {
      input:
        input_bam = unmapped_bam,
        bwa_commandline = bwa_commandline,
        output_bam_basename = current_name,
        reference_fasta = mouse_human_genome_fasta,
        mouse_human_genome_fasta_index = mouse_human_genome_fasta_index,
        mouse_human_genome_dict = mouse_human_genome_dict,
        mouse_human_genome_sa = mouse_human_genome_sa, 
        mouse_human_genome_amb = mouse_human_genome_amb,
        mouse_human_genome_ann = mouse_human_genome_ann,
        mouse_human_genome_bwt = mouse_human_genome_bwt,
        mouse_human_genome_pac = mouse_human_genome_pac,
        mouse_human_genome_alt = mouse_human_genome_alt,
        bwa_version = bwa_version,
        compression_level = compression_level,
        preemptible_tries = preemptible_tries
    }

    Float current_mapped_size = size(SamToFastqAndBwaMemAndMba.output_bam, "GB")
  }

  call SumFloats {
    input:
      sizes = current_mapped_size,
      preemptible_tries = preemptible_tries
  }

  call GatherUnsortedBamFiles {
    input:
      input_bams = SamToFastqAndBwaMemAndMba.output_bam,
      total_input_size = SumFloats.total_size,
      output_bam_basename = output_bam_basename,
      preemptible_tries = preemptible_tries,
      compression_level = compression_level
  }
  
  output {
    File aligned_bam = GatherUnsortedBamFiles.output_bam
  }
}



# Calculates sum of a list of floats
task SumFloats {
  input {
    Array[Float] sizes
    Int preemptible_tries
  }

  command <<<
  python -c "print ~{sep="+" sizes}"
  >>>

  output {
    Float total_size = read_float(stdout())
  }

  runtime {
    docker: "us.gcr.io/broad-gotc-prod/python:2.7"
    preemptible: true
    maxRetries: preemptible_tries
  }
}


# Combine multiple *unsorted* BAM files
# Note that if/when WDL supports optional outputs, we should merge this task with the sorted version
task GatherUnsortedBamFiles {
  input {
    Array[File] input_bams
    String output_bam_basename
    Float total_input_size
    Int compression_level
    Int preemptible_tries
  }

  # Multiply the input bam size by two to account for the input and output
  Int disk_size = ceil(2 * total_input_size) + 20

  command <<<
    java -Dsamjdk.compression_level=~{compression_level} -Xms2000m -jar /usr/gitc/picard.jar \
    GatherBamFiles \
    INPUT=~{sep=' INPUT=' input_bams} \
    OUTPUT=~{output_bam_basename}.bam \
    CREATE_INDEX=false \
    CREATE_MD5_FILE=false
  >>>

  runtime {
    docker: "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.3-1564508330"
    preemptible: true
    maxRetries: preemptible_tries
    memory: "3 GB"
    disk: disk_size + " GB"
  }

  output {
    File output_bam = "~{output_bam_basename}.bam"
  }
}