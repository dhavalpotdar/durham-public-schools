# load packages and set API key
require(tidyverse)
require(tidycensus)
require(readr)

census_api_key("4c7a5f74b2f160552de009de72b1e7db7222cb8f") # this is VR's API key

# all acs vars; uncomment and run to see df explaining vars
# acs5 = load_variables(2021, "acs5")

# variable naming
vars_acs <- c(
  "pop_total" = "B03002_001",
  "hh_total" = "B11001_001",
  "hh_wkids_u18" = "B11005_002",
  "white" = "B03002_003",
  "black" = "B03002_004",
  "aian" = "B03002_005",
  "asian" = "B03002_006",
  "nhpi" = "B03002_007",
  "other" = "B03002_008",
  "multi" = "B03002_009",
  "hisp" = "B03002_012",
  "mhhi" = "B19013_001",
  "wage" = "B19052_001",
  "hh_wage" = "B19052_002",
  "hh_no_wage" = "B19052_003",
  "mfi" = "B19113_001",
  "mfi2_kids" = "B19125_001",
  "mfi_wkids_u18" = "B19125_002",
  "mfi_nokids" = "B19125_003",
  "hh_foodstamp" = "B22010_002",
  "rent_total" = "B25070_001",
  "rent_30pct_35pct" = "B25070_007",
  "rent_35pct_40pct" = "B25070_008",
  "rent_40pct_50pct" = "B25070_009",
  "rent_over50pct" = "B25070_010",
  "mortgage_total" = "B25091_002",
  "mortgage_30pct_35pct" = "B25091_008",
  "mortgage_35pct_40pct" = "B25091_009",
  "mortgage_40pct_50pct" = "B25091_010",
  "mortgage_over50pct" = "B25091_011",
  "ipr_pop_total" = "C17002_001",
  "ipr_pop_u05" = "C17002_002",
  "ipr_pop_05_099" = "C17002_003",
  "ipr_pop_1_124" = "C17002_004",
  "ipr_pop_125_149" = "C17002_005",
  "ipr_pop_150_185" = "C17002_006",
  "ipr_pop_185_199" = "C17002_007",
  "ipr_pop_over2" = "C17002_008",
  "ipr_fam_tot" = "B17026_001",
  "ipr_fam_u05" = "B17026_002",
  "ipr_fam_05_074" = "B17026_003",
  "ipr_fam_075_099" = "B17026_004",
  "ipr_fam_1_124" = "B17026_005",
  "ipr_fam_125_149" = "B17026_006",
  "ipr_fam_150_174" = "B17026_007",
  "ipr_fam_175_184" = "B17026_008",
  "ipr_fam_185_199" = "B17026_009",
  "ipr_fam_2_299" = "B17026_010",
  "ipr_fam_3_399" = "B17026_011",
  "ipr_fam_4_499" = "B17026_012",
  "ipr_fam_over5" = "B17026_013",
  "tot_speakers_5_17" = "B16004_002",
  "eng_speakers_5_17" = "B16004_003",
  "span_speakers_5_17" = "B16004_004",
  "span_speakers_5_17_vw" = "B16004_005",
  "span_speakers_5_17_w" = "B16004_006",
  "span_speakers_5_17_nw" = "B16004_007",
  "span_speakers_5_17_na" = "B16004_008",
  "indoeuro_speakers_5_17" = "B16004_009",
  "indoeuro_speakers_5_17_vw" = "B16004_010",
  "indoeuro_speakers_5_17_w" = "B16004_011",
  "indoeuro_speakers_5_17_nw" = "B16004_012",
  "indoeuro_speakers_5_17_na" = "B16004_013",
  "aapi_speakers_5_17" = "B16004_014",
  "aapi_speakers_5_17_vw" = "B16004_015",
  "aapi_speakers_5_17_w" = "B16004_016",
  "aapi_speakers_5_17_nw" = "B16004_017",
  "aapi_speakers_5_17_na" = "B16004_018",
  "other_speakers_5_17" = "B16004_019",
  "other_speakers_5_17_vw" = "B16004_020",
  "other_speakers_5_17_w" = "B16004_021",
  "other_speakers_5_17_nw" = "B16004_022",
  "other_speakers_5_17_na" = "B16004_023",
  "pop_total_25" = "B15003_001",
  "bach_degree" = "B15003_022",
  "masters_degree" = "B15003_023",
  "prof_degree" = "B15003_024",
  "doc_degree" = "B15003_025",
  "homes_total" = "B25014_001",
  "homes_occupied" = "B25014_002",
  "pop_total_0_17" = "B23008_001",
  "single_parent_0_6" = "B23008_008",
  "single_parent_6_17" = "B23008_021",

  # additional
  "median_house_value" = "B25077_001",
  "n_occupied" = "B25002_002",
  "n_vacant" = "B25002_003",
  "n_owner_occupied" = "B25003_002",
  "n_renter_occupied" = "B25003_003",
  "median_year_structure_build" = "B25035_001",
  "housing_units" = "B25001_001"
)
# assign variable names to variable codes

