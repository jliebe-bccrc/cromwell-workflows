# CleanPDX Workflow

Workflow for stripping out mouse reads from patient-derived xenograft tumor samples.

This workflow was developed from scratch, using components of other existing workflows:
* SamToFastqAndBwaMem: see custom/germline pre-processing workflow's SamToFastqAndBwaMemAndMba task

* SortBwaBam/SortSam: see BAM to uBAM workflow's SortSam task

CleanPDX follows the steps outlined below:

<p align="center"><img src="https://user-images.githubusercontent.com/107152811/206541260-7f603694-f270-4ffe-bfa4-649d82ccf180.png" width="300"></p>

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

For a 122GB input BAM file, CleanPDX will take ~54 hours to complete.

---

### Creating the Chimeric Reference Genome

To create the chimeric mouse/human (mm10/hg38) genome, both individual genomes were downloaded to a local stoarge account. All the mouse chromosomes were renamed to make them distinct from the human genomes; ex., renamed all chromosomes from "chr1" to "m_chr1". The updated mouse genome was then concatenated to the human genome to create the chimeric genome. BWA Index, samtools-faidx and samtools-dict were used to create the other required reference files.
* mm10 genome: http://hgdownload.cse.ucsc.edu/goldenpath/mm10/bigZips/latest/
* hg38 genome: https://storage.googleapis.com/genomics-public-data/references/hg38/v0/Homo_sapiens_assembly38.fasta
