version 1.0

## This WDL file calls readCounter.cpp via a docker for ichorCNA.
## The source information follows:
##
## ***************************************************************************
## readCounter.cpp 
## (c) 2011 Daniel Lai <jujubix@cs.ubc.ca>, Gavin Ha <gha@bccrc.ca>
## Shah Lab, Department of Molecular Oncology, BC Cancer Research Agency
## All rights reserved.
## ---------------------------------------------------------------------------
## Last modified: 14 December, 2012 
## ---------------------------------------------------------------------------
## ***************************************************************************
##
## ***************************************************************************
## ichorcna Docker:
## Fred Hutch Lab, Seattle, W.A.
## https://hub.docker.com/r/fredhutch/ichorcna
## ---------------------------------------------------------------------------
## Last pushed: 2019
## ---------------------------------------------------------------------------
## ***************************************************************************
##
## This WDL pipeline is optimized for Cromwell on Azure. It is able to take in 
## one or more samples at a time and produce WIG output files for each of them,
## using the defined structure BamAndIndex to pair up input BAMs with their 
## respective indices.
##
## Expected inputs:
## --Sample BAM file(s), with the associated index file (.bam.bai) and sample ID
##
## Outputs:
## --A WIG file for each sample BAM specified in the inputs.json list
##
## The pipeline was developed by Jenna Liebe at the Aparicio Lab (BC Cancer
## Research Centre) in November 2022. 


struct BamAndIndex {
	File bam
	File index
}


# WORKFLOW DEFINITION
workflow MultiReadCounter {
	input {
		Array[Pair[String, BamAndIndex]] input_bam_files

		String read_docker = "fredhutch/ichorcna:3.6.2"
	}

	meta {allowNestedInputs: true}

	scatter(input_bam_pair in input_bam_files) {
		String sample_ID = input_bam_pair.left
		BamAndIndex bam_and_index = input_bam_pair.right

		call ReadCounter {
			input:
				input_bam = bam_and_index.bam,
				input_index = bam_and_index.index,
				sample_ID = sample_ID,
				docker = read_docker
		}
	}

	output {
		Array[File] output_wig = ReadCounter.output_wig
	}
}


# TASK DEFINITIONS

# ReadCounter is the task that will generate a sample's WIG file from the input BAM and its index
task ReadCounter {
	input {
		File input_bam
		File input_index
		String sample_ID
		String docker
	}

	Int disk_size = ceil(size(input_bam, "GB") + size(input_index, "GB")) + 40

	command <<<
		readCounter -w 1000000 -q 20 -c chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY ~{input_bam} > ~{sample_ID}.wig
	>>>

	runtime {
    	docker: docker
    	disk: disk_size + " GB"
    	cpu: 4
    	preemptible: true
	}

	output {
		File output_wig = "~{sample_ID}.wig"
	}
}