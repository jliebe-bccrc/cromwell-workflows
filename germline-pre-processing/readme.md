# Germline Pre-Processing Workflow
Workflow for pre-processing of samples, and subsequent germline variant calling

Takes an unmapped BAM file as input, and outputs analysis-ready BAM files along with germline variant annotations. Pipeline was developed by Microsoft and can be found in the [Microsoft GATK4 Genome Processing repository](https://github.com/microsoft/gatk4-genome-processing-pipeline-azure).

**germline-pre-processing.hg38.wgs.inputs.json:** 

* Replace "base_file_name" with the sample ID of the sample you want to pre-process.
* Do NOT change "sample_name"; that is a required reference.
* Replace "flowcell_unmapped_bams" with a list of filepaths to unmapped BAMs (outputs of bam-to-unmapped-bam workflow), one per line, with a comma between every filepath. Make sure they are all from the same sample - they should all have the same sample ID.
* Replace "final_gvcf_base_name" with the same sample ID as used in the "base_file_name" line.

**germline-pre-processing.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the appropriate sample ID and filepath(s) to unmapped BAM(s).

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**germline-pre-processing.wdl:**

* No changes necessary.
