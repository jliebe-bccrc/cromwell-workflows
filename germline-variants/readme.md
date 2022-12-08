# GermlineVariants Workflow
Workflow for calling germline variants on a normal sample BAM file.
This workflow is derived from the [Microsoft GATK4 Genome Processing pipeline](https://github.com/microsoft/gatk4-genome-processing-pipeline-azure).

---

**germline-variants.inputs.json:** 

* Replace "base_file_name" and "final_gvcf_base_name" with the sample ID of the input BAM file.

* Replace "input_bam" with the filepath to the input BAM file.
* Replace "input_bam_index" with the filepath to the input BAM index (.bai) file.

**germline-variants.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account).

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**germline-variants.wdl:**

* No changes necessary.
