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

include{
    calculate_labeled_measures
} from "$baseDir/workflows/benchmark.nf" 
include {
        collect_IoU_measures
} from "$baseDir/workflows/combine.nf"

workflow stardist {

    read_DAPI(params.DAPI_glob_pattern, params.ground_truth)

    // Assign data variables for future use
    DAPI = read_DAPI.out.DAPI
    ground_truth_images = read_DAPI.out.ground_truth
    grid_size_x = read_DAPI.out.grid_size_x
    grid_size_y = read_DAPI.out.grid_size_y

    stardist_workflow(DAPI, grid_size_x, grid_size_y)
    labeled_images = stardist_workflow.out.labeled_images

    calculate_labeled_measures(labeled_images, ground_truth_images)

    calculate_labeled_measures.out.collectFile(name: "$params.global.outdir/benchmark/concat_IoU_measures.csv", sort:true, keepHeader:true).set {concat_IoU_measures}

}

workflow cellpose {

    read_DAPI(params.DAPI_glob_pattern, params.ground_truth)

    // Assign data variables for future use
    DAPI = read_DAPI.out.DAPI
    ground_truth_images = read_DAPI.out.ground_truth
    grid_size_x = read_DAPI.out.grid_size_x
    grid_size_y = read_DAPI.out.grid_size_y

    cellpose_workflow(DAPI, grid_size_x, grid_size_y)
    labeled_images = cellpose_workflow.out.labeled_images

    calculate_labeled_measures(labeled_images, ground_truth_images)

    calculate_labeled_measures.out.collectFile(name: "$params.global.outdir/benchmark/concat_IoU_measures.csv", sort:true, keepHeader:true).set {concat_IoU_measures}
}
