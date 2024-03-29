# Custom Pre-Processing Workflow
Workflow for pre-processing of samples before somatic or germline variant calling.

Takes an unmapped BAM file as input, and outputs analysis-ready BAM files. Based off of a pre-processing pipeline developed by Microsoft for pre-processing and germline variant calling, found in the [Microsoft GATK4 Genome Processing repository](https://github.com/microsoft/gatk4-genome-processing-pipeline-azure).

Extra steps were added in for further sample processing, in order to improve efficiency and reduce the usage of extra individual pipelines; the two extra steps are a call to samtools flagstat and ConvertToCram, which was taken from Microsoft's pre-processing and germline variant calling pipeline (mentioned above).

Pre-processing follows the steps shown in the image below:

<p align="center"><img src="https://user-images.githubusercontent.com/107152811/206559665-e3878989-104d-4bd7-ace0-b5b86deeb0d6.png" width="300"</p>

---

**custom-pre-pro.inputs.json:**

* Replace base_file_name with the sample ID of the sample you want to pre-process.
* Do NOT change sample_name; that is a required reference.
* Replace flowcell_unmapped_bams with a list of filepaths to unmapped BAMs (outputs of bam-to-unmapped-bam workflow, or CleanPDX for PDX samples), one per line, with a comma between every filepath. Make sure they are all from the same sample - they should all have the same sample ID.
* Replace final_gvcf_base_name with the same sample ID as used in the base_file_name line.

**custom-pre-pro.trigger.json:**

* Replace WorkflowUrl with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.
* Replace WorkflowInputsUrl with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the appropriate sample ID and filepath(s) to unmapped BAM(s).
* Optional Replace WorkflowOptionsUrl andor WorkflowDependenciesUrl with the URL to a local version of the options.json andor dependencies.json files, respectively.

**custom-pre-pro.wdl:**

* No changes necessary.

---

### Expected Running Time
 For 3 input uBAM files ~115GB each in size (running in parallel), custom-pre-processing will take ~24 hours to finish.
