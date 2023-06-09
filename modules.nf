#!/usr/bin/env nextflow

process buildDatabase {
    input:
    path fastaFile                   // Input parameter: Path to a FASTA file

    output:
    path "${fastaFile}", emit:fastaFile
    path "${fastaFile}_repeatmodeler", emit:output_dir   // Output directory path

    script:
    """
    /hps/software/users/ensembl/genebuild/do1/assembly_registry/RepeatModeler-2.0.3/BuildDatabase -name repeatmodeler_db -engine ncbi "${fastaFile}"
    mkdir -p ${fastaFile}_repeatmodeler/
    mv repeatmodeler_db.* ${fastaFile}_repeatmodeler/
    """
}

process repeatmodeler{
    input:
    val databaseFile                  // Input parameter: Path to the database file

    script:
    """
    cd ${databaseFile}
    /hps/software/users/ensembl/genebuild/do1/assembly_registry/RepeatModeler-2.0.3/RepeatModeler -engine ncbi -numAddlRounds 1 -pa 10 -database repeatmodeler_db    
    """
}

process repeatmasker{
    input:
    val databaseFile
    val fastaFile

    script:
    """
    cd ${databaseFile}/../
    mkdir -p ${fastaFile}_repeatmasker && cd ${fastaFile}_repeatmasker
    /hps/software/users/ensembl/ensw/C8-MAR21-sandybridge/linuxbrew/bin/RepeatMasker -nolow -lib ${databaseFile}/repeatmodeler_db-families.fa ${fastaFile} engine RMBlast -dir .
    """
}
