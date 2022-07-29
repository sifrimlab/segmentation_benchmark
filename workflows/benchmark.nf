nextflow.enable.dsl=2
params.local_outdir = "global"


include {
        calculate_IoU
} from "$baseDir/processes/benchmark.nf"


workflow calculate_labeled_measures {
    take:
        labeled_image
        ground_truth_images
        method
    main:
        if (params.utils.tile == true){
            ground_truth_images.map(){ file -> tuple((file.baseName=~ /\d+/)[0],(file.baseName=~ /tile\d+/)[0], file) }.set {ground_truth_images_mapped}
            labeled_image.map(){file -> tuple((file.baseName=~ /\d+/)[0], (file.baseName=~ /tile\d+/)[0], file) }.set {labeled_images_mapped}
            ground_truth_images_mapped.combine(labeled_images_mapped, by:[0,1]).map{it[2..-1]}.set{combined_images}
        }
        else  {
            ground_truth_images.map(){ file -> tuple((file.baseName=~ /\d+/)[0], file) }.set {ground_truth_images_mapped}
            labeled_image.map(){file -> tuple((file.baseName=~ /\d+/)[0], file) }.set {labeled_images_mapped}
            ground_truth_images_mapped.combine(labeled_images_mapped, by:0).map{it[1..-1]}.set{combined_images}
        }


        calculate_IoU(combined_images, method)

    emit:
        calculate_IoU.out

}

