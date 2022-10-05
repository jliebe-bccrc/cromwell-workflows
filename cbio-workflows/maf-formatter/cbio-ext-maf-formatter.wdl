version 1.0
## Copyright Aparicio Lab (BCCRC), 2022
## 
## This WDL edits a MAF file to match cBioPortal's requirements for a minimal mutation data file.
##
## Requirements/expectations :
## - MAF files to convert
##
## Outputs :
## - MAF data file complying with cBioPortal requirements for a minimal mutation data file.
##
## Created by Aparicio Lab (BC Cancer Research Centre) September 2022.
##
## Runtime parameters are optimized for Cromwell on Azure implementation.


# WORKFLOW DEFINITION
workflow CbioExtMafFormatter {
  input {
    File input_maf
    String maf_id
    String normal_id

    String gatk_docker = "broadinstitute/gatk:latest"
    String gatk_path = "/gatk/gatk"
  }

  String maf_basename_1 = "~{maf_id}.edit1.maf"
  String maf_basename_2 = "~{maf_id}.min.maf"
  String maf_basename_3 = "~{maf_id}.cbio.maf"
  
  # Remove the header lines (##) and choose the appropriate columns  
  call SelectColumns {
    input:
      input_maf = input_maf,
      maf_basename = maf_basename_1,
      docker = gatk_docker,
      gatk_path = gatk_path
  }

  # Edit the columns to match cBioPortal formatting
  call EditFormat {
    input:
      input_maf = SelectColumns.output_maf,
      maf_basename = maf_basename_2,
      maf_id = maf_id,
      normal_id = normal_id,
      docker = gatk_docker,
      gatk_path = gatk_path
  }

  output {
    File output_maf_file = EditFormat.output_maf
  }
}


# TASK DEFINITIONS

# Remove the header lines (##) and choose the appropriate columns  
task SelectColumns {
  input {
    File input_maf
    String maf_basename
    
    Int disk_size = 10
    String gatk_path
    String docker
    Int preemptible_attempts = 3
  }

  command <<< 
    sed '/^#/d' ~{input_maf} | 
    awk -F "\t" 'OFS="\t" {
      for (i=1; i<=32; i++) {
      printf $i"\t" > ("~{maf_basename}");
      } 
      {
      print $42, $46, $81, $82, $83, $84 > ("~{maf_basename}");
      }
    }' 
  >>>

  runtime {
    docker: docker
    disk: disk_size + " GB"
    memory: "4 GB"
    cpu: 2    
    preemptible: true
    maxRetries: preemptible_attempts
  }

  output {
    File output_maf = "~{maf_basename}"
  }
}

# Edit the columns to match cBioPortal formatting
task EditFormat {
  input {
    File input_maf
    String maf_basename
    String maf_id
    String normal_id

    Int disk_size = 4
    String gatk_path
    String docker
    Int preemptible_attempts = 3
  }

  command <<< 
    sed 's/chr//g;s/Protein_Change/HGVSp_Short/g;s/hg38/GRCh38/g;s/SwissProt_acc_Id/SWISSPROT/g;s/__UNKNOWN__//g' ~{input_maf} | 
    awk -F "\t" 'OFS="\t" {
      if (NR>1) {
        $16="~{maf_id}";
        $17="~{normal_id}";
      }
      print > ("~{maf_basename}");
    }'
  >>>

  runtime {
    docker: docker
    disk: disk_size + " GB"
    memory: "4 GB"
    cpu: 2    
    preemptible: true
    maxRetries: preemptible_attempts
  }

  output {
    File output_maf = "~{maf_basename}"
  }
}


# Run through Genome Nexus Annotation Pipeline
task GenomeNexus {
  input {
    File input_maf
    String maf_basename
    String maf_id
  }

  Int preemptible_attempts = 3
  Int disk_size = 4

  command <<<
    java -jar /genome-nexus-annotation-pipeline/annotationPipeline/target/annotationPipeline.jar \
      annotate \
      -f ~{input_maf} \
      -o ~{maf_basename} \
      -t extended
  >>>

  runtime {
    docker: "genomenexus/gn-annotation-pipeline:master"
    disk: disk_size + " GB"
    memory: "4 GB"
    cpu: 2
    preemptible: true
    maxRetries: preemptible_attempts
  }

  output {
    File output_maf = "~{maf_basename}"
  }
}

# Add missing info to cBioPortal-compliant file
task FinalEditFormat {
  input {
    File input_maf
    String maf_basename
    String maf_id
    String normal_id
    
    Int disk_size = 4
    String gatk_path
    String docker
    Int preemptible_attempts = 3
  }

  command <<< 
    sed 's/GRCh37/GRCh38/g' ~{maf_basename} | 
    awk -F "\t" 'OFS="\t" {
      gsub("Unknown", "~{maf_id}", $8); print > ("~{maf_basename}");
    }'
  >>>

  runtime {
    docker: docker
    disk: disk_size + " GB"
    memory: "4 GB"
    cpu: 2    
    preemptible: true
    maxRetries: preemptible_attempts
  }

  output {
    File output_maf = "~{maf_basename}"
  }
}