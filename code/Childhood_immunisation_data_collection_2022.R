# Loading some packages 
packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'ggpol', 'magick', 'officer', 'leaflet', 'leaflet.extras', 'zoo', 'fingertipsR', 'PostcodesioR', 'ggrepel', 'readODS', 'openxlsx',  'httr', 'rvest')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

# base directory
# base_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/Child & maternity/Immunisation'
base_directory <- '~/Repositories/child_immunisations/'
data_directory <- paste0(base_directory, '/data')
output_directory <- paste0(base_directory, '/outputs')

# To see what is in the directory already
list.files(data_directory)

# Immunisation data landscape

# The task ####

# Produce a PowerPoint file with embedded html maps (leaflet maps) and an excel file containing summary data.

# Age 5
# 24 months
# 12 months

# For each age group create a 2019/20, 2020/21, 2021/22, and 2022/23 vaccination coverage map by GP practice.

# The leaflet map for age 5 shows circles for MMR (dose 1) vaccine, MMR (dose 2) vaccine, DTaP/IPV vaccine, DTaP/IPV/Hib vaccine, and Hib/Men C vaccine for each GP practice coloured by coverage verses benchmark targets (red for <90%, amber for 90-95%, green for 95+% (denoted as low/medium/high coverage respectively), with a grey circle for those which could not be calculated).

# The dots have tooltip popups showing: 

# Practice: ST. LAWRENCE SURGERY (Code: H82009) In 2021-22 (derived from quarterly data), coverage of the MMR vaccine (measles, mumps and rubella; first dose by 1 year) was estimated at 98.1% of the GP registered population (aged 5 years) at this practice. Coverage at CENTRAL WORTHING PRACTICES PCN (Code:U13952) was estimated at 96.4%

# The leaflet map for age 24 months shows circles for DTaP/IPV/Hib vaccine, MMR (dose 1) vaccine, Hib/Men C vaccine, PCV booster, and Men B booster for each GP practice coloured by coverage verses benchmark targets (red for <90%, amber for 90-95%, green for 95+% (denoted as low/medium/high coverage respectively), with a grey circle for those which could not be calculated).

# The leaflet map for age 12 months shows circles for DTaP/IPV/Hib/HepB vaccine, Men B, PCV dose 1, and Rotavirus for each GP practice coloured by coverage verses benchmark targets (red for <90%, amber for 90-95%, green for 95+% (denoted as low/medium/high coverage respectively), with a grey circle for those which could not be calculated).

# Excel tables ####
# There are also worksheets for West Sussex overall
# PCN summary
# GP summary

# Content for excel file intro page 

title_1 <- 'Coverage of Childhood Vaccinations'
subtitle_1 <- 'This data is experimental and should be treated with caution. It is not an official statistic.'

intro_text_1 <- 'This workbook presents data on coverage of routine childhood vaccinations (from birth to age 5) in primary care settings in West Sussex. COVER data is provided by the Child Health Information Service (CHIS) providers and is reported in the public domain quarterly and annually.'

quarterly_text_old_source <- 'https://www.gov.uk/government/statistics/cover-of-vaccination-evaluated-rapidly-cover-programme-2021-to-2022-quarterly-data'

quarterly_text_new_source <- 'https://www.gov.uk/government/statistics/cover-of-vaccination-evaluated-rapidly-cover-programme-2022-to-2023-quarterly-data'

routine_imms_schedule_source <- 'https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1055877/UKHSA-12155-routine-complete-immunisation-schedule_Feb2022.pdf'

annual_text_source <- 'https://www.gov.uk/government/publications/cover-of-vaccination-evaluated-rapidly-cover-programme-annual-data'

caveat_1 <- 'In 2019/20, Public Health England (PHE) published annual COVER data (previously published by NHS England). This was the first year where annual GP practice level coverage was based on a refreshed extract, which allowed for corrections to be made following quarterly submissions. This data is also aggregated in the National General Practice Profiles on Fingertips, although there is a time lag.'

caveat_2 <-  'Annual GP practice level coverage data has also been published for 2020/21. Disruption due to the COVID-19 pandemic is likely to have caused some decreases in vaccine coverage, particularly for the 12 month cohort.'

