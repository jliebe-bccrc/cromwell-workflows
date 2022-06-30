# MafFuncotator Workflow
Workflow for funcotating an input VCF file and outputting in MAF format (VCF to MAF conversion).

Source GATK version of this workflow can be found at the [GATK GitHub repository](https://github.com/broadinstitute/gatk/tree/master/scripts/funcotator_wdl) for the Funcotator workflow.

---

**maf-funcotator.inputs.json:** 

* Replace "MafFuncotator.varaint_vcf_to_funcotate" with the filepath to the filtered VCF file returned by FilterAlignmentArtifacts in the mutect2 workflow.
* Replace "MafFuncotator.varaint_vcf_to_funcotate_index" with the filepath to the index file (.idx) of the filtered VCF file above.
* Replace "MafFuncotator.sample_ID" with the tumor ID of the filtered VCF file that went through mutect2.
* Replace "MafFuncotator.funco_data_sources_tar_gz" with the filepath to the tar and gzipped Funcotator references (see Confluence page on Mutect2 for more information).


**maf-funcotator.trigger.json:**

* Replace "WorkflowUrl" with the URL to either a local version of the WDL (in an Azure Storage Account), or the URL to the version available in this repository online.

* Replace "WorkflowInputsUrl" with the URL to a local version of the inputs.json file (in an Azure Storage Account) with the necessary updated filepaths.

* Optional: Replace "WorkflowOptionsUrl" and/or "WorkflowDependenciesUrl" with the URL to a local version of the options.json and/or dependencies.json files, respectively.

**maf-funcotator.wdl:**

* No changes necessary.

---

### Expected Running Time
* For a 35MB input file, MafFuncotator will take ~2 hours to finish.
