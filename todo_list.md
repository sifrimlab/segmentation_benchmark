# General todo's
- [ ] Decide on an initial dataset with DAPI and accompanying decoded genes
- [ ] Decide on evaluation metrics 
- [x] Make nextflow backbone to put modules in
- [x] Add tiling module to split input image into tiles 
- [ ] Make segmentation modules, structured in the following way
    - input: 1 image and optional decoded genes csv
    - output: labeled image + csv file with properties of segmented cells
    - optional output (In case of JSTA): assigned genes
- [ ] Make an assigment module that assigns the decoded genes to the segmented cells:
    - input: labeled image, decoded genes csv and csv file of segmented properties
    - output: decoded genes csv upgraded with the cell they were assigned to
- [x] Add module to pool segmented cells data back together
- [ ] Add seurat UMAP downstream analysis module

