version 1.0

workflow BamToCram {
  input {
    File input_bam
    File ref_fasta
    File ref_fasta_index
    File ref_dict
    String base_file_name
    Int agg_preemptible_tries
  }

  # Convert the final merged recalibrated BAM file to CRAM format
  call ConvertToCram {
    input:
      input_bam = input_bam,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      output_basename = base_file_name,
      preemptible_tries = agg_preemptible_tries
  }

  output {
     File output_cram = ConvertToCram.output_cram
     File output_cram_index = ConvertToCram.output_cram_index
     File output_cram_md5 = ConvertToCram.output_cram_md5
  }
}


# TASK DEFINITIONS

# Convert BAM file to CRAM format
# Note that reading CRAMs directly with Picard is not yet supported
task ConvertToCram {
  input {
    File input_bam
    File ref_fasta
    File ref_fasta_index
    String output_basename
    Int preemptible_tries
  }

  Float ref_size = size(ref_fasta, "GB") + size(ref_fasta_index, "GB")
  Int disk_size = ceil(2 * size(input_bam, "GB") + ref_size) + 20

  command <<<
    set -e
    set -o pipefail
    samtools view -C -T ~{ref_fasta} ~{input_bam} | \
    tee ~{output_basename}.cram | \
    md5sum | awk '{print $1}' > ~{output_basename}.cram.md5
    # Create REF_CACHE. Used when indexing a CRAM
    seq_cache_populate.pl -root ./ref/cache ~{ref_fasta}
    export REF_PATH=:
    export REF_CACHE=./ref/cache/%2s/%2s/%s
    samtools index ~{output_basename}.cram
  >>>
  
  runtime {
    docker: "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.3-1564508330"
    preemptible: true
    maxRetries: preemptible_tries
    memory: "3 GB"
    cpu: "1"
    disk: disk_size + " GB"
  }

  output {
    File output_cram = "~{output_basename}.cram"
    File output_cram_index = "~{output_basename}.cram.crai"
    File output_cram_md5 = "~{output_basename}.cram.md5"
  }
}

