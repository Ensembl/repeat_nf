#!/usr/bin/env nextflow

process buildDatabase {
    input:
    path fastaFile                   // Input parameter: Path to a FASTA file

    output:
    path "${fastaFile}", emit:fastaFile
    path "${fastaFile}_database", emit:output_dir   // Output directory path

    script:
    """
    /opt/RepeatModeler/BuildDatabase -name repeatmodeler_db -engine ncbi "${fastaFile}"
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
    /opt/RepeatModeler/RepeatModeler -engine ncbi -numAddlRounds 1 threads 40 -database ${databaseFile}/repeatmodeler_db    
    cp ${databaseFile}/repeatmodeler_db-families.fa ./
    """
}

process repeatmasker{
    input:
    val fastaFile
    val databaseFile
    val engine

    script:
    """
    mkdir -p repeatmasker_output/ && cd repeatmasker_output/
    /opt/RepeatMasker/RepeatMasker -nolow -lib "${databaseFile}/repeatmodeler_db-families.fa" "${fastaFile}" engine "${engine}" -dir . -gff
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
    /opt/rmblast/bin/dustmasker -in ${fastaFile} -out dustmasker.out 
    """
}

process trf{
    input:
    val fastaFile

    output:
    path "trf_output", emit:output_dir

    shell:
    '''
    mkdir -p trf_output/ && cd trf_output/
    bash -c '/opt/trf !{fastaFile} 2 5 7 80 10 40 500 -d -h' || echo "processed $? TRs"
    '''
}

