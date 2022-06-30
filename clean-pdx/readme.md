# CleanPDX Workflow

## THIS WORKFLOW IS IN DEVELOPMENT

Workflow for stripping out mouse reads from passaged tumor samples, and converting final output to uBAM for direct piping into the pre-processing workflow.

This workflow was developed from scratch, using components of other existing workflows:
* SamToFastqAndBwaMem: see custom/germline pre-processing workflow's SamToFastqAndBwaMemAndMba task

* SortBwaBam/SortSam: see BAM to uBAM workflow's SortSam task

---

**clean-pdx.inputs.json:** 

* Replace "input_bam" with the filepath to the BAM file you want to clean.

* Replace "sample_ID" with the sample ID of the BAM file you want to clean.

**clean-pdx.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to clean and its sample ID.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**clean-pdx.wdl:**

* No changes necessary.

---

### Expected Running Time
* For a 128GB input file, clean-pdx will take ~53 hours to finish.
