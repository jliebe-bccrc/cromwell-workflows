# Reheader Workflow
Workflow for reheadering an input BAM file.

The workflow calls Picard's AddOrReplaceReadGroups on the input BAM file, given its sample ID, read group ID, PU, SM, and platform (generally Illumina), all of which can be found by examining the header of the original BAM file.

---

**reheader.inputs.json:** 

* Replace "input_bam" with the filepath to the BAM file you want to reheader.
* Replace "sample_ID", "sample_RGID", "sample_PU", "sample_SM", and "sample_PL" with the appropriate information, found in the original BAM file's header.

**reheader.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to reheader.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**reheader.wdl:**

* No changes necessary.