caveat_3 <- 'Annual data at higher geographies is also published by NHS Digital and is reproduced on fingertips. Data collections are quality assured at the time of collection by UKHSA and further validation is carried out by NHS Digital prior to publication (detailed here - https://digital.nhs.uk/data-and-information/publications/statistical/nhs-immunisation-statistics/england---2020-21/appendices).'

caveat_4 <- 'Annual data for England, by financial year, is collected by the UK Health Security Agency (UKHSA) under the COVER programme with further checks and final publication by NHS Digital as national statistics. Annual data is more complete and should be used to look at longer term trends.'

method_1 <- 'Where possible, published annual data has been presented from published sources (as oppoesed to aggregated data from quarterly releases). However, due to a lag in the release of annual data, coverage has been estimated from quarterly releases in some instances.'

method_2 <- 'Due to suppression of small counts, data was not available for all quarters for a small number of GP Practices - estimated annual coverage is not presented at GP practice level in these cases. At PCN and West Sussex level, all available GP practice data was aggregated to the appropriate geography.Numerators and denominators therefore do not reflect the entire eligible cohort in cases where GP practice level data was incomplete. Recent quarterly data is also presented to give early insight into practices that may have low coverage, although this data is unvalidated.'

# IMD_2019 <- read_csv(url('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv'))

# Data ####

# 2019/20
if(file.exists(paste0(data_directory, '/Child_immunisation_GP_201920.ods')) != TRUE){
  download.file('https://webarchive.nationalarchives.gov.uk/ukgwa/20211021204911mp_/https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/938341/COVER_GP_annual_experiemental_2019_to_2020_data.ods',
                paste0(data_directory, '/Child_immunisation_GP_201920.ods'),
                mode = 'wb')
}

# 2020/21
if(file.exists(paste0(data_directory, '/Child_immunisation_GP_202021.ods')) != TRUE){
download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1055627/cover-gp-annual-2020-to-2021.ods',
              paste0(data_directory, '/Child_immunisation_GP_202021.ods'),
              mode = 'wb')
}

