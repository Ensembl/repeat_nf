#!/usr/bin/env nextflow

process buildDatabase {
    input:
    path fastaFile

    output:
    path "${fastaFile}_repeatmodeler", emit:output_dir

    script:
    """
    /hps/software/users/ensembl/genebuild/do1/assembly_registry/RepeatModeler-2.0.3/BuildDatabase -name repeatmodeler_db -engine ncbi "${fastaFile}"
    mkdir -p ${fastaFile}_repeatmodeler/
    mv repeatmodeler_db.* ${fastaFile}_repeatmodeler/
    """
}

process repeatmodeler{
    input:
    val databaseFile

    script:
    """
    cd ${databaseFile}
    /hps/software/users/ensembl/genebuild/do1/assembly_registry/RepeatModeler-2.0.3/RepeatModeler -engine ncbi -numAddlRounds 1 -pa 10 -database repeatmodeler_db    
    """
}


