
Thanks to all reviewers for your time and effort, it is really appreciated. I have made changes and responded to your comments/suggestions below, quoting the commit the change was made in.

### Response to @joethorley

- A statement of need
  - [X] The README definitely requires a brief discussion of how the current package differs from rclimateca and CHCN.
    __Response:__ Added in steffilazerte/weathercan@648177d65c66e188202b6efee51a125e12d73612

- Examples
  - [X] An example is lacking for stations_all() - this is minor but technically in violation of the documentation policy.
    __Response:__ Added in steffilazerte/weathercan@1645a34a1d66fca6d8c98ec4506a5df9a9cb122d
    
- README
  - [X] The demonstration of the use of dplyr::select is unnecessary in the README.
    __Response:__ Removed in steffilazerte/weathercan@9455b01d7b58d23ee09592f680b4e8de64943514
    
- Packaging Guidelines
  - [ ] The function naming should follow the suggested object_verb() naming scheme ie weather() should become something like weather_download(), stations_all() to stations_download(), and add_weather() to weather_interpolate() etc.
    __Response:__ I've changed 5 function names (4 exported, 1 internal): `weather_dl` (from `weather`), `weather_interp` (from `add_weather`), `stations_dl` (from `stations_all`), `tz_calc` (from `get_tz`), and `weather_raw` (from `weather_dl`, the internal function) in steffilazerte/weathercan@8493e35910b3607af967f48b0e7aae3424d70dda
    
  - [X] The README lacks citation information.
    __Response:__ Added in steffilazerte/weathercan@84c640b8efa28fa221df6f584521abba6700ebd5
    
  - [X] The two most recent NEWS.md headings lack dates.
    __Response:__ Added in steffilazerte/weathercan@0d7dfd71c65961ee07b505e44b2da60a50b4e95a
  
- DESCRIPTION
  - [X] The DESCRIPTION file should include the Date of the current version.
    __RESPONSE:__ Added in steffilazerte/weathercan@01b292cf2e05cfd11340f3ae74c2b636e99888b5
  
- Coding Style
  - [X] The readability would be improved by breaking the bigger functions into subfunctions but this could be alot of work and is not necessary for acceptance of the package.
    __Response:__ I'll definitely bear this in mind for the future. If you think it really necessary, I can redo it here, but I'd rather not.
    
  - [X] Only use return() for early returns.
    __Response:__ Fixed in steffilazerte/weathercan@839cccc71eac0abb290fa9d4314f07c243396b0a

### Response to @softloud
 
 - [X] Trouble accessing vignettes
    __Response:__ After looking into this, I realized that to install vignettes, one should use `devtools::install_github("steffilazerte/weathercan", build_vignettes = TRUE)`. Vignettes can be listed with `vignette(package = "weathercan")`. I've added these additional details to the README to help future users (let me know if this doesn't solve your problem!) Fixed in steffilazerte/weathercan@64391184464cf42cf675fa0f032112b39e1916c7
 
 - [X] Missing example  
   __Response:__ Added (as above) in steffilazerte/weathercan@1645a34a1d66fca6d8c98ec4506a5df9a9cb122d

 - [X] Failed test
   __Response:__ I'm still not sure why this test failed on your system. Occasionally I have run into local problems with timezones (the test is for determining the timezone from lat/lon by dialing into Google), and sometimes I find a test will fail randomly on AppVeyor or TravisCi but restarting the test build always seems to resolve the issue. I think it may have something to do with calling into Google. If you haven't run into any other problems, I'll leave it for now unless it starts to cause some major issues.
   

### Extra Changes

- removed `sp` package from imports to suggests steffilazerte/weathercan@40cb49b654066ae0f7f37b812223c7f17559f4c2
- added guides for contributions steffilazerte/weathercan@d0445e7cc291359d39bafd44e7faea758c1a2087
