nextflow.enable.dsl=2

include {
        read_DAPI
} from "$baseDir/workflows/io.nf"

include {
        stardist
} from "$baseDir/workflows/stardist.nf"

include{
    calculate_labeled_measures
} from "$baseDir/workflows/benchmark.nf" 

workflow {

    read_DAPI(params.DAPI_glob_pattern, params.ground_truth)

    // Assign data variables for future use
    DAPI = read_DAPI.out.DAPI
    ground_truth_images = read_DAPI.out.ground_truth
    grid_size_x = read_DAPI.out.grid_size_x
    grid_size_y = read_DAPI.out.grid_size_y

    stardist(DAPI, grid_size_x, grid_size_y)
    labeled_images = stardist.out.labeled_images

    calculate_labeled_measures(labeled_images, ground_truth_images)

}
