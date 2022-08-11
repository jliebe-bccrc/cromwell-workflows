# Ubam PreProcessing Workflow
Workflow for pre-processing of samples before somatic or germline variant calling.

Takes a BAM file as input, and outputs analysis-ready BAM files. Based off of a pre-processing pipeline developed by Microsoft for pre-processing and germline variant calling, found in the [Microsoft GATK4 Genome Processing repository](httpsgithub.commicrosoftgatk4-genome-processing-pipeline-azure).

The original workflow was modified to include the initial conversion of BAM to uBAM, as well as a call to samtools flagstat for extra metrics on the analysis-ready BAM file and a call to ConvertToCram (taken from the Microsoft pre-processing and germline variant calling pipeline). These changes improve the efficiency of the overall workflow by reducing the number of individual pipelines needed to produce an analysis-ready BAM.

---

**ubam-pre-pro.inputs.json:**

* Replace base_file_name with the sample ID of the sample you want to pre-process.
* Do NOT change sample_name; that is a required reference.
* Replace final_gvcf_base_name with the same sample ID as used in the base_file_name line.
* Replace "input_bam" with the full filepath (or SAS token) to the input BAM to be processed.

**ubam-pre-pro.trigger.json:**

* Replace WorkflowUrl with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.
* Replace WorkflowInputsUrl with the URL to a local version of the inputs.json file (in an Azure Storage Account).
* Optional: Replace WorkflowOptionsUrl andor WorkflowDependenciesUrl with the URL to a local version of the options.json andor dependencies.json files, respectively.

ubam-pre-pro.wdl

 No changes necessary.

---

### Expected Running Time
* For a 56GB input file, ubam-pre-pro will take ~21.5 hours to finish (~3.5 for BAM to uBAM conversion, plus ~18 for pre-processing).
