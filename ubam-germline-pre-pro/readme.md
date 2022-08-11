# Ubam Germline Pre-Processing Workflow
Workflow for pre-processing of samples, and subsequent germline variant calling

Takes a BAM file as input, and outputs analysis-ready BAM files along with germline variant annotations (in VCF format). Pipeline was developed by Microsoft and can be found in the [Microsoft GATK4 Genome Processing repository](https://github.com/microsoft/gatk4-genome-processing-pipeline-azure).

The original workflow was modified to include the initial conversion of BAM to uBAM, as well as a call to samtools flagstat for extra metrics on the analysis-ready BAM file. These changes improve the efficiency of the overall workflow by reducing the number of individual pipelines needed to produce an analysis-ready BAM. 

---

**ubam-germline-pre-pro.inputs.json:** 

* Replace "base_file_name" with the sample ID of the sample you want to pre-process.
* Do NOT change "sample_name"; that is a required reference.
* Replace "final_gvcf_base_name" with the same sample ID as used in the "base_file_name" line.
* Replace "input_bam" with the full filepath (or SAS token) to the input BAM to be processed.

**ubam-germline-pre-pro.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account).

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**ubam-germline-pre-pro.wdl:**

* No changes necessary.

---

### Expected Running Time
* For a 50GB input file, ubam-germline-pre-pro will take ~28.5 hours to finish (~2.5 for BAM to uBAM conversion, plus ~26 for pre-processing and germline variant calling).
