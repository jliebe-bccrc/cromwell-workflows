# Mutect2 Workflow
Workflow for somatic variant calling; outputs both VCF and MAF format functionally annotated files.

Source GATK version of this workflow can be found at the [GATK GitHub repository](https://github.com/broadinstitute/gatk/tree/master/scripts/mutect2_wdl) for mutect2 workflows.

This workflow follows the general outline shown below:

<p align="center"><img src="https://user-images.githubusercontent.com/107152811/181548163-3fd1b990-e8dc-428a-be39-678e26b9ab6c.PNG" width="550"></p>

---

**mutect2.inputs.json:** 

* Replace "Mutect2.normal_reads" with the filepath to the BAM file containing matched normal reads (associated with the tumor reads).
* Replace "Mutect2.normal_reads_index" with the filepath to the index file (.bai) of the matched normal reads.
* Replace "Mutect2.tumor_reads" with the filepath to the BAM file containing tumor reads.
* Replace "Mutect2.tumor_reads_index" with the filepath to the index file (.bai) of the tumor reads.
* Replace lines 17-23 with the filepaths to the appropriate reference file listed.
* Replace "Mutect2.funco_data_sources_tar_gz" with the filepath to the tar and gzipped Funcotator references (see Confluence page on Mutect2 for more information).


**mutect2.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the above-mentioned normal and tumor reads/indices.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**mutect2.wdl:**

* No changes necessary.

---

### Expected Running Time
* For a 85GB normal and a 143GB tumor input, mutect2 will take ~6.5 hours to finish.
