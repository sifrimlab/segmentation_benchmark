nextflow.enable.dsl=2

include {
    calculate_biggest_resolution ; 
    pad_image as pad_dapi ; 
    pad_image as pad_ground ; 
    tile_image as tile_dapi ;
    tile_image as tile_ground ;
} from "$baseDir/processes/tile.nf"

workflow tile_images {
    take:
        DAPI // paths to dapi images seperately
        // Added this as paramter since the code I made for this needs a glob pattern, and I'm too lazy to  change it since we have access to it any way, it's just a bit less clean
        DAPI_glob_pattern 
    main:
        ground_truth_data = Channel.fromPath(params.ground_truth)
        calculate_biggest_resolution(params.utils.target_tile_size_x, params.utils.target_tile_size_y, DAPI_glob_pattern)

        // Rename variables for readability
        max_x_resolution =  calculate_biggest_resolution.out.max_x_resolution
        max_y_resolution = calculate_biggest_resolution.out.max_y_resolution 
        xdiv = calculate_biggest_resolution.out.xdiv 
        ydiv = calculate_biggest_resolution.out.ydiv 
                
        pad_dapi(DAPI, max_x_resolution, max_y_resolution)
        tile_dapi(pad_dapi.out, xdiv, ydiv)

        if (params.utils.tile == true) {
            pad_ground(ground_truth_data, max_x_resolution, max_y_resolution)
            tile_ground(pad_ground.out, xdiv, ydiv)
            ground_truth_data = tile_ground.out.flatten()
        }

    emit:
        DAPI = tile_dapi.out.flatten()
        ground_truth = ground_truth_data
        grid_size_x = xdiv
        grid_size_y = ydiv
}
