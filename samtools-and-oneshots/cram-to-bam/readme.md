# CramToBam Workflow
Workflow for converting a CRAM to a BAM file.

Source GATK version of this workflow can be found at the [GATK sequence format conversion GitHub repository](https://github.com/gatk-workflows/seq-format-conversion/blob/master/cram-to-bam.wdl).

---

**cram-to-bam.inputs.json:** 

* Replace "input_cram" with the filepath to the CRAM file you want to convert.

* Replace "sample_ID" with the sample ID of the input CRAM file.

**cram-to-bam.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the CRAM file you want to convert.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**cram-to-bam.wdl:**

* No changes necessary.
