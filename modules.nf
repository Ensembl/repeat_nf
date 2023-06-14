#!/usr/bin/env nextflow

process buildDatabase {
    input:
    path fastaFile                   // Input parameter: Path to a FASTA file

    output:
    path "${fastaFile}", emit:fastaFile
    path "${fastaFile}_database", emit:output_dir   // Output directory path

    script:
    """
    /hps/software/users/ensembl/genebuild/do1/assembly_registry/RepeatModeler-2.0.3/BuildDatabase -name repeatmodeler_db -engine ncbi "${fastaFile}"
    mkdir -p ${fastaFile}_database/
    mv repeatmodeler_db.* ${fastaFile}_database/
    """
}

process repeatmodeler{
    input:
    val databaseFile                  // Input parameter: Path to the database file
    val fastaFile

    output:
    path "repeatmodeler_output", emit:output_dir

    script:
    """
    mkdir -p repeatmodeler_output/ && cd repeatmodeler_output/
    /hps/software/users/ensembl/genebuild/do1/assembly_registry/RepeatModeler-2.0.3/RepeatModeler -engine ncbi -numAddlRounds 1 -pa 10 -database ${databaseFile}/repeatmodeler_db    
    cp ${databaseFile}/repeatmodeler_db-families.fa ./
    """
}

process repeatmasker{
    input:
    val fastaFile
    val databaseFile

    script:
    """
    mkdir -p repeatmasker_output/ && cd repeatmasker_output/
    /hps/software/users/ensembl/ensw/C8-MAR21-sandybridge/linuxbrew/bin/RepeatMasker -nolow -lib "${databaseFile}/repeatmodeler_db-families.fa" "${fastaFile}" engine RMBlast -dir . -gff
    """
}

process dust{
    input:
    val fastaFile

    output:
    path "dust_output", emit:output_dir

    script:
    """
    mkdir -p dust_output/ && cd dust_output/
    /hps/software/users/ensembl/ensw/C8-MAR21-sandybridge/linuxbrew/bin/dustmasker -in ${fastaFile} -out dustmasker.out 
    """
}
