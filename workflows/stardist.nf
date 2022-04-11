nextflow.enable.dsl=2

include {
        stardist_segment
} from "$baseDir/processes/stardist.nf"

include {
        measure_regionprops
} from "$baseDir/processes/analyse.nf"

include {
        combine_segmentation
} from "$baseDir/workflows/combine.nf"


workflow stardist {
    take:
        DAPI // paths to dapi images seperately
        grid_size_x
        grid_size_y
    main:
        stardist_segment(DAPI)

        measure_regionprops(stardist_segment.out)

        if (params.utils.tile == true){
            combine_segmentation(stardist_segment.out.collect(), measure_regionprops.out.collect(), grid_size_x, grid_size_y)
        }
    emit:
        labeled_images = stardist_segment.out
        properties = measure_regionprops.out
}
