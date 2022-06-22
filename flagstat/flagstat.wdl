version 1.0
## Copyright Aparicio Lab (BC Cancer Research Centre), June 2022
## 
## This WDL calls samtools flagstat on the input BAM file.
##
## Runtime parameters are optimized for Cromwell on Azure (Microsoft) implementation.
##
## Requirements/expectations:
## - BAM file
## - Sample ID
##
## Outputs:
## - txt file containing the output of flagstat


# WORKFLOW DEFINITION
workflow Flagstat {
  input {
    File input_bam
    String sample_ID

    String gatk_docker = "broadinstitute/gatk:latest"
    String gatk_path = "/gatk/gatk"

    Int additional_disk_size = 20
  }
  
    
  String output_name = sample_ID + ".flagstat.txt"  
    
  call Flagstat {
    input:
      input_bam = input_bam,
      output_name = output_name,
      disk_size = 20 + additional_disk_size,
      docker = gatk_docker,
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
    Int disk_size
    String docker
    Int machine_mem_gb = 2
    Int preemptible_attempts = 3
  }
    
  Int command_mem_gb = machine_mem_gb - 1    ####Needs to occur after machine_mem_gb is set 

  command { 
    set -o pipefail
    set -e
    samtools flagstat ~{input_bam} > ~{output_name}
  }

  runtime {
    docker: docker
    disk: disk_size + " GB"
    memory: machine_mem_gb + " GB"
    preemptible: true
  }

  output {
    File output_file = "~{output_name}"
  }
}