# 2021/22
if(file.exists(paste0(data_directory, '/Child_immunisation_GP_202122.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1133076/cover-gp-annual-2021-to-2022.ods',
                paste0(data_directory, '/Child_immunisation_GP_202122.ods'),
                mode = 'wb')
}

# 2022/23

if(file.exists(paste0(data_directory, '/Child_immunisation_GP_202223_Q1.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1106493/hpr1022_COVER_xprmntl-gp-data-tables2.ods',
                paste0(data_directory, '/Child_immunisation_GP_202223_Q1.ods'),
                mode = 'wb')
}

if(file.exists(paste0(data_directory, '/Child_immunisation_GP_202223_Q2.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1125609/GP_COVER.ods',
                paste0(data_directory, '/Child_immunisation_GP_202223_Q2.ods'),
                mode = 'wb')
}

# Next set of data is due to be released 28th March, with Q4 in June 2023, annual data due 1st September 2023 

# https://www.gov.uk/government/publications/vaccine-coverage-statistics-publication-dates/cover-vaccine-coverage-data-submission-and-publication-schedule

# UTLA data ####

# Coverage at this level is available annually, up to 2022/23 (which we are part way through) and Q1 2022/23 is available.

# 2019/20
if(file.exists(paste0(data_directory, '/Child_immunisation_LA_201920.xlsx')) != TRUE){
  download.file('https://webarchive.nationalarchives.gov.uk/ukgwa/20211101145059mp_/https://files.digital.nhs.uk/1A/CA4551/child-vacc-stat-eng-2019-20-data-tables.xlsx',
                paste0(data_directory, '/Child_immunisation_LA_201920.xlsx'),
                mode = 'wb')
}

# 2020/21
if(file.exists(paste0(data_directory, '/Child_immunisation_LA_202021.xlsx')) != TRUE){
  download.file('https://files.digital.nhs.uk/FC/3632B0/Childhood%20Vaccination%20Statistics%20-%20Main%20Tables%20-%202020-21%20V2.xlsx',
                paste0(data_directory, '/Child_immunisation_LA_202021.xlsx'),
                mode = 'wb')
}

# 2021/22
if(file.exists(paste0(data_directory, '/Child_immunisation_LA_202122.xlsx')) != TRUE){
  download.file('https://files.digital.nhs.uk/0A/AE25B0/Childhood%20Vaccination%20Statistics%20-%20Main%20Tables%20-%202021-22.xlsx',
                paste0(data_directory, '/Child_immunisation_LA_202122.xlsx'),
                mode = 'wb')
}

# 2022/23 Quarterly
if(file.exists(paste0(data_directory, '/Child_immunisation_LA_202223_Q1.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1106445/hpr1022_COVER-data-tables.ods',
                paste0(data_directory, '/Child_immunisation_LA_202223_Q1.ods'),
                mode = 'wb')
}

if(file.exists(paste0(data_directory, '/Child_immunisation_LA_202223_Q2.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1125667/Quarterly-vaccination-coverage-statistics-July-September-2022.ods',
                paste0(data_directory, '/Child_immunisation_LA_202223_Q2.ods'),
                mode = 'wb')
}

Vaccination_terms_df <- data.frame(Item = c('DTaPIPVHibHepB', 'MenB', 'PCV1', 'PCV2', 'Rota', 'DTaP/IPV/Hib(Hep)', 'MMR1', 'Hib/MenC', 'PCV Booster', 'MenB Booster', 'DTaP/IPV/Hib', 'DTaPIPV', 'MMR2'), Term = c('DTaP/IPV/Hib/HepB vaccine (Diptheria, tetanus, pertussis, polio, haemophilus influenzae type B and hepatitis B), known as hexavalent vaccine or 6-in-1', 'Meningococcal group B disease vaccine', 'Pneumococcal conjulate vaccine (first dose by 12 weeks)', 'Pneumococcal conjulate vaccine (first dose by 12 weeks)', 'Rotavirus vaccine (primary course, with first dose at 8 weeks and second at 12 weeks)', 'DTaP/IPV/Hib/HepB vaccine (Diptheria, tetanus, pertussis, polio, haemophilus influenzae type B and hepatitis B), known as hexavalent vaccine or 6-in-1; three doses at any time by second birthday', 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Pneumococcal conjulate disease booster vaccine; dose by second birthday', 'Meningococcal group B disease booster vaccine; completed by fifth birthday', 'DTaP/IPV/Hib/HepB vaccine (Diptheria, tetanus, pertussis, polio, haemophilus influenzae type B and hepatitis B), known as hexavalent vaccine or 6-in-1; completing booster dose by fifth birthday', 'pre-school diphtheria, tetanus, acellular pertussis and polio (DTaP/IPV) booster; completing booster dose by fifth birthday', 'Measles, mumps, and rubella booster vaccine; second dose by 3 years and 4 months or soon after'))

Vaccination_terms_df %>% 
  toJSON() %>% 
  write_lines(paste0(output_directory, '/vaccination_terms.json'))

# Annual data files ####
GP_201920_df_raw <- read_ods(paste0(data_directory, '/Child_immunisation_GP_201920.ods'),
         sheet = 'Table_1',
         skip = 3) 

GP_201920_df_raw_1 <- GP_201920_df_raw %>% 
  rename(ODS_Code = 'GPCode') %>% 
  filter(CCGName %in% c('NHS West Sussex CCG', 'NHS COASTAL WEST SUSSEX CCG', 'NHS CRAWLEY CCG', 'NHS HORSHAM AND MID SUSSEX CCG')) %>%
  select(ODS_Code, `12m Denominator`, `24m Denominator`, `5y Denominator`) %>% 
  pivot_longer(cols = 2:ncol(.),
               names_to = 'Age',
               values_to = 'Denominator') %>% 
  mutate(Age = ifelse(Age == '12m Denominator', '12 months',  ifelse(Age == '24m Denominator', '24 months', ifelse(Age == '5y Denominator', '5 years', Age)))) %>% 
  mutate(Denominator = as.numeric(Denominator))

GP_201920_df <- GP_201920_df_raw %>% 
  rename(ODS_Code = 'GPCode') %>% 
  filter(CCGName %in% c('NHS West Sussex CCG', 'NHS COASTAL WEST SUSSEX CCG', 'NHS CRAWLEY CCG', 'NHS HORSHAM AND MID SUSSEX CCG')) %>%
  select(!c(CCGCode, CCGName, ODSLAUA,`12m Denominator`, `24m Denominator`, `5y Denominator`)) %>%
  pivot_longer(cols = 2:ncol(.),
               names_to = 'Item',
               values_to = 'Proportion') %>% 
  mutate(Age = ifelse(str_detect(Item, '^12m'), '12 months', ifelse(str_detect(Item, '^24m'), '24 months', ifelse(str_detect(Item, '^5y'),'5 years', NA)))) %>% 
  mutate(Item = str_trim(side = 'both', gsub('12m', '', gsub('24m', '', gsub('5y', '', gsub('%','', Item)))))) %>% 
  left_join(GP_201920_df_raw_1, by = c('ODS_Code', 'Age')) %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Proportion = Proportion / 100) %>% 
  mutate(Numerator = Denominator * Proportion) %>% 
  mutate(Year = '2019/20') %>% 
  mutate(Benchmark = factor(ifelse(Denominator == 0, 'No eligible patients', ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)'))), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, ODS_Code, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark)
  
rm(GP_201920_df_raw, GP_201920_df_raw_1)

# 2020/21
GP_202021_df_raw <- read_ods(paste0(data_directory, '/Child_immunisation_GP_202021.ods'),
                             sheet = 'Table_1',
                             skip = 2) 

GP_202021_df_raw_1 <- GP_202021_df_raw %>% 
  rename(ODS_Code = 'GP code') %>% 
  filter(`CCG name` %in% c('NHS West Sussex CCG', 'NHS COASTAL WEST SUSSEX CCG', 'NHS CRAWLEY CCG', 'NHS HORSHAM AND MID SUSSEX CCG')) %>%
  select(ODS_Code, `12m Denominator`, `24m Denominator`, `5y Denominator`) %>% 
  pivot_longer(cols = 2:ncol(.),
               names_to = 'Age',
               values_to = 'Denominator') %>% 
  mutate(Age = ifelse(Age == '12m Denominator', '12 months',  ifelse(Age == '24m Denominator', '24 months', ifelse(Age == '5y Denominator', '5 years', Age)))) %>% 
  mutate(Denominator = as.numeric(Denominator))

GP_202021_df <- GP_202021_df_raw %>% 
  rename(ODS_Code = 'GP code') %>% 
  filter(`CCG name` %in% c('NHS West Sussex CCG', 'NHS COASTAL WEST SUSSEX CCG', 'NHS CRAWLEY CCG', 'NHS HORSHAM AND MID SUSSEX CCG')) %>%
  select(!c(`CCG code`, `CCG name`, 'Local authority code', `12m Denominator`, `24m Denominator`, `5y Denominator`)) %>%
  pivot_longer(cols = 2:ncol(.),
               names_to = 'Item',
               values_to = 'Proportion') %>% 
  mutate(Age = ifelse(str_detect(Item, '^12m'), '12 months', ifelse(str_detect(Item, '^24m'), '24 months', ifelse(str_detect(Item, '^5y'),'5 years', NA)))) %>% 
  mutate(Item = str_trim(side = 'both', gsub('12m', '', gsub('24m', '', gsub('5y', '', gsub('%','', Item)))))) %>% 
  left_join(GP_202021_df_raw_1, by = c('ODS_Code', 'Age')) %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Proportion = Proportion / 100) %>% 
  mutate(Numerator = Denominator * Proportion) %>% 
  mutate(Year = '2020/21') %>% 
  mutate(Benchmark = factor(ifelse(Denominator == 0, 'No eligible patients', ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)'))), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, ODS_Code, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(GP_202021_df_raw, GP_202021_df_raw_1)

# 2021/22
GP_202122_df_raw <- read_ods(paste0(data_directory, '/Child_immunisation_GP_202122.ods'),
                             sheet = 'Table_1',
                             skip = 2) 

GP_202122_df_raw_1 <- GP_202122_df_raw %>% 
  rename(ODS_Code = 'GP code') %>% 
  filter(`CCG name` %in% c('NHS West Sussex CCG', 'NHS COASTAL WEST SUSSEX CCG', 'NHS CRAWLEY CCG', 'NHS HORSHAM AND MID SUSSEX CCG')) %>%
  select(ODS_Code, `12m Denominator`, `24m Denominator`, `5y Denominator`) %>% 
  pivot_longer(cols = 2:ncol(.),
               names_to = 'Age',
               values_to = 'Denominator') %>% 
  mutate(Age = ifelse(Age == '12m Denominator', '12 months',  ifelse(Age == '24m Denominator', '24 months', ifelse(Age == '5y Denominator', '5 years', Age)))) %>% 
  mutate(Denominator = as.numeric(Denominator))

GP_202122_df <- GP_202122_df_raw %>% 
  rename(ODS_Code = 'GP code') %>% 
  filter(`CCG name` %in% c('NHS West Sussex CCG', 'NHS COASTAL WEST SUSSEX CCG', 'NHS CRAWLEY CCG', 'NHS HORSHAM AND MID SUSSEX CCG')) %>%
  select(!c(`CCG code`, `CCG name`, 'Local authority code', `12m Denominator`, `24m Denominator`, `5y Denominator`)) %>%
  pivot_longer(cols = 2:ncol(.),
               names_to = 'Item',
               values_to = 'Proportion') %>% 
  mutate(Age = ifelse(str_detect(Item, '^12m'), '12 months', ifelse(str_detect(Item, '^24m'), '24 months', ifelse(str_detect(Item, '^5y'),'5 years', NA)))) %>% 
  mutate(Item = str_trim(side = 'both', gsub('12m', '', gsub('24m', '', gsub('5y', '', gsub('%','', Item)))))) %>% 
  left_join(GP_202122_df_raw_1, by = c('ODS_Code', 'Age')) %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Proportion = Proportion / 100) %>% 
  mutate(Numerator = Denominator * Proportion) %>% 
  mutate(Year = '2021/22') %>% 
  mutate(Benchmark = factor(ifelse(Denominator == 0, 'No eligible patients', ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)'))), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, ODS_Code, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

GP_annual_df <- GP_201920_df %>% 
  bind_rows(GP_202021_df) %>% 
  bind_rows(GP_202122_df) 


# Add GP name and geolocation ####

download.file('https://files.digital.nhs.uk/assets/ods/current/epraccur.zip',
              paste0(data_directory, '/epraccur.zip'),
              mode = 'wb')

unzip(paste0(data_directory, '/epraccur.zip'),
       exdir = data_directory)

gp_mapping <- read_csv(paste0(data_directory, '/epraccur.csv'),
                       col_names = FALSE) %>% 
  select(ODS_Code = X1, ODS_Name = X2, Postcode = X10) %>% 
  mutate(ODS_Name = gsub('Woodlands&Clerklands', 'Woodlands & Clerklands', gsub('\\(Aic\\)', '\\(AIC\\)', gsub('\\(Acf\\)', '\\(ACF\\)', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ',  str_to_title(ODS_Name))))))))

# Geolocating practices ####
gp_mapping <- gp_mapping %>% 
  filter(ODS_Code  %in% GP_annual_df$ODS_Code)

setdiff(GP_annual_df$ODS_Code, gp_mapping$ODS_Code)
# only the unknown GP code in there

for(i in 1:length(unique(gp_mapping$Postcode))){
  if(i == 1){lookup_result <- data.frame(postcode = character(), longitude = double(), latitude = double())
  }
  
  lookup_result_x <- postcode_lookup(unique(gp_mapping$Postcode)[i]) %>% 
    select(postcode, longitude, latitude)
  
  lookup_result <- lookup_result_x %>% 
    bind_rows(lookup_result) 
  
}

gp_locations <- gp_mapping %>%
  left_join(lookup_result, by = c('Postcode' = 'postcode'))  

GP_annual_df_attempt_one <- GP_annual_df %>% 
  left_join(gp_locations, by = 'ODS_Code') 

GP_annual_df_attempt_one %>% 
  filter(is.na(ODS_Name)) %>% 
  select(ODS_Code) %>% 
  unique()

GP_annual_df %>% 
  filter(ODS_Code != 'V81999') %>% 
  toJSON() %>% 
  write_lines(paste0(output_directory, '/GP_immunisations.json'))























quarterly_df <- read_ods(paste0(base_directory, '/hpr1022_COVER_xprmntl-gp-data-tables2.ods'),
                         sheet = 'Table_1',
                         skip = 2) %>% 
  rename(ODS_Code = `GP code`)

# filter Wsx GPs and remove the unknown gp code
wsx_quarterly_denominator_df <- quarterly_df %>% 
  filter(`CCG name` == 'NHS West Sussex CCG') %>% 
  filter(ODS_Code != 'V81999')  %>% 
  select(ODS_Code, `12m Denominator`, `24m Denominator`, `5y Denominator`) %>% 
  pivot_longer(cols = 2:ncol(.),
               names_to = 'Age',
               values_to = 'Denominator') %>% 
  mutate(Age = ifelse(Age == '12m Denominator', '12 months',  ifelse(Age == '24m Denominator', '24 months', ifelse(Age == '5y Denominator', '5 years', Age))))

wsx_quarterly_df <- quarterly_df %>% 
  filter(`CCG name` == 'NHS West Sussex CCG') %>% 
  filter(ODS_Code != 'V81999') %>% 
  select(!c('12m Denominator', '24m Denominator', '5y Denominator', 'CCG code', 'CCG name', 'local authority code')) %>% 
  pivot_longer(cols = 2:ncol(.),
               names_to = 'x',
               values_to = 'Proportion') %>% 
  mutate(Age = ifelse(str_detect(x,'12m'), '12 months',  ifelse(str_detect(x,'24m'), '24 months', ifelse(str_detect(x,'5y'), '5 years', x)))) %>% 
  # mutate(Vaccination = trimws(gsub('%', '', substr(x, 4, nchar(x))), 'left')) #
  mutate(Vaccination = substr(x, 4, nchar(x))) %>%  # start on character number 4 onwards (remove characters 1-3)
  mutate(Vaccination = gsub('%', '', Vaccination)) %>% # find and replace the %
  mutate(Vaccination = trimws(Vaccination, which = 'left')) %>%  # remove the leading (left) white space
  mutate(Proportion = Proportion/100) %>% 
  select(!x) %>% 
  left_join(wsx_quarterly_denominator_df, by = c('ODS_Code', 'Age')) %>%
  mutate(Denominator = as.numeric(Denominator)) %>% 
  mutate(Vaccinated = Denominator * Proportion) %>% 
  mutate(Coverage = factor(ifelse(is.na(Proportion), 'Cannot be calculated', ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', ifelse(Proportion <= 1, 'High (95%+)', NA)))), levels = c('High (95%+)', 'Medium (90-95%)', 'Low (<90%)', 'Cannot be calculated')))

# wsx_quarterly_df %>% 
#   filter(Vaccination == 'MenB') %>% 
#   filter(Age == '12 months') %>% 
#   View()

# LTLA aggregated summary
# download.file('https://files.digital.nhs.uk/A5/2F555C/Child_Vacc_2021-22_CSV_Data.zip',
#               paste0(base_directory, '/Child_Vacc_2021-22_CSV_Data.zip'),
#               mode = 'wb')
# 
# unzip(paste0(base_directory, '/Child_Vacc_2021-22_CSV_Data.zip'),
#       exdir = base_directory)

# filter WSx
# pivot table

# GP metadata ####

if(file.exists(paste0(base_directory, '/epraccur.csv')) != TRUE){
download.file('https://files.digital.nhs.uk/assets/ods/current/epraccur.zip',
              paste0(base_directory, '/epraccur.zip'),
              mode = 'wb')

unzip(paste0(base_directory, '/epraccur.zip'),
      exdir = base_directory)
}

gp_df <- read_csv(paste0(base_directory, '/epraccur.csv'),
                  col_names = c("ODS_Code", "ODS_Name", "National_grouping","Health_geography","Address_1","Address_2", "Address_3", "Address_4", "Address_5", "Postcode", "Open_date", "Close_date", "Status", "Organisation_sub_type", "Commissioner", "Join_provider_date", "Left_provider_date", "Contact_number", 'Null_1', 'Null_2', 'Null_3', "Amended_record_identifier", 'Null_4', "Provider_purchaser", 'Null_6', "Prescribing_setting", 'Null_7')) %>% 
  mutate(Status = ifelse(Status == "A", "Active", ifelse(Status == "C", "Closed", ifelse(Status == "D", "Dormant", ifelse(Status == "P", "Proposed", NA))))) %>% 
  mutate(Open_date = ifelse(is.na(Open_date), NA, paste(substr(Open_date, 1,4), substr(Open_date, 5,6), substr(Open_date, 7,8), sep = '-'))) %>% 
  mutate(Close_date = ifelse(is.na(Close_date), NA, paste(substr(Close_date, 1,4), substr(Close_date, 5,6), substr(Close_date, 7,8), sep = '-'))) %>%
  mutate(Open_date = as.Date(Open_date)) %>% 
  mutate(Close_date = as.Date(Close_date)) %>% 
  mutate(ODS_Name = gsub('Cdc', 'CDC', gsub('Gp', 'GP', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ', gsub('Bdct ', 'BDCT ', gsub(' Eis ', ' EIS ', gsub(' Ld ', ' LD ',  str_to_title(ODS_Name)))))))))) %>% 
  mutate(Address_label = gsub(', NA','', paste(str_to_title(Address_1), str_to_title(Address_2),str_to_title(Address_3),str_to_title(Address_4), str_to_title(Address_5), Postcode, sep = ', '))) %>% 
  select(ODS_Code, ODS_Name, Health_geography, Commissioner, Address_label, Postcode, Open_date, Close_date, Status)

gp_df <- gp_df %>% 
  filter(ODS_Code %in% wsx_quarterly_df$ODS_Code)

# GIS - geolocation

# Loop through our key_geocodes df rows and lookup the postcodes 
for(i in 1:nrow(gp_df)){
  
  # if this is the start of the loop (i.e. i = 1), then create an empty dataframe in which we append results from the look up to. I am only going to keep the postcode, lat/long and lsoa_code this time (not the 35 fields available)
  if(i == 1){lookup_result <- data.frame(postcode = character(), longitude = double(), latitude = double(), lsoa_code = character())}
  
  lookup_result_x <- postcode_lookup(gp_df$Postcode[i]) %>% 
    select(postcode, longitude, latitude, lsoa_code)
  
  lookup_result <- lookup_result_x %>% 
    bind_rows(lookup_result) # This adds the individual result (result_x) to the bigger dataframe
}

gp_df <- gp_df %>% 
  left_join(lookup_result, by = c('Postcode' = 'postcode'))

wsx_quarterly_df <- wsx_quarterly_df %>% 
  left_join(gp_df, by = 'ODS_Code')

# Maps ####

ages <- c('12 months', '24 months', '5 years')

vaccination_x <- 'MenB'
age_x <- '12 months'

imms_data_x <- wsx_quarterly_df %>% 
  filter(Vaccination == vaccination_x) %>%
  filter(Age == age_x)

imms_data_y <- wsx_quarterly_df %>% 
  filter(Vaccination == 'Rota') %>%
  filter(Age == age_x)

# download wsx county boundaries

query <- 'https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Counties_and_Unitary_Authorities_December_2021_EN_BFC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson'
boundary_sf <- st_read(query)

# plot(boundary_sf)
wsx_boundary_sf <- boundary_sf %>% 
  filter(CTYNME == 'West Sussex')

wsx_spdf <- as_Spatial(wsx_boundary_sf, IDs = wsx_boundary_sf$CTYNME)

# https://rstudio.github.io/leaflet/

levels(wsx_quarterly_df$Coverage)
traffic_light_colours <- c('#92D050', '#FFC000', '#C00000','#dbdbdb')

vaccinated_colour_function <- colorFactor(palette = traffic_light_colours, 
                                        levels = levels(wsx_quarterly_df$Coverage))

leaflet(imms_data_x) %>% 
  addControl(paste0("<font size = '1px'><b>West Sussex Childhood immunisations by GP practice code for quarter 1 2022 to 2023:</b><br>Data correct as at November 2022;</font>"),
             position = 'topright') %>%
  addTiles(urlTemplate = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
           attribution = paste0('&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a><br>Contains OS data ? Crown copyright and database right 2021<br>Zoom in/out using your mouse wheel or the plus (+) and minus (-) buttons and click on an circle to find out more.')) %>% 
  addPolygons(data = wsx_spdf,
              fill = FALSE,
              stroke = TRUE, # outline
              color = 'maroon', # outline colour
              weight = 2.5, # outline width
              fillOpacity = .8) %>% 
  addCircleMarkers(lng = imms_data_x$longitude,
                   lat = imms_data_x$latitude,
                   label = imms_data_x$ODS_Name,
                   popup = paste0(imms_data_x$ODS_Name, '<br><br>Percentage vaccinated: ', round(imms_data_x$Proportion *100, 1), '%'),
                   color = vaccinated_colour_function(imms_data_x$Coverage),
                   radius = 6,
                   fillOpacity = 1,
                  stroke = FALSE,
                  group = 'MenB') %>% 
  addCircleMarkers(lng = imms_data_y$longitude,
                   lat = imms_data_y$latitude,
                   label = imms_data_y$ODS_Name,
                   popup = paste0(imms_data_y$ODS_Name, '<br><br>Percentage vaccinated: ', round(imms_data_y$Proportion *100, 1), '%'),
                   color = vaccinated_colour_function(imms_data_y$Coverage),
                   radius = 6,
                   fillOpacity = 1,
                   stroke = FALSE,
                   group = 'ROTA') %>% 
   addLegend(colors = vaccinated_colour_function(levels(imms_data_x$Coverage)),
             labels = levels(imms_data_x$Coverage),
             title = 'Vaccination coverage',
             opacity = 1,
             position = 'bottomright') %>% 
   addLayersControl(
    baseGroups = c("MenB", 'ROTA'),
    options = layersControlOptions(collapsed = FALSE)
  )

# Outputs ####
# To save data to excel files
library(openxlsx)

# create a new workbook for outputs
wb <- createWorkbook()
sheet <- addWorksheet(wb, sheetName = "README")

# Styles for the data table row/column names
cs_title <- createStyle(fontSize = 12,
                        textDecoration = 'bold',
                        fontName = 'Calibri',
                        halign = 'left',
                        wrapText = FALSE)

cs_subtitle <- createStyle(fontSize = 11,
                           textDecoration = 'bold',
                           fontColour = '#8B0000')

cs_left_cell <- createStyle(fontSize = 11,
                            fontName = 'Calibri',
                            halign = 'left',
                            valign = 'top',
                            wrapText = TRUE)

writeData(wb, 
          sheet, 
          startCol = 2, 
          startRow = 2, 
          title_1)

addStyle(wb, 
         sheet,
         cs_title, 
         rows = 2, 
         cols = 2, 
         gridExpand = FALSE, 
         stack = FALSE)

writeData(wb, 
          sheet, 
          startRow = 3,
          startCol = 2, 
          subtitle_1)

addStyle(wb, 
         sheet,
         cs_subtitle, 
         rows = 3, 
         cols = 2, 
         gridExpand = FALSE, 
         stack = FALSE)

writeData(wb, 
          sheet,
          startRow = 5, 
          startCol = 2, 
          method_2)

addStyle(wb, 
         sheet,
         cs_left_cell, 
         rows = 5, 
         cols = 2, 
         gridExpand = FALSE, 
         stack = FALSE)

setColWidths(wb, 
             sheet, 
             cols = 1:2, 
             widths = c(5,30))
# 
# mergeCells(wb, 
#            sheet, 
#            cols = 2:13,
#            rows = 4:5)

sheet_2 <- addWorksheet(wb, sheetName = "Table 1")

writeData(wb, 
          sheet_2, 
          startCol = 2, 
          startRow = 2, 
          'Fancy title')

writeData(wb, 
          sheet_2, 
          startCol = 2, 
          startRow = 4, 
          quarterly_df)

addFilter(wb,
          sheet_2, 
          rows = 4, 
          cols = 1:ncol(quarterly_df)+1)

saveWorkbook(wb, 
             file = paste0(base_directory, '/starting_workbook.xlsx'), 
             overwrite = TRUE)
