# MafConcatter Workflow
The maf-concatter workflow takes two or more MAF (or TXT) files that have been formatted according to cBioPortal's standards for mutation data and appends them to the end of either a template file that contains the appropriate column headers, or an existing cBioPortal mutation data file. The first task, RemoveHeader, removes the first row (the header row) of each input file so that these rows are not repeated within the final output file. 

---

**maf-concatter.inputs.json:** 

* Replace "MafConcatter.input_maf_files" with the filepaths to the MAF files you want to concatenate together.
* Replace "MafConcatter.data_type" with the cBioPortal mutation data type (extended or minimal).
* Replace "MafConcatter.template_file" with the filepath to the template mutation data file (either just the header row plus newline, or existing cBioPortal mutation data file that you want to add more data to).


**maf-concatter.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account).

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**maf-concatter.wdl:**

* No changes necessary.

---

### Expected Running Time
* For anywhere between two and twenty ~80MB input MAF files, maf-concatter will take ~30 minutes to finish.
