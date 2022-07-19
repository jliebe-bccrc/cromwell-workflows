version 1.0

## Created by Aparicio Lab (BC Cancer Research Centre) June 2022
## This workflow compresses a BAM file into a CRAM, and also creates cram.crai and cram.md5 files.
## Taken from the BamToCram task found in Microsoft's GATK4 Genome Preprocessing pipeline, found at
## https://github.com/microsoft/gatk4-genome-processing-pipeline-azure/blob/main-azure/tasks/BamToCram.wdl.
##
## Requirements/expectations:
## - BAM file
## - Sample ID
##
## Outputs:
## - CRAM file, index, and md5
##
## Runtime parameters are optimized for Cromwell on Azure implementation.


# WORKFLOW DEFINITION
workflow BamToCram {
  input {
    File input_bam
    String sample_ID
    
    File ref_fasta
    File ref_fasta_index

    Int preemptible_tries = 2
  }
    
  call ConvertToCram {
    input:
      input_bam = input_bam,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      output_basename = sample_ID,
      preemptible_tries = preemptible_tries
  }

  output {
    File output_cram = ConvertToCram.output_cram
    File output_cram_index = ConvertToCram.output_cram_index
    File output_cram_md5 = ConvertToCram.output_cram_md5
  }
}

task ConvertToCram {
  input {
    File input_bam
    String output_basename

    File ref_fasta
    File ref_fasta_index
    Int preemptible_tries
  }

  Float ref_size = size(ref_fasta, "GB") + size(ref_fasta_index, "GB")
  Int disk_size = select_first([(ceil(2 * size(input_bam, "GB") + ref_size) + 20), 200])

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
    disk: disk_size + " GB"
    memory: "3 GB"
    cpu: 2
    preemptible: true
    maxRetries: preemptible_tries
  }

  output {
    File output_cram = "~{output_basename}.cram"
    File output_cram_index = "~{output_basename}.cram.crai"
    File output_cram_md5 = "~{output_basename}.cram.md5"
  }
}