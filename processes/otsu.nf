nextflow.enable.dsl=2

import java.nio.file.Paths

params.local_outdir = "otsu"

moduleName = "otsu"

//workflow.projectDir points to the dir that the initial workflow originates from
binDir = Paths.get(workflow.projectDir.toString(), "bin/$moduleName/")


process otsu_segment {
    publishDir "$params.global.outdir/$params.local_outdir/labeled/", mode: 'symlink'

    input: 
    path DAPI_image

    output:
    path "${DAPI_image.baseName}_labeled.tif"
    
    script:
    """
    python $binDir/segment.py $DAPI_image $DAPI_image.baseName 
    """
}

