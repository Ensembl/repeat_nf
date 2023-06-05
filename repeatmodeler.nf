#!/usr/bin/env nextflow

params.input = ""

process buildDatabase {
    input:
    path fastaFile

    output:
    path "directory"

    script:
    """
    uniqueName=${fastaFile}
    uniqueName=\${uniqueName}_repeatmodeler
    mkdir \${uniqueName}
    cd \${uniqueName}
    /hps/software/users/ensembl/genebuild/do1/assembly_registry/RepeatModeler-2.0.3/BuildDatabase -name repeatmodeler_db -engine ncbi /hps/nobackup/flicek/ensembl/genebuild/purav/${fastaFile}
    cd ..
    cp -r \${uniqueName}/ /hps/nobackup/flicek/ensembl/genebuild/purav/rptmdlrdb/
    echo "/hps/nobackup/flicek/ensembl/genebuild/purav/rptmdlrdb/\${uniqueName}" > directory
    cp directory /hps/nobackup/flicek/ensembl/genebuild/purav/rptmdlrdb/
    """
}


process rm {
    input:
    path directory

    output:
    path "directory"

    script:
    """
    source /hps/nobackup/flicek/ensembl/genebuild/purav/rptmdlrdb/path.sh
    rm /hps/nobackup/flicek/ensembl/genebuild/purav/rptmdlrdb/directory
    /hps/software/users/ensembl/genebuild/do1/assembly_registry/RepeatModeler-2.0.3/RepeatModeler -engine ncbi -numAddlRounds 1 -pa 10 -database repeatmodeler_db
    """
}

workflow {
    directoryPath = buildDatabase((params.input))
    outputPath = directoryPath.map { it + "/output" }

    directoryPath | rm
}

