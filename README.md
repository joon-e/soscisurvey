
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SoSciSurvey

This package loads data obtained with
[SoSciSurvey](https://www.soscisurvey.de/en/index) into *R* as a tidy,
labelled dataset by…

  - grabbing the data as a JSON file via the [SoSciSurvey
    API](https://www.soscisurvey.de/help/doku.php/en:results:data-api)
  - turning the JSON data into a `tibble`
  - labelling the variables with `labelled::var_label()`
  - labelling variable values with `labelled::val_labels()`
  - adding user-defined missing values with `labelled::na_values()`
  - and adding further variable information (scaling, input type,
    question wording, system variable name) as additional attributes.

See [Introduction to
labelled](https://cran.r-project.org/web/packages/labelled/vignettes/intro_labelled.html)
for details on labelled tibbles.

## Installation

Install from GitHub:

``` r
devtools::install_github("joon-e/soscisurvey")
```

## Instructions

### Preparation: Obtain API key

First, you need an API key. Head to your *SoSciSurvey* project and
select *Collected Data / API for Data Retrieval* and click on the plus
sign in the top right corner to create a new API key. Make sure that
*Retrieve data via JSON interface* is selected under *Function:* (this
should be the default setting). Select the other options to your liking.
Finally, click on the save button.

![Default settings for the SoSciSurvey
API](man/figures/README-sosci-api.png)

This should create an API URL of the form
`https://www.soscisurvey.de/[YOUR_PROJECT_NAME]/?act=[LONG_API_KEY]`.
Copy this URL.

### Load data

To download your data, simply load the package and paste the API URL (in
quotation marks) into the `read_sosci()` function. Let’s try this with a
test questionnaire containing random data of ten cases on several
sociodemographic variables, device ownership and the BFI-10 short scale:

``` r

library(soscisurvey)
data <- read_sosci("https://www.soscisurvey.de/test166518/?act=mhBZkaKkPn1IvCWyU7296BOC")
data
#> # A tibble: 10 x 30
#>     CASE QUESTNNR MODE  STARTED   age       gender    education
#>    <int> <chr>    <chr> <chr>   <int>    <int+lbl>    <int+lbl>
#>  1     5 base     inte~ 2019-0~    45 -1 (NA) [Pr~  5 [4-Year ~
#>  2     6 base     inte~ 2019-0~    NA  3 [Non-bin~  5 [4-Year ~
#>  3     7 base     inte~ 2019-0~    56  1 [Male]     2 [Seconda~
#>  4     8 base     inte~ 2019-0~    NA  2 [Female]   4 [2-Year ~
#>  5     9 base     inte~ 2019-0~    65  1 [Male]     3 [High Sc~
#>  6    10 base     inte~ 2019-0~    19  2 [Female]  -1 (NA) [I ~
#>  7    11 base     inte~ 2019-0~    25 -1 (NA) [Pr~  1 [Primary~
#>  8    12 base     inte~ 2019-0~    51  3 [Non-bin~  5 [4-Year ~
#>  9    13 base     inte~ 2019-0~    71  1 [Male]     2 [Seconda~
#> 10    14 base     inte~ 2019-0~    38  2 [Female]   3 [High Sc~
#> # ... with 23 more variables: bfi10_ext1 <int+lbl>,
#> #   bfi10_agree1 <int+lbl>, bfi10_con1 <int+lbl>, bfi10_neuro1 <int+lbl>,
#> #   bfi10_open1 <int+lbl>, bfi10_ext2 <int+lbl>, bfi10_agree2 <int+lbl>,
#> #   bfi10_con2 <int+lbl>, bfi10_neuro2 <int+lbl>, bfi10_open2 <int+lbl>,
#> #   device_count <int+lbl>, device_tv <int+lbl>,
#> #   device_computer <int+lbl>, device_tablet <int+lbl>,
#> #   device_phone <int+lbl>, device_console <int+lbl>, TIME001 <int>,
#> #   TIME_SUM <int>, LASTDATA <chr>, FINISHED <int>, Q_VIEWER <int>,
#> #   LASTPAGE <int>, MAXPAGE <int>
```

Additional parameters offered by the [SoSciSurvey
API](https://www.soscisurvey.de/help/doku.php/en:results:data-api) can
be set after the API URL. Add `= TRUE`/`= FALSE` to parameters that are
set without values in the API call (e.g., `vSkipTime`,
`vQuality`):

``` r
data <- read_sosci("https://www.soscisurvey.de/test166518/?act=mhBZkaKkPn1IvCWyU7296BOC",
              vSkip = "QUESTNNR,MODE,STARTED",
              vSkipTime = TRUE)
data
#> # A tibble: 10 x 24
#>     CASE   age       gender    education   bfi10_ext1 bfi10_agree1
#>    <int> <int>    <int+lbl>    <int+lbl>    <int+lbl>    <int+lbl>
#>  1     5    45 -1 (NA) [Pr~  5 [4-Year ~  4 [[4]]     6 [[6]]     
#>  2     6    NA  3 [Non-bin~  5 [4-Year ~  5 [[3]]     2 [[2]]     
#>  3     7    56  1 [Male]     2 [Seconda~  5 [[3]]     3 [[3]]     
#>  4     8    NA  2 [Female]   4 [2-Year ~  2 [[6]]     4 [[4]]     
#>  5     9    65  1 [Male]     3 [High Sc~  7 [does no~ 4 [[4]]     
#>  6    10    19  2 [Female]  -1 (NA) [I ~  1 [does fu~ 3 [[3]]     
#>  7    11    25 -1 (NA) [Pr~  1 [Primary~  1 [does fu~ 3 [[3]]     
#>  8    12    51  3 [Non-bin~  5 [4-Year ~ -9 (NA) [No~ 5 [[5]]     
#>  9    13    71  1 [Male]     2 [Seconda~  7 [does no~ 7 [does ful~
#> 10    14    38  2 [Female]   3 [High Sc~  1 [does fu~ 1 [does not~
#> # ... with 18 more variables: bfi10_con1 <int+lbl>,
#> #   bfi10_neuro1 <int+lbl>, bfi10_open1 <int+lbl>, bfi10_ext2 <int+lbl>,
#> #   bfi10_agree2 <int+lbl>, bfi10_con2 <int+lbl>, bfi10_neuro2 <int+lbl>,
#> #   bfi10_open2 <int+lbl>, device_count <int+lbl>, device_tv <int+lbl>,
#> #   device_computer <int+lbl>, device_tablet <int+lbl>,
#> #   device_phone <int+lbl>, device_console <int+lbl>, FINISHED <int>,
#> #   Q_VIEWER <int>, LASTPAGE <int>, MAXPAGE <int>
```

The returned tibble contains variable and value labels (using the
[`labelled`](https://cran.r-project.org/web/packages/labelled/)
package). Value labels are visible in the console output. Variable
labels are also displayed in the R data viewer (`View()`). If no labels
are defined for some values, the numeric anchors as set in *SoSciSurvey*
are used (In this case, only scale extremes were labelled for the BFI-10
variables. You may note that values and labels differ for some of the
scale variables, e.g., `bfi10_ext1`. This is because these variables are
reverse-coded).

### Additional attributes

Apart from labelling the data, `read_sosci()` adds further variable
information provided by *SoSciSurvey* as attributes. These attributes
are:

  - `var.type`: Scale type of the variable (e.g., “nominal”, “ordinal”,
    “metric”, “text”)
  - `var.input`: Question input format (e.g., “selection”, “scale”,
    “open”)
  - `var.question`: Question wording
  - `var.sysvar`: Original (system-defined) variable name if [custom
    variable
    names](https://www.soscisurvey.de/help/doku.php/en:create:variables#custom_variable_ids)
    were set in *SoSciSurvey* (e.g., “age” instead of “SD01\_01”)

<!-- end list -->

``` r
attributes(data$age)
#> $var.type
#> [1] "metric"
#> 
#> $var.input
#> [1] "open"
#> 
#> $var.question
#> [1] "How old are you?"
#> 
#> $var.sysvar
#> [1] "SD01_01"
#> 
#> $label
#> [1] "Age: I am ... years old."
```

### Further data handling

#### Missing values

In most cases, *SoSciSurvey* represents missing data with various
integer codes (e.g., “-9” = “Not answered”, “-1” = “Prefer not to
answer”). These are defined as user-defined NA values by
`labelled::na_values()` in the tibble returned by `sosci()`. While
`is.na()` will return `TRUE` for user-defined NA values, most functions
will most likely treat them as integers. You can easily convert all
user-defined NA values to explicit `NA` values with `purrr::modify()`
and `labelled::user_na_to_na()`.

``` r
purrr::modify(data, labelled::user_na_to_na)
#> # A tibble: 10 x 24
#>     CASE   age   gender education bfi10_ext1 bfi10_agree1 bfi10_con1
#>    <int> <int> <int+lb> <int+lbl>  <int+lbl>    <int+lbl>  <int+lbl>
#>  1     5    45 NA        5 [4-Ye~  4 [[4]]   6 [[6]]       4 [[4]]  
#>  2     6    NA  3 [Non~  5 [4-Ye~  5 [[3]]   2 [[2]]       5 [[3]]  
#>  3     7    56  1 [Mal~  2 [Seco~  5 [[3]]   3 [[3]]      NA        
#>  4     8    NA  2 [Fem~  4 [2-Ye~  2 [[6]]   4 [[4]]       5 [[3]]  
#>  5     9    65  1 [Mal~  3 [High~  7 [does ~ 4 [[4]]       5 [[3]]  
#>  6    10    19  2 [Fem~ NA         1 [does ~ 3 [[3]]       5 [[3]]  
#>  7    11    25 NA        1 [Prim~  1 [does ~ 3 [[3]]       4 [[4]]  
#>  8    12    51  3 [Non~  5 [4-Ye~ NA         5 [[5]]      NA        
#>  9    13    71  1 [Mal~  2 [Seco~  7 [does ~ 7 [does ful~  1 [does ~
#> 10    14    38  2 [Fem~  3 [High~  1 [does ~ 1 [does not~  1 [does ~
#> # ... with 17 more variables: bfi10_neuro1 <int+lbl>,
#> #   bfi10_open1 <int+lbl>, bfi10_ext2 <int+lbl>, bfi10_agree2 <int+lbl>,
#> #   bfi10_con2 <int+lbl>, bfi10_neuro2 <int+lbl>, bfi10_open2 <int+lbl>,
#> #   device_count <int+lbl>, device_tv <int+lbl>,
#> #   device_computer <int+lbl>, device_tablet <int+lbl>,
#> #   device_phone <int+lbl>, device_console <int+lbl>, FINISHED <int>,
#> #   Q_VIEWER <int>, LASTPAGE <int>, MAXPAGE <int>
```

#### Labels to factors

Likewise, you may want to convert labelled variables to factors for
analytical purposes (e.g., treating them as categorical variables in
regression models). This can be done using `labelled::to_factor`. To
ensure that only categorical variables are converted (and not, for
example, scales with labelled extremes), you may use a combination of
`purrr::modify_if()` and the `var.type` attribute set by
`sosci()`:

``` r
purrr::modify_if(data, ~ attr(., "var.type") %in% c("nominal", "dichotomous"), labelled::to_factor)
#> # A tibble: 10 x 24
#>     CASE   age gender education   bfi10_ext1 bfi10_agree1   bfi10_con1
#>    <int> <int> <fct>  <fct>        <int+lbl>    <int+lbl>    <int+lbl>
#>  1     5    45 Prefe~ 4-Year C~  4 [[4]]     6 [[6]]       4 [[4]]    
#>  2     6    NA Non-b~ 4-Year C~  5 [[3]]     2 [[2]]       5 [[3]]    
#>  3     7    56 Male   Secondar~  5 [[3]]     3 [[3]]      -9 (NA) [No~
#>  4     8    NA Female 2-Year C~  2 [[6]]     4 [[4]]       5 [[3]]    
#>  5     9    65 Male   High Sch~  7 [does no~ 4 [[4]]       5 [[3]]    
#>  6    10    19 Female I prefer~  1 [does fu~ 3 [[3]]       5 [[3]]    
#>  7    11    25 Prefe~ Primary ~  1 [does fu~ 3 [[3]]       4 [[4]]    
#>  8    12    51 Non-b~ 4-Year C~ -9 (NA) [No~ 5 [[5]]      -9 (NA) [No~
#>  9    13    71 Male   Secondar~  7 [does no~ 7 [does ful~  1 [does fu~
#> 10    14    38 Female High Sch~  1 [does fu~ 1 [does not~  1 [does fu~
#> # ... with 17 more variables: bfi10_neuro1 <int+lbl>,
#> #   bfi10_open1 <int+lbl>, bfi10_ext2 <int+lbl>, bfi10_agree2 <int+lbl>,
#> #   bfi10_con2 <int+lbl>, bfi10_neuro2 <int+lbl>, bfi10_open2 <int+lbl>,
#> #   device_count <int+lbl>, device_tv <fct>, device_computer <fct>,
#> #   device_tablet <fct>, device_phone <fct>, device_console <fct>,
#> #   FINISHED <int>, Q_VIEWER <int>, LASTPAGE <int>, MAXPAGE <int>
```

## Acknowledgements

Many thanks to [Dominik
Leiner](https://www.ls1.ifkw.uni-muenchen.de/personen/wiss_ma/leiner_dominik/index.html)
for continued assistance with the SoSciSurvey API (and developing this
great software in the first place).
