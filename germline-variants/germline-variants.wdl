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
## Modified by Jenna Liebe at the Aparicio Lab (BC Cancer Research Centre) November 2022.
##
## This pipeline has been modified from its original, which can be found at 
## https://github.com/microsoft/gatk4-genome-processing-pipeline-azure. Major changes 
## include removing all steps prior to collected aggregated metrics; changing the default pipeline
## settings to output a VCF instead of a gVCF file; and renaming the workflow to 
## "GermlineWorkflow". The purpose of this workflow is to be a standalone germline variant calling
## pipeline, for those normal samples that have already undergone preprocessing.

import "https://raw.githubusercontent.com/jliebe-bccrc/cromwell-workflows/main/ubam-germline-pre-pro/tasks/AggregatedBamQC.wdl" as AggregatedQC
import "https://raw.githubusercontent.com/jliebe-bccrc/cromwell-workflows/main/ubam-germline-pre-pro/tasks/Qc.wdl" as QC
import "https://raw.githubusercontent.com/jliebe-bccrc/cromwell-workflows/main/ubam-germline-pre-pro/tasks/VariantCalling.wdl" as ToGvcf
import "https://raw.githubusercontent.com/jliebe-bccrc/cromwell-workflows/main/ubam-germline-pre-pro/tasks/GermlineStructs.wdl"


# WORKFLOW DEFINITION
workflow GermlineWorkflow {

  String pipeline_version = "1.4"

  input {
    SampleInfo sample_info
    File input_bam
    File input_bam_index
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
  String recalibrated_bam_basename = sample_info.base_file_name + ".aligned.duplicates_marked.recalibrated"

   call AggregatedQC.AggregatedBamQC {
    input:
      base_recalibrated_bam = input_bam,
      base_recalibrated_bam_index = input_bam_index,
      base_name = sample_info.base_file_name,
      sample_name = sample_info.sample_name,
      recalibrated_bam_base_name = recalibrated_bam_basename,
      haplotype_database_file = haplotype_database_file,
      references = references,
      papi_settings = papi_settings
  }

  # QC the sample WGS metrics (stringent thresholds)
  call QC.CollectWgsMetrics as CollectWgsMetrics {
    input:
      input_bam = input_bam,
      input_bam_index = input_bam_index,
      metrics_filename = sample_info.base_file_name + ".wgs_metrics",
      ref_fasta = references.reference_fasta.ref_fasta,
      ref_fasta_index = references.reference_fasta.ref_fasta_index,
      wgs_coverage_interval_list = wgs_coverage_interval_list,
      read_length = read_length,
      preemptible_tries = papi_settings.agg_preemptible_tries
  }

  # QC the sample raw WGS metrics (common thresholds)
  call QC.CollectRawWgsMetrics as CollectRawWgsMetrics {
    input:
      input_bam = input_bam,
      input_bam_index = input_bam_index,
      metrics_filename = sample_info.base_file_name + ".raw_wgs_metrics",
      ref_fasta = references.reference_fasta.ref_fasta,
      ref_fasta_index = references.reference_fasta.ref_fasta_index,
      wgs_coverage_interval_list = wgs_coverage_interval_list,
      read_length = read_length,
      preemptible_tries = papi_settings.agg_preemptible_tries
  }

  call ToGvcf.VariantCalling as BamToGvcf {
    input:
      calling_interval_list = references.calling_interval_list,
      evaluation_interval_list = references.evaluation_interval_list,
      haplotype_scatter_count = references.haplotype_scatter_count,
      break_bands_at_multiples_of = references.break_bands_at_multiples_of,
      input_bam = input_bam,
      input_bam_index = input_bam_index,
      ref_fasta = references.reference_fasta.ref_fasta,
      ref_fasta_index = references.reference_fasta.ref_fasta_index,
      ref_dict = references.reference_fasta.ref_dict,
      dbsnp_vcf = references.dbsnp_vcf,
      dbsnp_vcf_index = references.dbsnp_vcf_index,
      base_file_name = sample_info.base_file_name,
      final_vcf_base_name = sample_info.final_gvcf_base_name,
      agg_preemptible_tries = papi_settings.agg_preemptible_tries,
      use_gatk3_haplotype_caller = use_gatk3_haplotype_caller
  }

  # Outputs that will be retained when execution is complete
  output {
    File read_group_alignment_summary_metrics = AggregatedBamQC.read_group_alignment_summary_metrics
    File read_group_gc_bias_detail_metrics = AggregatedBamQC.read_group_gc_bias_detail_metrics
    File agg_alignment_summary_metrics = AggregatedBamQC.agg_alignment_summary_metrics
    File agg_gc_bias_detail_metrics = AggregatedBamQC.agg_gc_bias_detail_metrics

    File wgs_metrics = CollectWgsMetrics.metrics
    File raw_wgs_metrics = CollectRawWgsMetrics.metrics
    
    File gvcf_summary_metrics = BamToGvcf.vcf_summary_metrics
    File gvcf_detail_metrics = BamToGvcf.vcf_detail_metrics
    File output_vcf = BamToGvcf.output_vcf
    File output_vcf_index = BamToGvcf.output_vcf_index
  }
}