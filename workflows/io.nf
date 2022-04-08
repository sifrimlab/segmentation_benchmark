nextflow.enable.dsl=2

include {
        tile_images
} from "$baseDir/workflows/tile.nf"

workflow read_DAPI{
    take: 
        DAPI_glob_pattern // Glob pattern pointing to all DAPI images
    main:

        DAPI = Channel.fromPath(DAPI_glob_pattern)

        if (params.utils.tile == true) {
            tile_images(DAPI, DAPI_glob_pattern)
            DAPI = tile_images.out.DAPI
            grid_size_x =  tile_images.out.grid_size_x
            grid_size_y =  tile_images.out.grid_size_y
        }
        else {
            grid_size_x = 1
            grid_size_y = 1
        }

    emit: 
        DAPI
        grid_size_x
        grid_size_y
}