# fixing order of variables for pulling
swap_var_names <- function(table) {
  table <- table %>%
    mutate(variable = str_replace_all(variable, c(
      "B03002_001" = "pop_total", "B11001_001" = "hh_total", "B11005_002" = "hh_wkids_u18",
      "B03002_003" = "white", "B03002_004" = "black", "B03002_005" = "aian",
      "B03002_006" = "asian", "B03002_007" = "nhpi", "B03002_008" = "other",
      "B03002_009" = "multi", "B03002_012" = "hisp", "B19113_001" = "mfi",
      "B19013_001" = "mhhi", "B19052_001" = "wage", "B19052_002" = "hh_wage",
      "B19052_003" = "hh_no_wage",
      "B19125_001" = "mfi2_kids", "B19125_002" = "mfi_wkids_u18", "B19125_003" = "mfi_nokids",
      "B22010_002" = "hh_foodstamp",
      "B25070_001" = "rent_total", "B25070_007" = "rent_30pct_35pct", "B25070_008" = "rent_35pct_40pct",
      "B25070_009" = "rent_40pct_50pct", "B25070_010" = "rent_over50pct",
      "B25091_002" = "mortgage_total", "B25091_008" = "mortgage_30pct_35pct", "B25091_009" = "mortgage_35pct_40pct",
      "B25091_010" = "mortgage_40pct_50pct", "B25091_011" = "mortgage_over50pct",
      "C17002_001" = "ipr_pop_total", "C17002_002" = "ipr_pop_u05",
      "C17002_003" = "ipr_pop_05_099", "C17002_004" = "ipr_pop_1_124",
      "C17002_005" = "ipr_pop_125_149", "C17002_006" = "ipr_pop_150_185",
      "C17002_007" = "ipr_pop_185_199", "C17002_008" = "ipr_pop_over2", "B17026_001" = "ipr_fam_tot",
      "B17026_002" = "ipr_fam_u05", "B17026_003" = "ipr_fam_05_074",
      "B17026_004" = "ipr_fam_075_099", "B17026_005" = "ipr_fam_1_124",
      "B17026_006" = "ipr_fam_125_149", "B17026_007" = "ipr_fam_150_174",
      "B17026_008" = "ipr_fam_175_184", "B17026_009" = "ipr_fam_185_199",
      "B17026_010" = "ipr_fam_2_299", "B17026_011" = "ipr_fam_3_399",
      "B17026_012" = "ipr_fam_4_499", "B17026_013" = "ipr_fam_over5",
      "B16004_002" = "tot_speakers_5_17", "B16004_003" = "eng_speakers_5_17",
      "B16004_004" = "span_speakers_5_17", "B16004_005" = "span_speakers_5_17_vw",
      "B16004_006" = "span_speakers_5_17_w", "B16004_007" = "span_speakers_5_17_nw",
      "B16004_008" = "span_speakers_5_17_na", "B16004_009" = "indoeuro_speakers_5_17",
      "B16004_010" = "indoeuro_speakers_5_17_vw", "B16004_011" = "indoeuro_speakers_5_17_w",
      "B16004_012" = "indoeuro_speakers_5_17_nw", "B16004_013" = "indoeuro_speakers_5_17_na",
      "B16004_014" = "aapi_speakers_5_17", "B16004_015" = "aapi_speakers_5_17_vw",
      "B16004_016" = "aapi_speakers_5_17_w", "B16004_017" = "aapi_speakers_5_17_nw",
      "B16004_018" = "aapi_speakers_5_17_na", "B16004_019" = "other_speakers_5_17",
      "B16004_020" = "other_speakers_5_17_vw", "B16004_021" = "other_speakers_5_17_w",
      "B16004_022" = "other_speakers_5_17_nw", "B16004_023" = "other_speakers_5_17_na",
      "B15003_001" = "pop_total_25",
      "B15003_022" = "bach_degree",
      "B15003_023" = "masters_degree",
      "B15003_024" = "prof_degree",
      "B15003_025" = "doc_degree",
      "B25014_001" = "homes_total",
      "B25014_002" = "homes_occupied",
      "B23008_001" = "pop_total_0_17",
      "B23008_008" = "single_parent_0_6",
      "B23008_021" = "single_parent_6_17",

      # additional
      "B25077_001" = "median_house_value",
      "B25002_002" = "n_occupied",
      "B25002_003" = "n_vacant",
      "B25003_002" = "n_owner_occupied",
      "B25003_003" = "n_renter_occupied",
      "B25035_001" = "median_year_structure_build",
      "B25001_001" = "housing_units"
    )))
  return(table)
}

