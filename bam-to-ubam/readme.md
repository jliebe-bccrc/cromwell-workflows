Workflow for the conversion of BAM files to unmapped BAM files, which can be used as inputs into the pre-processing pipeline. 

**bam-to-unmapped-bams.inputs.json:** 

-Replace "filepath/to/bam_file.bam" with the filepath to the BAM file you want to convert.

**bam-to-unmapped-bams.trigger.json:**

-Replace "https://url/to/workflow.wdl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

-Replace "https://url/to/inputs.json" with the URL to a local version of the inputs.json file (in an Azure Storage Account), updated with the BAM file you want to convert.

**bam-to-unmapped-bams.wdl:**

-No changes necessary.
