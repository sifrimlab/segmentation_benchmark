nextflow.enable.dsl=2

import java.nio.file.Paths

moduleName = "cellpose"
params.local_outdir = "cellpose"

//workflow.projectDir points to the dir that the initial workflow originates from
binDir = Paths.get(workflow.projectDir.toString(), "bin/$moduleName/")


process cellpose_segment {
    publishDir "$params.global.outdir/$params.local_outdir/labeled/", mode: 'symlink'

    input: 
    path DAPI_image

    output:
    path "${DAPI_image.baseName}_labeled.tif"
    
    script:
    """
    python $binDir/segment.py $DAPI_image $DAPI_image.baseName $params.model_str
    """
}

