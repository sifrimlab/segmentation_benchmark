nextflow.enable.dsl=2

include {
        stardist_segment
} from "$baseDir/processes/stardist.nf"

include {
        measure_regionprops
} from "$baseDir/processes/analyse.nf"

workflow stardist {
    take:
        DAPI // paths to dapi images seperately
        // Added this as paramter since the code I made for this needs a glob pattern, and I'm too lazy to  change it since we have access to it any way, it's just a bit less clean
    main:
        stardist_segment(DAPI)

        measure_regionprops(stardist_segment.out)
    emit:
        labeled_images = stardist_segment.out
        properties = measure_regionprops.out
}
