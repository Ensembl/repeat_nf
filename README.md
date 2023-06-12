# Repeat NextFlow Pipeline

Code for NextFlow pipeline to find and annotate repeats (GSoC project). Currently, the pipeline consists of three processes: `buildDatabase`, `repeatmodeler`, and `repeatmasker`.

## Requirements

To run this pipeline, make sure you have the following requirements installed:

- [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) version 11 or above
- [Nextflow](https://www.nextflow.io/) version 21.04.3 or above
- [RepeatModeler](https://www.repeatmasker.org/RepeatModeler/) version 2.0.3
- [RepeatMasker](https://www.repeatmasker.org/RepeatMasker/) 

## Installation

1. Install Java Development Kit (JDK) version 11 or above by following the installation instructions provided by the JDK provider.

2. Install Nextflow by following the instructions provided in the [Nextflow documentation](https://www.nextflow.io/docs/latest/getstarted.html).

3. Download RepeatModeler version 2.0.3 from the official website: [RepeatModeler](https://www.repeatmasker.org/RepeatModeler/).

4. Extract the RepeatModeler archive to a desired location on your system.

5. Install RepeatMasker compatible with RMBlast. Follow the installation instructions provided by the RepeatMasker project.

## Usage

1. Clone this repository to your local machine or download the files directly.

2. Open the `modules.nf` file and update the paths to the RepeatModeler and RepeatMasker executables (`BuildDatabase`, `RepeatModeler`, and `RepeatMasker`) with the correct paths on your system.

3. Open a terminal or command prompt and navigate to the cloned/downloaded repository.

4. Run the pipeline using the following command:

   ```
   nextflow run repeat_pipeline.nf --input /path/to/Fastafile/
   ```
   
5. The pipeline will execute the `buildDatabase` process first, followed by the `repeatmodeler` process using the output directory from `buildDatabase`, and finally the `repeatmasker` process using the output from `repeatmodeler`.

6. The results will be generated in the specified output directory (`params.outDir`) or the default output directory if not provided.