# function for extracting stub to apply on variable names; used to apply on df names
# get_acs_stub = function(year){
#   if(!is.numeric(year)){
#     stop("Error: invalid type of year input (must be numeric)")
#   }
#   digits = floor(log10(year)) + 1
#   if(digits != 4){
#     stop("Error: invalid input year")
#   }
#   end_num = str_extract(year, pattern = "\\d{2}$") %>% as.integer()
#   start_num = end_num - 4
#   stub = paste0("_", start_num, end_num)
#   return(stub)
# }

# get_acs_stub(2021)

# write functions to use later to check validity of input year
is_valid_acs <- function(year) {
  if (!is.numeric(year)) {
    stop("invalid type of year input (must be numeric)")
  }
  digits <- floor(log10(year)) + 1
  if (digits != 4) {
    stop("invalid input year")
  }
}
is_valid_census <- function(year) {
  is_valid_acs(year)
  if (year %% 10 != 0) {
    stop("invalid decennial census year")
  }
}


# ACS Functions

# use this function to create 5-year acs data
# input of 2021 will get acs data from 2017-2021
make_acs_table_t <- function(year) {
  is_valid_acs(year)
  vars <- unname(vars_acs)
  table <- get_acs( # pull acs data from api
    geography = "tract",
    state = "NC",
    county = "Durham",
    variables = vars,
    geometry = TRUE,
    survey = "acs5",
    year = year
  )
  table <- table %>%
    swap_var_names() %>%
    pivot_wider(
      names_from = "variable",
      values_from = c("estimate", "moe")
    ) %>% # est: estimated value; moe: margin of error
    mutate(
      pct_white = estimate_white / estimate_pop_total, # add variables
      pct_black = estimate_black / estimate_pop_total,
      pct_aian = estimate_aian / estimate_pop_total,
      pct_asian = estimate_asian / estimate_pop_total,
      pct_nhpi = estimate_nhpi / estimate_pop_total,
      pct_other = estimate_other / estimate_pop_total,
      pct_multi = estimate_multi / estimate_pop_total,
      pct_hisp = estimate_hisp / estimate_pop_total,
      pct_nonwhite = 1 - pct_white, pct_black_hisp = pct_hisp + pct_black,
      ipr_pop_under1 = estimate_ipr_pop_u05 + estimate_ipr_pop_05_099,
      ipr_pop_under125 = ipr_pop_under1 + estimate_ipr_pop_1_124,
      ipr_pop_under150 = ipr_pop_under125 + estimate_ipr_pop_125_149,
      ipr_pop_under185 = ipr_pop_under150 + estimate_ipr_pop_150_185,
      ipr_pop_under2 = estimate_ipr_pop_total - estimate_ipr_pop_over2,
      ipr_pop_pct_under050 = estimate_ipr_pop_u05 / estimate_ipr_pop_total,
      ipr_pop_pct_under1 = ipr_pop_under1 / estimate_ipr_pop_total,
      ipr_pop_pct_under125 = ipr_pop_under125 / estimate_ipr_pop_total,
      ipr_pop_pct_under150 = ipr_pop_under150 / estimate_ipr_pop_total,
      ipr_pop_pct_under185 = ipr_pop_under185 / estimate_ipr_pop_total,
      ipr_pop_pct_under2 = ipr_pop_under2 / estimate_ipr_pop_total,
      ipr_pop_pct_over2 = estimate_ipr_pop_over2 / estimate_ipr_pop_total,
      ipr_pop_pct_1_2 = ipr_pop_pct_under2 - ipr_pop_pct_under1,
      pct_hh_foodstamp = estimate_hh_foodstamp / estimate_hh_total,
      rent_over_030 = estimate_rent_30pct_35pct + estimate_rent_35pct_40pct + estimate_rent_40pct_50pct + estimate_rent_over50pct,
      pct_rent_over_030 = rent_over_030 / estimate_rent_total,
      mortgage_over_030 = estimate_mortgage_30pct_35pct + estimate_mortgage_35pct_40pct + estimate_mortgage_40pct_50pct + estimate_mortgage_over50pct,
      pct_mortgage_over_030 = mortgage_over_030 / estimate_mortgage_total,
      pct_bach_higher = (estimate_bach_degree + estimate_masters_degree + estimate_prof_degree + estimate_doc_degree) / estimate_pop_total_25,
      pct_occ_owner = estimate_homes_occupied / estimate_homes_total,
      pct_single_parents = (estimate_single_parent_0_6 + estimate_single_parent_6_17) / estimate_pop_total_0_17,
      pct_non_eng = (estimate_span_speakers_5_17 + estimate_indoeuro_speakers_5_17 + estimate_aapi_speakers_5_17 + estimate_other_speakers_5_17) / estimate_tot_speakers_5_17,

      # additional
      pct_vacant = estimate_n_vacant / (estimate_n_vacant + estimate_n_occupied),
      pct_owner_occupied = estimate_n_owner_occupied / (estimate_n_renter_occupied + estimate_n_owner_occupied)
    ) %>%
    mutate(tract_num = unlist(str_extract_all(NAME, # add tract number variable
      pattern = "(?<=^|\\D)(\\d+(\\.\\d+)?)(?=\\D|$)"
    ))) %>%
    relocate(geometry, .after = last_col()) %>%
    rename_with(
      ~ case_when(
        .x %in% c("geometry") ~ .x, # apply variable stubs
        # TRUE ~ paste0(.x, get_acs_stub(year))),
        TRUE ~ .x
      ),
      .cols = everything()
    )

  table$geometry <- NULL

  return(table)
}

