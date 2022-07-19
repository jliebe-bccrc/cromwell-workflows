version 1.0

## Copyright Aparicio Lab (BC Cancer Research Centre), June 2022
## 
## This WDL calls samtools flagstat on the input BAM file.
##
## Requirements/expectations:
## - BAM file
## - Sample ID
##
## Outputs:
## - txt file containing the output of flagstat
##
## Created by Aparicio Lab (BC Cancer Research Centre) May 2022.
## Reference WDL: https://github.com/biowdl/tasks/blob/develop/samtools.wdl (Copyright (c) 2017 Leiden University Medical Center).
##
## Runtime parameters are optimized for Cromwell on Azure implementation.

# WORKFLOW DEFINITION
workflow Flagstat {
  input {
    File input_bam
    String sample_ID

    String gatk_docker = "broadinstitute/gatk:latest"
    String gatk_path = "/gatk/gatk"
  }
  
  String output_name = sample_ID + ".flagstat.txt"  
    
  call Flagstat {
    input:
      input_bam = input_bam,
      output_name = output_name,
      gatk_docker = gatk_docker,
      gatk_path = gatk_path
  }

  output {
    File output_file = Flagstat.output_file
  }
}

task Flagstat {
  input {
    File input_bam
    String output_name
    
    String gatk_path
    String gatk_docker
    Int machine_mem_gb = 2
    Int preemptible_attempts = 3
  }
    
  Int command_mem_gb = machine_mem_gb - 1

  command <<< 
    samtools flagstat ~{input_bam} > ~{output_name}
  >>>

  runtime {
    docker: gatk_docker
    memory: machine_mem_gb + " GB"
    preemptible: true
  }

  output {
    File output_file = "~{output_name}"
  }
}