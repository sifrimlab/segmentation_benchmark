nextflow.enable.dsl=2

include {
        read_DAPI
} from "$baseDir/workflows/io.nf"

workflow {

    read_DAPI(params.DAPI_glob_pattern)

    DAPI = read_DAPI.out.DAPI
    grid_size_x = read_DAPI.out.grid_size_x
    grid_size_y = read_DAPI.out.grid_size_y
}


