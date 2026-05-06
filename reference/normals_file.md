# Location of the cached normals data

Returns the *expected* file path of the location of cached normals data.
Only the most current normals data are provided as a full data download
by ECCC, so only these normals are cached locally. Note that if you
haven't downloaded the normals files yet (call `normals_dl(...)`) these
files will not exist.

## Usage

``` r
normals_file(normals_years = "1991-2020", type = "normals")
```

## Arguments

- normals_years:

  Character. Years to load. Currently only `1991-2020` is available.

- type:

  Character. Data type to load, one of "normals", or "meta" (the
  composite station inventory).

## Value

Character file path.

## Examples

``` r
normals_file()
#> [1] "~/.local/share/weathercan/1991-2020_Canadian_Climate_Normals_CANADA_Data.csv"
```
