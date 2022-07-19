# CleanPDX Workflow

## THIS WORKFLOW IS IN DEVELOPMENT

Workflow for stripping out mouse reads from passaged tumor samples, and converting final output to uBAM for direct piping into the pre-processing workflow.

This workflow was developed from scratch, using components of other existing workflows:
* SamToFastqAndBwaMem: see custom/germline pre-processing workflow's SamToFastqAndBwaMemAndMba task

* SortBwaBam/SortSam: see BAM to uBAM workflow's SortSam task

CleanPDX follows the steps outlined below:

<p align="center"><img src="https://user-images.githubusercontent.com/107152811/179793142-b8d8eca9-5e2e-4cd6-810f-0e64365f87b0.png" width="300"></p>

---

**clean-pdx.inputs.json:** 

* Replace "input_bam" with the filepath to the BAM file you want to clean.

* Replace "sample_ID" with the sample ID of the BAM file you want to clean.

* Replace "sample_RGID" with one of the ID's (choose one if there are multiple) listed in the input BAM's header @RG line.

* Replace "sample_PU" with one of the PU's (choose one if there are multiple) listed in the input BAM's header @RG line.

* Replace "sample_SM" with the SM value (should only be one) listed in the input BAM's header @RG line.

* Replace "sample_PL" with the PL value (should only be one) listed in the input BAM's header @RG line using all caps; for example, "ILLUMINA".

**clean-pdx.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to clean and its sample ID.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**clean-pdx.wdl:**

* No changes necessary.

---

### Expected Running Time
* For a 128GB input file, clean-pdx will take ~53 hours to finish.
