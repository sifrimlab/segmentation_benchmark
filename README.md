# Benchmarking segmentation in spatial omics

This repository hosts a framework that benchmarks current state-of-the-art segmentation algorithms in the context of different kinds of spatial omics.


### What you need to have installed:
- Nextflow: https://www.nextflow.io/docs/latest/getstarted.html
- (Ana)Conda: https://conda.io/projects/conda/en/latest/user-guide/install/index.html

### Running a benchmark
- Clone the repository locally using:

```bash 
  git clone github.com:sifrimlab/segmentation_benchmark
```

- Modify [nexflow.config](./nextflow.config) to change path to your data and output folder

- Run whatever segmentation algorithm you want by using the following command:
 ```bash
nextflow run main.nf -entry stardist -profile stardist
```
- Where stardist can be replaced by any implemented segmentation algorithm


