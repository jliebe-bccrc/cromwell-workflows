# Flagstat Workflow
Workflow for generating flagstat info for an input BAM.

Source GATK version of this workflow can be found at the [BioWDL GitHub repository](https://github.com/biowdl/tasks/blob/develop/samtools.wdl), under the "Flagstat" task.

---

**flagstat.inputs.json:** 

* Replace "input_bam" with the filepath to the BAM file you want to convert.

* Replace "sample_ID" with the sample ID of the input BAM file.

**flagstat.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to run flagstat on.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**flagstat.wdl:**

* No changes necessary.
