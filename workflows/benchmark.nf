nextflow.enable.dsl=2


include {
        calculate_IoU
} from "$baseDir/processes/benchmark.nf"


workflow calculate_labeled_measures {
    take:
        labeled_image
        ground_truth_images
    main:
        ground_truth_images.map(){ file -> tuple((file.baseName=~ /\d+/)[0], file) }.set {ground_truth_images_mapped}

        labeled_image.map(){file -> tuple((file.baseName=~ /\d+/)[0], file) }.set {labeled_images_mapped}
        ground_truth_images_mapped.combine(labeled_images_mapped).set{combined_images}

        /* calculate_IoU(combined_images) */

    /* emit: */
    /*     calculate_IoU.out */

}

