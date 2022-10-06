version 1.0
## Copyright Aparicio Lab (BCCRC), 2022
## 
## This WDL mutation data (MAF) files together to match cBioPortal's requirements for either a minimal or extended mutation data file.
##
## Requirements/expectations :
## - Minimal or extended mutation files (all input files should have the same format)
## - Maf type ("minimal" or "extended")
## - A template file - either just the column headers for an extended/minimal data file, or a pre-existing data file
##
## Outputs :
## - Minimal or extended mutation data file complying with cBioPortal requirements
##
## Created by Aparicio Lab (BC Cancer Research Centre) September 2022.
##
## Runtime parameters are optimized for Cromwell on Azure implementation.


# WORKFLOW DEFINITION
workflow MafConcatter {
  input {
    Array[File] input_maf_files
    String data_type
    File template_file

    String gatk_docker = "broadinstitute/gatk:latest"
    String gatk_path = "/gatk/gatk"
  }

  # Process separate input txt files in parallel
  scatter (input_maf in input_maf_files) {

    # Remove the first line of each file (header row - leave just data)
    call RemoveHeader {
      input:
        input_maf = input_maf,
        output_basename = basename(input_maf, ".~{data_type}.maf"),
        data_type = data_type,
        docker = gatk_docker,
        gatk_path = gatk_path
    }
  }  

  String output_basename = "data_mutations_" + data_type

  # Add the files to a template or pre-existing mutation data file
  call Concatenate {
    input:
      input_txts = RemoveHeader.output_txt,
      template_file = template_file,
      data_type = data_type,
      output_basename = output_basename,
      docker = gatk_docker,
      gatk_path = gatk_path
  }

  output {
    File output_mutation_data = Concatenate.output_mutation_data
  }
}


# TASK DEFINITIONS

# Remove the first line of each file (header row - leave just data)
task RemoveHeader {
  input {
    File input_maf
    String output_basename
    String data_type

    Int disk_size = 2
    String gatk_path
    String docker
    Int preemptible_attempts = 3
  }


  command <<<
    sed '1,1d' ~{input_maf} > ~{output_basename}.txt
  >>>

  runtime {
    docker: docker
    disk: disk_size + " GB"
    memory: "2 GB"
    cpu: 2    
    preemptible: true
    maxRetries: preemptible_attempts
  }

  output {
    File output_txt = "~{output_basename}.txt"
  }
}

# Add the files to a template or pre-existing mutation data file
task Concatenate {
  input {
    Array [File] input_txts
    File template_file
    String data_type
    String output_basename
    
    Int disk_size = 20
    String gatk_path
    String docker
    Int preemptible_attempts = 3
  }

  command <<< 
    cat ~{template_file} > ~{output_basename}.txt
    declare -a input_txts=(~{sep=' ' input_txts});
    for ((i=0; i<${#input_txts[@]}; i++)); do cat ${input_txts[$i]} >> ~{output_basename}.txt; done
  >>>

  runtime {
    docker: docker
    disk: disk_size + " GB"
    memory: "4 GB"
    cpu: 4
    preemptible: true
    maxRetries: preemptible_attempts
  }

  output {
    File output_mutation_data = "~{output_basename}.txt"
  }
}