# input end year of ACS 5-year sample to pull ACS data
# acs1822_t = make_acs_table_t(2022)
# acs1721_t = make_acs_table_t(2021)
# acs1620_t = make_acs_table_t(2020)
# acs1519_t = make_acs_table_t(2019)

# function to make df for block group, similar to tract function
# see code annotations from preivious function
make_acs_table_bg <- function(year) {
  is_valid_acs(year)
  table <- get_acs(
    geography = "block group",
    state = "NC",
    county = "Durham",
    variables = unname(vars_acs),
    geometry = TRUE,
    survey = "acs5",
    year = year
  )
  table <- table %>%
    swap_var_names() %>%
    pivot_wider(
      names_from = "variable",
      values_from = c("estimate", "moe")
    ) %>% # est: estimated value; moe: margin of error
    mutate(
      pct_white = estimate_white / estimate_pop_total,
      pct_black = estimate_black / estimate_pop_total,
      pct_aian = estimate_aian / estimate_pop_total,
      pct_asian = estimate_asian / estimate_pop_total,
      pct_nhpi = estimate_nhpi / estimate_pop_total,
      pct_other = estimate_other / estimate_pop_total,
      pct_multi = estimate_multi / estimate_pop_total,
      pct_hisp = estimate_hisp / estimate_pop_total,
      pct_nonwhite = 1 - pct_white, pct_black_hisp = pct_hisp + pct_black,
      ipr_pop_under1 = estimate_ipr_pop_u05 + estimate_ipr_pop_05_099,
      ipr_pop_under125 = ipr_pop_under1 + estimate_ipr_pop_1_124,
      ipr_pop_under150 = ipr_pop_under125 + estimate_ipr_pop_125_149,
      ipr_pop_under185 = ipr_pop_under150 + estimate_ipr_pop_150_185,
      ipr_pop_under2 = estimate_ipr_pop_total - estimate_ipr_pop_over2,
      ipr_pop_pct_under050 = estimate_ipr_pop_u05 / estimate_ipr_pop_total,
      ipr_pop_pct_under1 = ipr_pop_under1 / estimate_ipr_pop_total,
      ipr_pop_pct_under125 = ipr_pop_under125 / estimate_ipr_pop_total,
      ipr_pop_pct_under150 = ipr_pop_under150 / estimate_ipr_pop_total,
      ipr_pop_pct_under185 = ipr_pop_under185 / estimate_ipr_pop_total,
      ipr_pop_pct_under2 = ipr_pop_under2 / estimate_ipr_pop_total,
      ipr_pop_pct_over2 = estimate_ipr_pop_over2 / estimate_ipr_pop_total,
      ipr_pop_pct_1_2 = ipr_pop_pct_under1 - ipr_pop_pct_under050,
      pct_hh_foodstamp = estimate_hh_foodstamp / estimate_hh_total,
      rent_over_030 = estimate_rent_30pct_35pct + estimate_rent_35pct_40pct + estimate_rent_40pct_50pct + estimate_rent_over50pct,
      pct_rent_over_030 = rent_over_030 / estimate_rent_total,
      mortgage_over_030 = estimate_mortgage_30pct_35pct + estimate_mortgage_35pct_40pct + estimate_mortgage_40pct_50pct + estimate_mortgage_over50pct,
      pct_mortgage_over_030 = mortgage_over_030 / estimate_mortgage_total,
      pct_bach_higher = (estimate_bach_degree + estimate_masters_degree + estimate_prof_degree + estimate_doc_degree) / estimate_pop_total_25,
      pct_occ_owner = estimate_homes_occupied / estimate_homes_total,
      pct_single_parents = (estimate_single_parent_0_6 + estimate_single_parent_6_17) / estimate_pop_total_0_17,
      pct_non_eng = (estimate_span_speakers_5_17 + estimate_indoeuro_speakers_5_17 + estimate_aapi_speakers_5_17 + estimate_other_speakers_5_17) / estimate_tot_speakers_5_17,

      # additional
      pct_vacant = estimate_n_vacant / (estimate_n_vacant + estimate_n_occupied),
      pct_owner_occupied = estimate_n_owner_occupied / (estimate_n_renter_occupied + estimate_n_owner_occupied)
    ) %>%
    mutate(
      tract_num = str_extract(NAME, "Tract \\d+\\.?\\d*"),
      tract_num = str_remove(tract_num, "Tract "),
      bg_num = str_extract(NAME, "Block Group \\d+"),
      bg_num = str_remove(bg_num, "Block Group ")
    ) %>%
    relocate(geometry, .after = last_col()) %>%
    rename_with(
      ~ case_when(
        .x %in% c("geometry") ~ .x, # apply variable stubs
        # TRUE ~ paste0(.x, get_acs_stub(year))),
        TRUE ~ .x
      ),
      .cols = everything()
    )

  table$geometry <- NULL
  return(table)
}

