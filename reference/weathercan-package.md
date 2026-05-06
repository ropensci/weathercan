# Easy downloading of weather data from Environment and Climate Change Canada

`weathercan` is an R package for simplifying the downloading of
Historical Climate Data from the Environment and Climate Change Canada
(ECCC) website (<https://climate.weather.gc.ca>)

## Details

Bear in mind that these downloads can be fairly large and performing
repeated, large downloads may use up Environment Canada's bandwidth
unnecessarily. Try to stick to what you need.

There are four main aspects of this package:

1.  Access **stations** lists

    - [`stations`](https://docs.ropensci.org/weathercan/reference/stations.md)
      (a data frame listing stations)

    - [`stations_search()`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
      identify stations by name or proximity to a location

    - [`stations_dl()`](https://docs.ropensci.org/weathercan/reference/stations_dl.md)
      re-download/update stations data

2.  Download **weather** data

- [`weather_dl()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)

1.  Merge **weather** data into other data sets through interpolation
    over time

- [`weather_interp()`](https://docs.ropensci.org/weathercan/reference/weather_interp.md)

1.  Download **climate normals** data

- [`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)

We also include several practice data sets:

- [`finches`](https://docs.ropensci.org/weathercan/reference/finches.md)

- [`kamloops`](https://docs.ropensci.org/weathercan/reference/kamloops.md)

- [`kamloops_day`](https://docs.ropensci.org/weathercan/reference/kamloops_day.md)

- [`pg`](https://docs.ropensci.org/weathercan/reference/pg.md)

As well as several vignettes available in the package and
[Online](https://docs.ropensci.org/weathercan/):

- [General
  Usage](https://docs.ropensci.org/weathercan/articles/weathercan.html):
  [`vignette("weathercan", package = "weathercan")`](https://docs.ropensci.org/weathercan/articles/weathercan.md)

- [Interpolating](https://docs.ropensci.org/weathercan/articles/interpolate_data.html):
  `vignette("interpolation", package = "weathercan")`

- [Reproducibility](https://docs.ropensci.org/weathercan/articles/reproducibility.html):
  [`vignette("reproducibility", package = "weathercan")`](https://docs.ropensci.org/weathercan/articles/reproducibility.md)

- [Flags and
  Codes](https://docs.ropensci.org/weathercan/articles/flags.html):
  [`vignette("flags", package = "weathercan")`](https://docs.ropensci.org/weathercan/articles/flags.md)

- [Weather: Terms and
  Units](https://docs.ropensci.org/weathercan/articles/glossary.html):
  [`vignette("glossary", package = "weathercan")`](https://docs.ropensci.org/weathercan/articles/glossary.md)

- [Climate Normals: Terms and
  Units](https://docs.ropensci.org/weathercan/articles/glossary_normals.html):
  [`vignette("glossary_normals", package = "weathercan")`](https://docs.ropensci.org/weathercan/articles/glossary_normals.md)

We also have some advanced articles:

- [Using `weathercan` with
  tidyhydat](https://docs.ropensci.org/weathercan/articles/tidyhydat.html))

## References

Environment and Climate Change Canada:
<https://www.canada.ca/en/environment-climate-change.html>

Glossary of terms <https://climate.weather.gc.ca/glossary_e.html>

ECCC Historical Climate Data: <https://climate.weather.gc.ca/>

## See also

Useful links:

- <https://docs.ropensci.org/weathercan/>

- <https://github.com/ropensci/weathercan/>

- Report bugs at <https://github.com/ropensci/weathercan/issues/>

## Author

**Maintainer**: Steffi LaZerte <sel@steffilazerte.ca>
([ORCID](https://orcid.org/0000-0002-7690-8360))

Other contributors:

- Sam Albers <sam.albers@gmail.com>
  ([ORCID](https://orcid.org/0000-0002-9270-7884)) \[contributor\]

- Nick Brown <nicholas512@gmail.com>
  ([ORCID](https://orcid.org/0000-0002-2719-0671)) \[contributor\]

- Kevin Cazelles <kevin.cazelles@gmail.com>
  ([ORCID](https://orcid.org/0000-0001-6619-9874)) \[contributor\]

- Richard Littauer <richard.littauer@gmail.com>
  ([ORCID](https://orcid.org/0000-0001-5428-7535)) \[contributor\]

- Shandiya Balasubramaniam
  ([ORCID](https://orcid.org/0000-0001-9928-9964)) \[contributor\]

- Mark Ciechanowski ([ORCID](https://orcid.org/0000-0002-3732-5939))
  \[contributor\]

- Jeremy Selva <jeremy1189.jjs@gmail.com>
  ([ORCID](https://orcid.org/0000-0002-4498-2662)) \[contributor\]

- Kelli F. Johnson <kelli.johnson@noaa.gov>
  ([ORCID](https://orcid.org/0000-0002-5149-451X)) \[contributor\]

- Russ Allen <mbr@historicip.com> \[contributor\]

- Everett Snieder <everett.snieder@gmail.com>
  ([ORCID](https://orcid.org/0000-0003-4997-3404)) \[contributor\]

- Josh Persi <joshpersi@gmail.com>
  ([ORCID](https://orcid.org/0000-0002-2700-6483)) \[contributor\]

- Mahjabin Oyshi <oyshimahjabin3@gmail.com>
  ([ORCID](https://orcid.org/0009-0000-7992-6727)) \[contributor\]
