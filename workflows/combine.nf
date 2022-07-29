nextflow.enable.dsl=2

params.stitchDir = "combined" // Overwrite global param to influence output dir behaviour

include {
        stitch_image_tiles ; collect_cell_properties; collect_IoU_measures
} from "$baseDir/processes/combine.nf"

workflow combine_segmentation{
    take: 
        collected_labeled_tiles
        collected_properties
        grid_size_x
        grid_size_y
    main:

        stitch_image_tiles(grid_size_x, grid_size_y, params.utils.target_tile_size_x, params.utils.target_tile_size_y, collected_labeled_tiles)

        // Then combine the cell property csv's
        /* properties.view() */
        collect_cell_properties(collected_properties) //Saves them into a concatenated file

    emit: 
        stitched_labeled_image  = stitch_image_tiles.out
        /* concat_properties       = collect_cell_properties.out */
}