# use function to create bg dfs
# acs1822_bg = make_acs_table_bg(2022)
# acs1721_bg = make_acs_table_bg(2021)
# acs1620_bg = make_acs_table_bg(2020)
# acs1519_bg = make_acs_table_bg(2019)

# Census Functions

# functions for Census data, at tract, block group, and block levels
# see annotations for tract function
make_census_table_t <- function(year) {
  is_valid_census(year)
  census_vars <- load_variables(year, "pl")
  vars_vec <- census_vars$name
  table <- get_decennial( # pull census data from api
    geography = "tract",
    state = "NC",
    county = "Durham",
    variables = vars_vec,
    geometry = TRUE,
    year = year,
    sumfile = "pl"
  )
  table <- table %>%
    pivot_wider(names_from = "variable", values_from = "value") %>% # widen data
    mutate(tract_num = unlist(str_extract_all(NAME,
      pattern = "(?<=^|\\D)(\\d+(\\.\\d+)?)(?=\\D|$)"
    ))) %>% # add tract_num var
    relocate(geometry, .after = last_col()) %>%
    rename_with(
      ~ case_when(
        .x %in% c("geometry") ~ .x, # apply variable stubs
        # TRUE ~ paste0(.x, get_acs_stub(year))),
        TRUE ~ .x
      ),
      .cols = everything()
    )
  return(table)
}

