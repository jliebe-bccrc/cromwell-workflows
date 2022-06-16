# Flagstat Workflow
Workflow for getting flagstat info from input BAM files - calls flagstat from samtools.

Reference code for this workflow can be found at the [BioWDL GitHub repository](https://github.com/biowdl/tasks/blob/develop/samtools.wdl) for samtools workflows.

---

**flagstat.inputs.json:** 

* Replace "input_bam" with the filepath to the BAM file you want to convert.
* Replace "sample_ID" with the sample ID of the input BAM file (ex., XP1849 or A95563)

**flagstat.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to convert.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**flagstat.wdl:**

* No changes necessary.

---

### Expected Running Time
* For a 117GB input file, flagstat will take ~1 hour to finish.
