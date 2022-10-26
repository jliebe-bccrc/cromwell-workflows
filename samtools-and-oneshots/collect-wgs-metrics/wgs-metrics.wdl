version 1.0

## Copyright Broad Institute, 2018, and Aparicio Lab (BC Cancer Research Centre), 2022
## 
## This WDL calls Picard's CollectWgsMetrics on an input BAM file.
##
## Requirements/expectations:
## - BAM file and index
## - Sample ID
## - WGS coverage interval list
## - Reference genome FASTA and index
## - Read length
##
## Outputs:
## - WGS metrics file
##
## Update Notes:
## This workflow's task was taken directly from Microsoft's Germline PreProcessing and Variant Calling pipeline,
## but edited by Jenna Liebe at the Aparicio Lab (BC Cancer Research Centre) to run as a stand-alone workflow.
##
## Runtime parameters are optimized for Cromwell on Azure implementation.

# WORKFLOW DEFINITION
workflow WgsMetrics {
  input {
    File input_bam
    String input_bam_index
    String sample_ID

    File wgs_coverage_interval_list
    File ref_fasta
    File ref_fasta_index
    Int read_length

    String docker = "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.3-1564508330"
  }
  
  String metrics_filename = sample_ID + ".wgs_metrics"  
    
  call CollectWgsMetrics {
    input:
      input_bam = input_bam,
      input_bam_index = input_bam_index,
      metrics_filename = metrics_filename,
      wgs_coverage_interval_list = wgs_coverage_interval_list,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      read_length = read_length,
      docker = docker
  }

  output {
    File output_metrics = CollectWgsMetrics.metrics
  }
}

task CollectWgsMetrics {
  input {
    File input_bam
    File input_bam_index
    String metrics_filename
    
    File wgs_coverage_interval_list
    File ref_fasta
    File ref_fasta_index
    Int read_length

    String docker
  }
  
  Float ref_size = size(ref_fasta, "GB") + size(ref_fasta_index, "GB")
  Int disk_size = (ceil(size(input_bam, "GB")) + ref_size) + 20

  command <<< 
    java -Xms2000m -jar /usr/gitc/picard.jar \
    CollectWgsMetrics \
    INPUT=~{input_bam} \
    VALIDATION_STRINGENCY=SILENT \
    REFERENCE_SEQUENCE=~{ref_fasta} \
    INCLUDE_BQ_HISTOGRAM=true \
    INTERVALS=~{wgs_coverage_interval_list} \
    OUTPUT=~{metrics_filename} \
    USE_FAST_ALGORITHM=true \
    READ_LENGTH=~{read_length}
  >>>

  runtime {
    docker: docker
    preemptible: true
    maxRetries: 2
    memory: "3 GB"
    disk: disk_size + " GB"
  }

  output {
    File metrics = "~{metrics_filename}"
  }
}