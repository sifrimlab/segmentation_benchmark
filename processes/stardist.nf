nextflow.enable.dsl=2

import java.nio.file.Paths

moduleName = "stardist"

//workflow.projectDir points to the dir that the initial workflow originates from
binDir = Paths.get(workflow.projectDir.toString(), "bin/$moduleName/")


process stardist_segment {
    publishDir "$params.global.outdir/labeled/", mode: 'symlink'

    input: 
    path DAPI_image

    output:
    path "${DAPI_image.baseName}_labeled.tif"
    
    script:
    """
    python $binDir/segment.py $DAPI_image $DAPI_image.baseName
    """
}