make_census_table_bg <- function(year) {
  is_valid_census(year)
  census_vars <- load_variables(year, "pl")
  vars_vec <- census_vars$name
  table <- get_decennial(
    geography = "block group",
    state = "NC",
    county = "Durham",
    sumfile = "pl",
    variables = vars_vec,
    geometry = TRUE,
    year = year
  )
  table <- table %>%
    pivot_wider(names_from = "variable", values_from = "value") %>%
    mutate(
      tract_num = unlist(str_extract_all(NAME,
        pattern = "(?<=Tract ).*?(?=,)"
      )),
      bg_num = unlist(str_extract_all(NAME, pattern = "(?<=Group ).*?(?=,)"))
    ) %>%
    relocate(geometry, .after = last_col()) %>%
    rename_with(
      ~ case_when(
        .x %in% c("geometry") ~ .x, # apply variable stubs
        # TRUE ~ paste0(.x, get_acs_stub(year))),
        TRUE ~ .x
      ),
      .cols = everything()
    )
  return(table)
}

make_census_table_b <- function(year) {
  is_valid_census(year)
  census_vars <- load_variables(year, "pl")
  vars_vec <- census_vars$name
  table <- get_decennial(
    geography = "block",
    state = "NC",
    county = "Durham",
    variables = vars_vec,
    geometry = TRUE,
    year = year,
    sumfile = "pl"
  )
  table <- table %>%
    pivot_wider(names_from = "variable", values_from = "value") %>%
    mutate(
      tract_num = unlist(str_extract_all(NAME,
        pattern = "(?<=Tract ).*?(?=,)"
      )),
      bg_num = unlist(str_extract_all(NAME, pattern = "(?<=Group ).*?(?=,)")),
      b_num = unlist(str_extract_all(NAME, pattern = "(?<=Block ).*?(?=, Block Group )"))
    ) %>%
    relocate(geometry, .after = last_col()) %>%
    rename_with(
      ~ case_when(
        .x %in% c("geometry") ~ .x, # apply variable stubs
        # TRUE ~ paste0(.x, get_acs_stub(year))),
        TRUE ~ .x
      ),
      .cols = everything()
    )
  return(table)
}

