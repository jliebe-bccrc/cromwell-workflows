version 1.0

## Copyright Broad Institute, 2018 and Aparicio Lab (BCCRC), 2022
##
## This WDL pipeline implements data pre-processing according to the GATK Best Practices 
## (June 2016) for human whole-genome data.
##
## Requirements/expectations :
## - Human whole-genome pair-end sequencing data in unmapped BAM (uBAM) format
## - One or more read groups, one per uBAM file, all belonging to a single sample (SM)
## - Input uBAM files must additionally comply with the following requirements:
## - - filenames all have the same suffix (we use ".unmapped.bam")
## - - files must pass validation by ValidateSamFile
## - - reads are provided in query-sorted order
## - - all reads must have an RG tag
## - Reference genome must be Hg38 with ALT contigs
##
## Runtime parameters are optimized for Broad's Google Cloud Platform implementation.
## For program versions, see docker containers.
##
## LICENSING :
## This script is released under the WDL source code license (BSD-3) (see LICENSE in
## https://github.com/broadinstitute/wdl). Note however that the programs it calls may
## be subject to different licenses. Users are responsible for checking that they are
## authorized to run all programs before running this script. Please see the docker
## page at https://hub.docker.com/r/broadinstitute/genomes-in-the-cloud/ for detailed
## licensing information pertaining to the included programs.
## 
## UPDATE NOTES :
## Updated by Aparicio Lab (BC Cancer Research Centre) May 2022.
##
## This pipeline has been modified from its original, which can be found at 
## https://github.com/microsoft/gatk4-genome-processing-pipeline-azure. Major changes include
## removing all germline SNP/indel calling functionality; pipeline is now just used for
## converting unmapped BAM files (uBAMs) into analysis-ready BAM files, that can be
## used in later analysis (ex., somatic variant calling); and renaming the workflow to "PreProcessing".
## It also includes the call to BamToCram for Cram output files.

import "https://raw.githubusercontent.com/microsoft/gatk4-genome-processing-pipeline-azure/az1.1.0/tasks/UnmappedBamToAlignedBam.wdl" as ToBam
import "https://raw.githubusercontent.com/jliebe-bccrc/cromwell-workflows/main/ubam-pre-pro/tasks/BamToCram.wdl" as ToCram


# WORKFLOW DEFINITION
workflow PreProcessing {

  String pipeline_version = "1.4"

  input {
    SampleAndUnmappedBams sample_and_unmapped_bams
    GermlineSingleSampleReferences references
    PapiSettings papi_settings
    File wgs_coverage_interval_list

    File? haplotype_database_file
    Boolean provide_bam_output = true
    Boolean use_gatk3_haplotype_caller = false
  }

  # Not overridable:
  Int read_length = 250
  Float lod_threshold = -20.0
  String cross_check_fingerprints_by = "READGROUP"
  String recalibrated_bam_basename = sample_and_unmapped_bams.base_file_name + ".aligned.duplicates_marked.recalibrated"

  call ToBam.UnmappedBamToAlignedBam {
    input:
      sample_and_unmapped_bams    = sample_and_unmapped_bams,
      references                  = references,
      papi_settings               = papi_settings,

      contamination_sites_ud = references.contamination_sites_ud,
      contamination_sites_bed = references.contamination_sites_bed,
      contamination_sites_mu = references.contamination_sites_mu,

      cross_check_fingerprints_by = cross_check_fingerprints_by,
      haplotype_database_file     = haplotype_database_file,
      lod_threshold               = lod_threshold,
      recalibrated_bam_basename   = recalibrated_bam_basename
  }

  if (provide_bam_output) {
    File provided_output_bam = UnmappedBamToAlignedBam.output_bam
    File provided_output_bam_index = UnmappedBamToAlignedBam.output_bam_index
  }

  call ToCram.BamToCram {
    input:
      input_bam = UnmappedBamToAlignedBam.output_bam,
      ref_fasta = references.reference_fasta.ref_fasta,
      ref_fasta_index = references.reference_fasta.ref_fasta_index,
      ref_dict = references.reference_fasta.ref_dict,
      base_file_name = sample_and_unmapped_bams.base_file_name,
      agg_preemptible_tries = papi_settings.agg_preemptible_tries
  }

  call Flagstat {
    input:
      input_bam = UnmappedBamToAlignedBam.output_bam,
      output_name = sample_and_unmapped_bams.base_file_name + ".flagstat.txt"
  }

  # Outputs that will be retained when execution is complete
  output {
    Array[File] quality_yield_metrics = UnmappedBamToAlignedBam.quality_yield_metrics

    File duplicate_metrics = UnmappedBamToAlignedBam.duplicate_metrics
    File output_bqsr_reports = UnmappedBamToAlignedBam.output_bqsr_reports

    # Temp fix - workflow fails when trying to copy BAM file, so just have to copy manually
    #File? output_bam = provided_output_bam
    
    File? output_bam_index = provided_output_bam_index

    # Temp fix - workflow fails when trying to copy larger CRAM file, so just have to copy manually
    #File output_cram = BamToCram.output_cram

    File output_cram_index = BamToCram.output_cram_index
    File output_cram_md5 = BamToCram.output_cram_md5

    File output_flagstat = Flagstat.output_file
  }
}


task Flagstat {
  input {
    File input_bam
    String output_name
  }

  Int disk = ceil(size(input_bam, "GB") * 2)
    
  command <<< 
    samtools flagstat ~{input_bam} > ~{output_name}
  >>>

  runtime {
    docker: "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.3-1564508330"
    disk: disk + " GB"
    cpu: 4
    preemptible: true
  }

  output {
    File output_file = "~{output_name}"
  }
}