# BamToCram Workflow
Workflow for converting a BAM to a CRAM file.

Source GATK version of this workflow can be found at the [Microsoft GATK4 Genome Processing GitHub repository](https://github.com/microsoft/gatk4-genome-processing-pipeline-azure/blob/main-azure/tasks/BamToCram.wdl), under the "BamToCram/ConvertCram" task.

---

**bam-to-cram.inputs.json:** 

* Replace "input_bam" with the filepath to the BAM file you want to convert.

* Replace "sample_ID" with the sample ID of the input BAM file.

**bam-to-cram.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to convert.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**bam-to-cram.wdl:**

* No changes necessary.