# Save & Write to CSV
# write_csv(acs1721_t, file = "Data/data_raw/acs1721_t.csv", na = "", append = FALSE)
# save(acs1721_t, file = "Data/data_raw/acs1721_t.Rdata")
#
# write_csv(acs1721_bg, file = "Data/data_raw/acs1721_bg.csv", na = "", append = FALSE)
# save(acs1721_bg, file = "Data/data_raw/acs1721_bg.Rdata")
#
# write_csv(acs1620_t, file = "Data/data_raw/acs1620_t.csv", na = "", append = FALSE)
# save(acs1620_t, file = "Data/data_raw/acs1620_t.Rdata")
#
# write_csv(acs1620_bg, file = "Data/data_raw/acs1620_bg.csv", na = "", append = FALSE)
# save(acs1620_bg, file = "Data/data_raw/acs1620_bg.Rdata")
#
# write_csv(acs1519_t, file = "Data/data_raw/acs1519_t.csv", na = "", append = FALSE)
# save(acs1519_t, file = "Data/data_raw/acs1519_t.Rdata")
#
# write_csv(acs1519_bg, file = "Data/data_raw/acs1519_bg.csv", na = "", append = FALSE)
# save(acs1519_bg, file = "Data/data_raw/acs1519_bg.Rdata")


# use functions to create Census tables for 2020, 2010, 2000 at tract, block group, block levels
# see below code chunks
# cen2020_t = make_census_table_t(2020)
# cen2010_t = make_census_table_t(2010)
# cen2000_t = make_census_table_t(2000)
#
# cen2020_bg = make_census_table_bg(2020)
# cen2010_bg = make_census_table_bg(2010)
# # cen2000_bg = make_census_table_bg(2000) #this particular one not working
#
# cen2020_b = make_census_table_b(2020)
# cen2010_b = make_census_table_b(2010)
# cen2000_b = make_census_table_b(2000)

#   ## Using Code

# Below is a list of the functions we wrote to pull data:
#
#   ## ACS
#
# `make_acs_table_t`: Pulls 5-year ACS data for the given input end-year at the tract level
# `make_acs_table_bg`: Pulls 5-year ACS data for the given input end-year at the block group level
#
#   ## Census
#
# `make_census_table_t`: Pulls decennial Census data for the given input year at the tract level
# `make_census_table_bg`: Pulls decennial Census data for the given input year at the block group level
# `make_census_table_b`: Pulls decennial Census data for the given input year at the block level
#
#   ## Important Notes and Instructions
#
# For the written functions, the input variable is a valid four-digit year in integer format. For example, if we wanted to pull decennial Census data from 2010 at the block group level, we would call `make_census_table_bg(2010)`. If you are pulling 5-year ACS data, use the end-year as the input year. That is, if we wanted ACS data from 2017-21 at the tract level, we would call `make_acs_table_t(2021)`. Note that an error will be displayed if an invalid type is inputted (e.g. input of `"2010"` rather than `2010`) or if an invalid decennial Census year is inputted (e.g. input of `2007`).
#
# Also, note that there is an API error when pulling decennial Census data from 2000 specifically at the block group level. We were able to pull data at the block group level from all other years as well as tract and block level data from 2000, so we are unsure as to why the API does not let us pull data from this specific combination. This has been an ongoing issue in the `tidycensus` community; see this link: https://github.com/walkerke/tidycensus/issues/343.
#
# Above are the calls to the functions pulling both Census and API data requested. If you run all code chunks, the desired data will be in the environment under Data. The naming convention for the data frames is as follows: "[survey][year]_[level]". For example, the data frame containing 2015-19 ACS data at the block group level will be named `acs1519_bg` and the data frame containing 2010 ACS data at the block level will be named `census2010_b`. Download files locally using the `write_csv` function. Feel free to pull more variations of the data for other years in the code chunk below.
