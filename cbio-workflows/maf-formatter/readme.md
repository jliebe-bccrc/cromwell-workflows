# MafFormatter Workflow
The cbio-ext-maf-formatter workflow takes a filtered, annotated MAF file as input (produced by the Mutect2 workflow), selects just the data columns that are recommended for cBioPortal’s display of mutation data, and edits the format of the file to adhere to cBioPortal’s requirements. 

---

**cbio-ext-maf-formatter.inputs.json:** 

* Replace "CbioExtMafFormatter.input_maf" with the filepath to the MAF file you want to format.
* Replace "CbioExtMafFormatter.maf_id" with the ID of the tumor sample.
* Replace "CbioExtMafFormatter.normal_id" with the ID of the matched normal sample.


**cbio-ext-maf-formatter.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account).

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**cbio-ext-maf-formatter.wdl:**

* No changes necessary.

---

### Expected Running Time
* For an 83MB input MAF file, cbio-ext-maf-formatter will take ~10 minutes to finish.
