# FastqToUbam Workflow
Workflow for the conversion of FASTQ files to unmapped BAM files, which can be used as inputs into the pre-processing pipeline.

Source GATK version of this workflow can be found at the [GATK GitHub repository](https://github.com/gatk-workflows/seq-format-conversion) for sequence conversion workflows.

---

**fastq-to-ubam.inputs.json:** 

* Replace "input_bam" with the filepath to the FASTQ file you want to convert.

**fastq-to-ubam.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the FASTQ file you want to convert.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**fastq-to-ubam.wdl:**

* No changes necessary.
