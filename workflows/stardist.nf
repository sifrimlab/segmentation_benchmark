nextflow.enable.dsl=2
params.local_outdir = "stardist"

include {
        stardist_segment
} from "$baseDir/processes/stardist.nf"

include {
        measure_regionprops
} from "$baseDir/processes/analyse.nf"

include {
        combine_segmentation
} from "$baseDir/workflows/combine.nf"

include{
    calculate_labeled_measures
} from "$baseDir/workflows/benchmark.nf" 

/* include { */
/*         collect_IoU_measures */
/* } from "$baseDir/workflows/combine.nf" */


workflow stardist_workflow {
    take:
        DAPI // paths to dapi images seperately
        ground_truth
        grid_size_x
        grid_size_y
    main:
        stardist_segment(DAPI)

        measure_regionprops(stardist_segment.out)

        if (params.utils.tile == true){
            combine_segmentation(stardist_segment.out.collect(), measure_regionprops.out.collect(), grid_size_x, grid_size_y)
        }

        calculate_labeled_measures(stardist_segment.out, ground_truth, "stardist")
        calculate_labeled_measures.out.collectFile(name: "$params.global.outdir/$params.local_outdir/benchmark/concat_IoU_measures.csv", sort:true, keepHeader:true).set {concat_IoU_measures}
    emit:
        labeled_images = stardist_segment.out
        properties = measure_regionprops.out
        concat_IoU_measures
}
