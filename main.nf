nextflow.enable.dsl=2

include {
        read_DAPI
} from "$baseDir/workflows/io.nf"

include {
        stardist_workflow
} from "$baseDir/workflows/stardist.nf"
include {
        cellpose_workflow
} from "$baseDir/workflows/cellpose.nf"

include {
        otsu_workflow
} from "$baseDir/workflows/otsu.nf"


workflow stardist {
    read_DAPI(params.DAPI_glob_pattern, params.ground_truth)

    stardist_workflow(read_DAPI.out.DAPI, read_DAPI.out.ground_truth, read_DAPI.out.grid_size_x, read_DAPI.out.grid_size_y)
    labeled_images = stardist_workflow.out.labeled_images

    emit:
        stardist_workflow.out.concat_IoU_measures

}

workflow cellpose {
    read_DAPI(params.DAPI_glob_pattern, params.ground_truth)

    cellpose_workflow(read_DAPI.out.DAPI, read_DAPI.out.ground_truth, read_DAPI.out.grid_size_x, read_DAPI.out.grid_size_y)
    labeled_images = cellpose_workflow.out.labeled_images


    emit:
        cellpose_workflow.out.concat_IoU_measures
}

workflow otsu {
    read_DAPI(params.DAPI_glob_pattern, params.ground_truth)

    otsu_workflow(read_DAPI.out.DAPI, read_DAPI.out.ground_truth, read_DAPI.out.grid_size_x, read_DAPI.out.grid_size_y)
    labeled_images = otsu_workflow.out.labeled_images

    emit:
        otsu_workflow.out.concat_IoU_measures
}

workflow compare_all {
    otsu()
    cellpose()
    stardist()

    IoUs = otsu.out.concat(cellpose.out, stardist.out).collect()
    IoUs.view()

}
