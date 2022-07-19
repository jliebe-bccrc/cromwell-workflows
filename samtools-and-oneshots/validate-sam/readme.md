# ValidateSam Workflow
Workflow for validating one or more input BAM file(s).

Source GATK version of this workflow can be found at the [GATK sequence format conversion GitHub repository](https://github.com/gatk-workflows/seq-format-validation/blob/master/validate-bam.wdl).

---

**validate-sam.inputs.json:** 

* Replace "input_bam" with the filepath to the BAM file you want to validate.

**validate-sam.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file(s) you want to validate.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**validate-sam.wdl:**

* No changes necessary.
