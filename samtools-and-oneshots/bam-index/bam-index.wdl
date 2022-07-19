version 1.0
## Copyright Aparicio Lab (BCCRC), 2022
## 
## This WDL calls samtools index on an input BAM file
##
## Requirements/expectations :
## - BAM file
## - sample ID
##
## Outputs :
## - BAI file (BAM index)
##
## Created by Aparicio Lab (BC Cancer Research Centre) May 2022.
## Reference WDL: https://github.com/biowdl/tasks/blob/develop/samtools.wdl (Copyright (c) 2017 Leiden University Medical Center).
##
## Runtime parameters are optimized for Cromwell on Azure implementation.


# WORKFLOW DEFINITION
workflow Index {
  input {
    File input_bam
    String sample_ID

    String gatk_docker = "broadinstitute/gatk:latest"
    String gatk_path = "/gatk/gatk"
  }

  Float input_size = size(input_bam, "GB")
    
  call IndexBam {
    input:
      input_bam = input_bam,
      sample_ID = sample_ID,
      disk_size = ceil(input_size),
      docker = gatk_docker,
      gatk_path = gatk_path
  }

  output {
    File output_bai = IndexBam.output_bai
  }
}

task IndexBam {
  input {
    File input_bam
    String sample_ID
    Int disk_size
    
    String gatk_path
    String docker
    Int preemptible_attempts = 3
  }

  Int machine_mem_gb = 2

  command <<< 
    samtools index ~{input_bam} ~{sample_ID}.bai
  >>>

  runtime {
    docker: docker
    disk: disk_size + " GB"
    memory: machine_mem_gb + " GB"
    cpu: 4    
    preemptible: true
  }

  output {
    File output_bai = "~{sample_ID}.bai"
  }
}