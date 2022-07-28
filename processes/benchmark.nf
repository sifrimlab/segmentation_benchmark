nextflow.enable.dsl=2

import java.nio.file.Paths

params.local_outdir="global"

moduleName = "benchmark"

//workflow.projectDir points to the dir that the initial workflow originates from
binDir = Paths.get(workflow.projectDir.toString(), "bin/$moduleName/")


process calculate_IoU {
    publishDir "$params.global.outdir/$params.local_outdir/benchmark/", mode: 'symlink'

    input: 
    tuple path(labeled_image), path(ground_truth)
    val method

    output:
    path "${ground_truth.baseName}_IoU.csv"
    
    script:
    """
    python $binDir/calculateIoU.py $labeled_image $ground_truth $method
    """
}

