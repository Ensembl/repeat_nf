nextflow.enable.dsl=2

params.modules_path="${projectDir}/modules.nf"
params.outDir = "${workDir}"

include {buildDatabase} from params.modules_path
include {repeatmodeler} from params.modules_path
include {repeatmasker} from params.modules_path

params.input = ""                                 // Input parameter(path to your input fasta file)

workflow {
    buildDatabase(params.input)                  // Execute the 'buildDatabase' process with the input parameter
    repeatmodeler(buildDatabase.out.output_dir)  // Execute the 'repeatmodeler' process with the output directory from 'buildDatabase' as input
    repeatmasker(buildDatabase.out.output_dir,buildDatabase.out.fastaFile)
}

