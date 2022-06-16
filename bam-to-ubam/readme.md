# BamToUbam Workflow
Workflow for the conversion of BAM files to unmapped BAM files, which can be used as inputs into the pre-processing pipeline.

Source GATK version of this workflow can be found at the [GATK GitHub repository](https://github.com/gatk-workflows/seq-format-conversion) for sequence conversion workflows.

---

**bam-to-unmapped-bams.inputs.json:** 

* Replace "input_bam" with the filepath to the BAM file you want to convert.

**bam-to-unmapped-bams.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to convert.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**bam-to-unmapped-bams.wdl:**

* No changes necessary.

---

### Expected Running Time
* For a 117GB input file, bam-to-ubam will take ~7 hours to finish.
