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
workflow Reheader {
  input {
    File input_bam
    String sample_ID
    String sample_RGID
    String sample_PU
    String sample_SM
    String sample_PL

    String gatk_docker = "broadinstitute/gatk:latest"
    String gatk_path = "/gatk/gatk"

    Int compression_level = 5
    Int preemptible_tries = 2
  }
    
  # Reheader a BAM file
  call ReheaderBam {
    input:
      input_bam = input_bam,
      sample_ID = sample_ID,
      sample_RGID = sample_RGID,
      sample_PU = sample_PU,
      sample_SM = sample_SM,
      sample_PL = sample_PL,
      output_bam_basename = sample_ID + ".reheadered",
      compression_level = compression_level,
      preemptible_tries = preemptible_tries,
      gatk_docker = gatk_docker
    }

  output {
    File output_bam = ReheaderBam.output_bam
  }
}


# TASK DEFINITION
task ReheaderBam {
  input {
    File input_bam
    String sample_ID
    String sample_RGID
    String sample_PU
    String sample_SM
    String sample_PL
    String output_bam_basename

    Int preemptible_tries
    Int compression_level
    
    String gatk_docker
  }

  Float input_bam_size = size(input_bam, "GB")
  Int disk_size = ceil(input_bam_size * 4)

  command <<<
    java -Xms4000m -jar /usr/gitc/picard.jar \
    AddOrReplaceReadGroups \
    INPUT=~{input_bam} \
    OUTPUT=~{output_bam_basename}.bam \
    RGID=~{sample_RGID} \
    RGLB=~{sample_ID} \
    RGPL=~{sample_PL} \
    RGPU=~{sample_PU} \
    RGSM=~{sample_SM}
  >>>

  runtime {
    docker: gatk_docker
    memory: "12 GB"
    disk: disk_size + " GB"
    cpu: 4
    preemptible: true
    maxRetries: preemptible_tries
  }

  output {
    File output_bam = "~{output_bam_basename}.bam"
  }
}