# ReadCounter Workflow
Workflow for generating a WIG file from an input BAM and its index (or more than one BAM).

ReadCounter was developed by Daniel Lai (and Gavin Ha) in the Shah Lab at the BC Cancer Research Agency, in 2011. Daniel Lai is now with the Aparicio Lab at the BC Cancer Research Centre. The source code can be found in this repository: https://github.com/shahcompbio/hmmcopy_utils

The docker used to call ReadCounter was contributed by the Fred Hutch Lab and can be found at https://hub.docker.com/r/fredhutch/ichorcna.

---

**read-counter-multi.inputs.json:** 

Each sample gets its own section in the inputs.json file ("left" and "right", where "left" indicates the sample ID and "right" is further subdivided into "bam" and "index").

* Alter the file to fit the number of samples you want to process; in the template file here, there is room for three samples, but this can be adjusted by simply copying and pasting the sections to add more samples or removing sections to reduce the number of samples.

* Replace "sample_ID_#" with the sample ID of the BAM file for that section.

* Replace "filepath_to_input_#.bam" with the filepath to the BAM file you want to generate a WIG file from.

* Replace "filepath_to_input_#.bam.bai" with the filepath to the BAM's associated index file, in .bam.bai format (.bai by itself will not work).

**read-counter-multi.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to run flagstat on.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**read-counter-multi.wdl:**

* No changes necessary.
