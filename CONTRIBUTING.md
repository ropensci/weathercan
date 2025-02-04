# Contributing to `weathercan`

Thank you for any and all contributions! Following these guidelines will help streamline the process of contributing and make sure that we're all on the same page. While we ask that you read this guide and follow it to the best of your abilities, we welcome contributions from all, regardless of your level of experience.

By participating in this project, you agree to abide by the [code of conduct](https://github.com/ropensci/weathercan/blob/master/CONDUCT.md).

# Types of contributions 

Don't feel that you must be a computer whiz to make meaningful contributions. Feel free to:

- Identify areas for future development ([open an Issue](https://github.com/ropensci/weathercan/issues))
- Identify issues/bugs ([open an Issue](https://github.com/ropensci/weathercan/issues))
- Write tutorials/vignettes ([open a Pull Request](https://github.com/ropensci/weathercan/pulls) to contribute to the ones here, or make your own elsewhere and send us a link)
- Add functionality ([open a Pull Request](https://github.com/ropensci/weathercan/pulls))
- Fix bugs ([open a Pull Request](https://github.com/ropensci/weathercan/pulls))

# New to GitHub?

Getting ready to make your first contribution? Here are a couple of tutorials you may wish to check out:

- [Tutorial for first-timers](https://github.com/Roshanjossey/first-contributions)
- [How to contribute (in-depth lessons)](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)
- [GitHub on setup](https://help.github.com/articles/set-up-git)
- [GitHub on pull requests](https://help.github.com/articles/using-pull-requests/).)


# How to contribute code

- Fork the repository
- Clone the repository from GitHub to your computer e.g,. `git clone https://github.com/ropensci/weathercan.git`
- Make sure to track progress upstream (i.e., on our version of `weathercan` at `ropensci/weathercan`)
  - `git remote add upstream https://github.com/ropensci/weathercan.git`
  - Before making changes make sure to pull changes in from upstream with `git pull upstream`
- Make your changes
  - For changes beyond minor typos, add an item to NEWS.md describing the changes and add yourself to the DESCRIPTION file as a contributor
- Push to your GitHub account
- Submit a pull request to home base (main branch) at `ropensci/weathercan`

# Code formatting

- In general follow the convention of <http://r-pkgs.had.co.nz/r.html#style> (snake_case functions and argument names, etc.)
- Where there is conflict, default to the style of `weathercan`
- Use explicit package imports (i.e. package_name::package_function) and avoid @import if at all possible

# Testing

In order to test `weathercan`, you may need to do some extra legwork.

- Install `devtools`. 
- You may need to install `weathercan` itself (I know) from GitHub, using `devtools::install_github("ropensci/weathercan")
- You still may need to install more, such as `install.packages(c["vcr", "mockery",  "sf"]).
- Try running all of the tests any time you edit something.
- Interactively test the packages if you can using cmd+shift+L. That will normally prompt if you are missing packages. It may not work all of the time, because some packages are used only for testing.

If this doesn't work, _please_ try and update this section! The more the better.
