#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.modules_path = "${projectDir}/modules.nf"

include { buildDatabase } from params.modules_path
include { repeatmodeler } from params.modules_path
include { repeatmasker } from params.modules_path

params.input = ""

workflow {
    buildDatabase(params.input)
    repeatmodeler(buildDatabase.out.output_dir,buildDatabase.out.fastaFile)
    repeatmasker(buildDatabase.out.fastaFile,repeatmodeler.out.output_dir)
}

