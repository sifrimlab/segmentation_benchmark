nextflow.enable.dsl=2

import java.nio.file.Paths

moduleName = "benchmark"

//workflow.projectDir points to the dir that the initial workflow originates from
binDir = Paths.get(workflow.projectDir.toString(), "bin/$moduleName/")


process calculate_IoU {
    publishDir "$params.global.outdir/benchmark/", mode: 'symlink'

    input: 
    tuple val(val), path(labeled_image), path(ground_truth)

    output:
    path "${ground_truth.baseName}_IoU.csv"
    
    script:
    """
    python $binDir/calculateIoU.py $labeled_image $ground_truth
    """
}

