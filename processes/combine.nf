nextflow.enable.dsl=2

import java.nio.file.Paths

moduleName = "combine"

//workflow.projectDir points to the dir that the initial workflow originates from
binDir = Paths.get(workflow.projectDir.toString(), "bin/$moduleName/")

// stitchDir is supposed to be overwritten by the top-level workflow that includes it
params.stitchDir = "stitched"


process stitch_image_tiles {
    publishDir "$params.global.outdir/stitched/$params.stitchDir/", mode: 'move'

    input: 
    val tile_grid_size_x
    val tile_grid_size_y
    val tile_size_x
    val tile_size_y
    /* tuple val(image_nr), path(images) */
    path images

    output:
    path "*_stitched.tif"

    script:
    """
    python $binDir/createStitchedImage.py $tile_grid_size_x $tile_grid_size_y $tile_size_x $tile_size_y $images
    """

}

process collect_cell_properties {
    publishDir "$params.global.outdir/regionprops/", mode: 'move'

    input:
    path properties
    
    output:
    path "concat_segmented_properties.csv"

    script:
    """
    python $binDir/collectProperties.py $properties
    """
    
}

process collect_IoU_measures{
    publishDir "$params.global.outdir/benchmarks/", mode: 'move'

    input:
    path measures
    
    output:
    path "concat_measures.csv"

    script:
    """
    python $binDir/collectMeasures.py $measures
    """
}
