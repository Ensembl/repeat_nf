nextflow.enable.dsl=2

params.modules_path="${projectDir}/modules.nf"
params.outDir = "${workDir}"

include {buildDatabase} from params.modules_path
include {repeatmodeler} from params.modules_path

params.input = ""

workflow {
    buildDatabase(params.input) 
    repeatmodeler(buildDatabase.out.output_dir)
}

