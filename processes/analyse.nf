nextflow.enable.dsl=2

import java.nio.file.Paths

moduleName = "analyse"

//workflow.projectDir points to the dir that the initial workflow originates from
binDir = Paths.get(workflow.projectDir.toString(), "bin/$moduleName/")


process measure_regionprops {
    publishDir "$params.global.outdir/regionprops/", mode: 'symlink'

    input: 
    path labeled_image

    output:
    path "${labeled_image.baseName}_properties.csv"
    
    script:
    """
    python $binDir/measureRegionprops.py $labeled_image $labeled_image.baseName
    """
}

