nextflow.enable.dsl=2

include {
        cellpose_segment
} from "$baseDir/processes/cellpose.nf"

include {
        measure_regionprops
} from "$baseDir/processes/analyse.nf"

include {
        combine_segmentation
} from "$baseDir/workflows/combine.nf"


workflow cellpose_workflow {

    take:
        DAPI // paths to dapi images seperately
        grid_size_x
        grid_size_y
    main:
        cellpose_segment(DAPI)

        measure_regionprops(cellpose_segment.out)

        if (params.utils.tile == true){
            combine_segmentation(cellpose_segment.out.collect(), measure_regionprops.out.collect(), grid_size_x, grid_size_y)
        }
    emit:
        labeled_images = cellpose_segment.out
        properties = measure_regionprops.out
}
