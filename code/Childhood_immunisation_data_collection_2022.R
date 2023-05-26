# Loading some packages 
packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'ggpol', 'magick', 'officer', 'leaflet', 'leaflet.extras', 'zoo', 'fingertipsR', 'PostcodesioR', 'ggrepel', 'readODS', 'openxlsx',  'httr', 'rvest', 'PHEindicatormethods')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

# base directory
# base_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/Child & maternity/Immunisation'
base_directory <- '~/Repositories/child_immunisations/'
data_directory <- paste0(base_directory, 'data')
output_directory <- paste0(base_directory, '/site/outputs')

# To see what is in the directory already
#list.files(data_directory)

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
# 
# title_1 <- 'Coverage of Childhood Vaccinations'
# subtitle_1 <- 'This data is experimental and should be treated with caution. It is not an official statistic.'
# 
# intro_text_1 <- 'This workbook presents data on coverage of routine childhood vaccinations (from birth to age 5) in primary care settings in West Sussex. COVER data is provided by the Child Health Information Service (CHIS) providers and is reported in the public domain quarterly and annually.'
# 
# quarterly_text_old_source <- 'https://www.gov.uk/government/statistics/cover-of-vaccination-evaluated-rapidly-cover-programme-2021-to-2022-quarterly-data'
# 
# quarterly_text_new_source <- 'https://www.gov.uk/government/statistics/cover-of-vaccination-evaluated-rapidly-cover-programme-2022-to-2023-quarterly-data'
# 
# routine_imms_schedule_source <- 'https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1055877/UKHSA-12155-routine-complete-immunisation-schedule_Feb2022.pdf'
# 
# annual_text_source <- 'https://www.gov.uk/government/publications/cover-of-vaccination-evaluated-rapidly-cover-programme-annual-data'
# 
# caveat_1 <- 'In 2019/20, Public Health England (PHE) published annual COVER data (previously published by NHS England). This was the first year where annual GP practice level coverage was based on a refreshed extract, which allowed for corrections to be made following quarterly submissions. This data is also aggregated in the National General Practice Profiles on Fingertips, although there is a time lag.'
# 
# 
# caveat_2 <-  'Annual GP practice level coverage data has also been published for 2020/21. Disruption due to the COVID-19 pandemic is likely to have caused some decreases in vaccine coverage, particularly for the 12 month cohort.'
# 
# caveat_3 <- 'Annual data at higher geographies is also published by NHS Digital and is reproduced on fingertips. Data collections are quality assured at the time of collection by UKHSA and further validation is carried out by NHS Digital prior to publication (detailed here - https://digital.nhs.uk/data-and-information/publications/statistical/nhs-immunisation-statistics/england---2020-21/appendices).'
# 
# caveat_4 <- 'Annual data for England, by financial year, is collected by the UK Health Security Agency (UKHSA) under the COVER programme with further checks and final publication by NHS Digital as national statistics. Annual data is more complete and should be used to look at longer term trends.'
# 
# method_1 <- 'Where possible, published annual data has been presented from published sources (as oppoesed to aggregated data from quarterly releases). However, due to a lag in the release of annual data, coverage has been estimated from quarterly releases in some instances.'
# 
# method_2 <- 'Due to suppression of small counts, data was not available for all quarters for a small number of GP Practices - estimated annual coverage is not presented at GP practice level in these cases. At PCN and West Sussex level, all available GP practice data was aggregated to the appropriate geography.Numerators and denominators therefore do not reflect the entire eligible cohort in cases where GP practice level data was incomplete. Recent quarterly data is also presented to give early insight into practices that may have low coverage, although this data is unvalidated.'

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


# Coverage at this level is available annually, up to 2022/23 (which we are part way through) and Q1 2022/23 is available.


# 2017/18
if(file.exists(paste0(data_directory, '/Child_immunisation_LA_201718.xlsx')) != TRUE){
  download.file('https://files.digital.nhs.uk/F7/6ADF26/child-vacc-stat-eng-2017-18-tab.xlsx',
                paste0(data_directory, '/Child_immunisation_LA_201718.xlsx'),
                mode = 'wb')
}

# 2018/19
if(file.exists(paste0(data_directory, '/Child_immunisation_LA_201819.xlsx')) != TRUE){
  download.file('https://files.digital.nhs.uk/E2/AD3BF4/child-vacc-stat-eng-2018-19-tables.xlsx',
                paste0(data_directory, '/Child_immunisation_LA_201819.xlsx'),
                mode = 'wb')
}

# 2019/20
if(file.exists(paste0(data_directory, '/Child_immunisation_LA_201920.xlsx')) != TRUE){
  download.file('https://files.digital.nhs.uk/1A/CA4551/child-vacc-stat-eng-2019-20-data-tables.xlsx',
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

if(file.exists(paste0(data_directory, '/Child_immunisation_LA_202223_Q3.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1145492/LA_cover-data-tables-quarter-3-2022-2023X.ods',
                paste0(data_directory, '/Child_immunisation_LA_202223_Q3.ods'),
                mode = 'wb')
}



Vaccination_terms_df <- data.frame(Item = c('DTaPIPVHibHepB', 'MenB', 'PCV1', 'PCV2', 'Rota', 'DTaP/IPV/Hib(Hep)', 'MMR1', 'Hib/MenC', 'PCV Booster', 'MenB Booster', 'DTaP/IPV/Hib', 'DTaPIPV', 'MMR2'), Term = c('DTaP/IPV/Hib/HepB vaccine (Diptheria, tetanus, pertussis, polio, haemophilus influenzae type B and hepatitis B), known as hexavalent vaccine or 6-in-1', 'Meningococcal group B disease vaccine', 'Pneumococcal conjulate vaccine (first dose by 12 weeks)', 'Pneumococcal conjulate vaccine (first dose by 12 weeks)', 'Rotavirus vaccine (primary course, with first dose at 8 weeks and second at 12 weeks)', 'DTaP/IPV/Hib/HepB vaccine (Diptheria, tetanus, pertussis, polio, haemophilus influenzae type B and hepatitis B), known as hexavalent vaccine or 6-in-1; three doses at any time by second birthday', 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Pneumococcal conjulate disease booster vaccine; dose by second birthday', 'Meningococcal group B disease booster vaccine; completed by fifth birthday', 'DTaP/IPV/Hib/HepB vaccine (Diptheria, tetanus, pertussis, polio, haemophilus influenzae type B and hepatitis B), known as hexavalent vaccine or 6-in-1; completing booster dose by fifth birthday', 'pre-school diphtheria, tetanus, acellular pertussis and polio (DTaP/IPV) booster; completing booster dose by fifth birthday', 'Measles, mumps, and rubella booster vaccine; second dose by 3 years and 4 months or soon after'))

Vaccination_terms_df %>% 
  toJSON() %>% 
  write_lines(paste0(output_directory, '/vaccination_terms.json'))

# 2017/18 ####

LA_201718_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                               sheet = "Table 8b", skip = 21) %>% 
  select(Area = ...2, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  mutate(Denominator = as.numeric(Denominator) * 1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2017/18',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_201718_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                                sheet = "Table 8b", skip = 21) %>%
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  mutate(Denominator = as.numeric(Denominator) * 1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2017/18',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_201718_12_m_p <- LA_201718_12_m_p %>% 
  bind_rows(Eng_201718_12_m_p) %>% 
  unique()

Eng_201718_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                            sheet = "Table 8c", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, DTaPIPVHibHepB = `(DTaP/IPV/Hib)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>%  
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator)) 

LA_201718_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  select(Area = ...2, DTaPIPVHibHepB = `(DTaP/IPV/Hib)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_201718_12_m) %>% 
  left_join(LA_201718_12_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201718_12_m_p, Eng_201718_12_m_p, Eng_201718_12_m)

LA_201718_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                               sheet = "Table 9b", skip = 20) %>% 
  select(Area = ...2, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2017/18',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_201718_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
        sheet = "Table 9b", skip = 20) %>% 
           filter(...1 == 'England') %>% 
           select(Area = ...1, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`) %>% 
           mutate(Denominator = as.numeric(Denominator)*1000) %>% 
           pivot_longer(names_to = 'Item',
                        cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`),
                        values_to = 'Proportion') %>% 
           mutate(Proportion = as.numeric(Proportion) / 100) %>% 
           mutate(Year = '2017/18',
                  Age = '24 months') %>% 
           left_join(Vaccination_terms_df, by = 'Item') 

LA_201718_24_m_p <- LA_201718_24_m_p %>% 
  bind_rows(Eng_201718_24_m_p) %>% 
  unique()
         
Eng_201718_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                              sheet = "Table 9c", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) 

LA_201718_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                             sheet = "Table 9c", skip = 20) %>% 
  select(Area = ...2, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_201718_24_m) %>% 
  left_join(LA_201718_24_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201718_24_m_p, Eng_201718_24_m, Eng_201718_24_m_p)

LA_201718_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  select(Area = ...2, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator)* 1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2017/18',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

Eng_201718_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator)* 1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2017/18',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

LA_201718_5_y_p <- LA_201718_5_y_p %>% 
  bind_rows(Eng_201718_5_y_p) %>% 
  unique()

Eng_201718_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                            sheet = "Table 10c", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator))

LA_201718_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_201718.xlsx", 
                            sheet = "Table 10c", skip = 20) %>% 
  select(Area = ...2, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_201718_5_y) %>% 
  left_join(LA_201718_5_y_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201718_5_y_p, Eng_201718_5_y, Eng_201718_5_y_p)

LA_201718 <- LA_201718_12_m %>% 
  bind_rows(LA_201718_24_m) %>% 
  bind_rows(LA_201718_5_y) %>%
  filter(Area %in% c('West Sussex', 'England'))

rm(LA_201718_12_m, LA_201718_24_m, LA_201718_5_y)

# 2018/19 #####
LA_201819_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                               sheet = "Table 8b", skip = 21) %>% 
  select(Area = ...2, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib)(2)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2018/19',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_201819_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                               sheet = "Table 8b", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib)(2)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2018/19',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_201819_12_m_p <- LA_201819_12_m_p %>% 
  bind_rows(Eng_201819_12_m_p) %>% 
  unique()

Eng_201819_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, DTaPIPVHibHepB = `(DTaP/IPV/Hib)(2)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator')  %>% 
  mutate(Numerator = as.numeric(Numerator))

LA_201819_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  select(Area = ...2, DTaPIPVHibHepB = `(DTaP/IPV/Hib)(2)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator)) %>%
  bind_rows(Eng_201819_12_m) %>% 
  left_join(LA_201819_12_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201819_12_m_p, Eng_201819_12_m, Eng_201819_12_m_p)

LA_201819_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                               sheet = "Table 9b", skip = 20) %>% 
  select(Area = ...2, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  mutate(Denominator = as.numeric(Denominator) * 1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2018/19',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_201819_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                               sheet = "Table 9b", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  mutate(Denominator = as.numeric(Denominator) * 1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2018/19',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_201819_24_m_p <- LA_201819_24_m_p %>% 
  bind_rows(Eng_201819_24_m_p) %>% 
  unique()

Eng_201819_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                             sheet = "Table 9c", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>%   pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) 

LA_201819_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                             sheet = "Table 9c", skip = 20) %>% 
  select(Area = ...2, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_201819_24_m) %>% 
  left_join(LA_201819_24_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201819_24_m_p, Eng_201819_24_m, Eng_201819_24_m_p)

LA_201819_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  select(Area = ...2, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator) *1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2018/19',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

Eng_201819_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator) *1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2018/19',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))


LA_201819_5_y_p <- LA_201819_5_y_p %>% 
  bind_rows(Eng_201819_5_y_p) %>% 
  unique()

Eng_201819_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                            sheet = "Table 10c", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) 

LA_201819_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_201819.xlsx", 
                            sheet = "Table 10c", skip = 20) %>% 
  select(Area = ...2, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_201819_5_y) %>% 
  left_join(LA_201819_5_y_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201819_5_y_p, Eng_201819_5_y, Eng_201819_5_y_p)

LA_201819 <- LA_201819_12_m %>% 
  bind_rows(LA_201819_24_m) %>% 
  bind_rows(LA_201819_5_y) %>% 
  filter(Area %in% c('West Sussex', 'England'))

rm(LA_201819_12_m, LA_201819_24_m, LA_201819_5_y)

# 2019/20 ####
LA_201920_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                               sheet = "Table 8b", skip = 21) %>% 
  select(Area = ...2, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2019/20',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_201920_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                               sheet = "Table 8b", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2019/20',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_201920_12_m_p <- LA_201920_12_m_p %>% 
  bind_rows(Eng_201920_12_m_p) %>% 
  unique()

Eng_201920_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator))

LA_201920_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  select(Area = ...2, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)`, MenB = MenB, Rota = Rotavirus) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_201920_12_m) %>% 
  left_join(LA_201920_12_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201920_12_m_p, Eng_201920_12_m, Eng_201920_12_m_p)

LA_201920_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                               sheet = "Table 9b", skip = 20) %>% 
  select(Area = ...2, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  mutate(Denominator = as.numeric(Denominator)* 1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2019/20',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_201920_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                               sheet = "Table 9b", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  mutate(Denominator = as.numeric(Denominator)* 1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2019/20',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_201920_24_m_p <- LA_201920_24_m_p %>% 
  bind_rows(Eng_201920_24_m_p) %>% 
  unique()

Eng_201920_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                             sheet = "Table 9c", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator))

LA_201920_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                             sheet = "Table 9c", skip = 20) %>% 
  select(Area = ...2, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>%
  bind_rows(Eng_201920_24_m) %>% 
  left_join(LA_201920_24_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201920_24_m_p, Eng_201920_24_m_p, Eng_201920_24_m)

LA_201920_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  select(Area = ...2, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2019/20',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

Eng_201920_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                              sheet = "Table 10b", skip = 20) %>%
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2019/20',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

LA_201920_5_y_p <- LA_201920_5_y_p %>% 
  bind_rows(Eng_201920_5_y_p) %>% 
  unique()

Eng_201920_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                            sheet = "Table 10c", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) 

LA_201920_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_201920.xlsx", 
                            sheet = "Table 10c", skip = 20) %>% 
  select(Area = ...2, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_201920_5_y) %>% 
  left_join(LA_201920_5_y_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_201920_5_y_p, Eng_201920_5_y, Eng_201920_5_y_p)

LA_201920 <- LA_201920_12_m %>% 
  bind_rows(LA_201920_24_m) %>% 
  bind_rows(LA_201920_5_y) %>% 
  filter(Area %in% c('West Sussex', 'England'))

rm(LA_201920_12_m, LA_201920_24_m, LA_201920_5_y)

# 2020/21 ####
LA_202021_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                               sheet = "Table 8b", skip = 22) %>% 
  select(Area = ...2, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)(3)`, MenB = MenB, Rota = Rotavirus) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2020/21',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_202021_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                               sheet = "Table 8b", skip = 22) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)(3)`, MenB = MenB, Rota = Rotavirus) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2020/21',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_202021_12_m_p <- LA_202021_12_m_p %>% 
  bind_rows(Eng_202021_12_m_p) %>% 
  unique()

Eng_202021_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, DTaPIPVHibHepB = `(DTaP/IPV/Hib)(2)`, PCV2 = `(PCV)(3)`, MenB = MenB, Rota = Rotavirus) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator)) 

LA_202021_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  select(Area = ...2, DTaPIPVHibHepB = `(DTaP/IPV/Hib)(2)`, PCV2 = `(PCV)(3)`, MenB = MenB, Rota = Rotavirus) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_202021_12_m) %>% 
  left_join(LA_202021_12_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_202021_12_m_p, Eng_202021_12_m, Eng_202021_12_m_p)

LA_202021_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                               sheet = "Table 9b", skip = 21) %>% 
  select(Area = ...2, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib/HepB)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC` = `Hib/MenC(3)`, `MenB Booster` = MenB) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2020/21',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_202021_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                               sheet = "Table 9b", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib/HepB)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC` = `Hib/MenC(3)`, `MenB Booster` = MenB) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2020/21',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_202021_24_m_p <- LA_202021_24_m_p %>% 
  bind_rows(Eng_202021_24_m_p) %>% 
  unique()

Eng_202021_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                             sheet = "Table 9c", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib/HepB)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC` = `Hib/MenC(3)`, `MenB Booster` = MenB) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator))

LA_202021_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                             sheet = "Table 9c", skip = 21) %>% 
  select(Area = ...2, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib/HepB)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC` = `Hib/MenC(3)`, `MenB Booster` = MenB) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_202021_24_m) %>% 
  left_join(LA_202021_24_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_202021_24_m_p, Eng_202021_24_m, Eng_202021_24_m_p)

LA_202021_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  select(Area = ...2, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator) *1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2020/21',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

Eng_202021_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator) *1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2020/21',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

LA_202021_5_y_p <- LA_202021_5_y_p %>% 
  bind_rows(Eng_202021_5_y_p) %>% 
  unique()

Eng_202021_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                            sheet = "Table 10c", skip = 19) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) 

LA_202021_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_202021.xlsx", 
                            sheet = "Table 10c", skip = 19) %>% 
  select(Area = ...2, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_202021_5_y) %>% 
  left_join(LA_202021_5_y_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_202021_5_y_p, Eng_202021_5_y, Eng_202021_5_y_p)

LA_202021 <- LA_202021_12_m %>% 
  bind_rows(LA_202021_24_m) %>% 
  bind_rows(LA_202021_5_y) %>% 
  filter(Area %in% c('West Sussex', 'England'))

rm(LA_202021_12_m, LA_202021_24_m, LA_202021_5_y)

# 2021/22 ####

LA_202122_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                               sheet = "Table 8b", skip = 22) %>% 
  select(Area = ...2, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)(3)`, MenB = MenB, Rota = Rotavirus) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2021/22',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_202122_12_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                               sheet = "Table 8b", skip = 22) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)(3)`, MenB = MenB, Rota = Rotavirus) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2021/22',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_202122_12_m_p <- LA_202122_12_m_p %>% 
  bind_rows(Eng_202122_12_m_p) %>% 
  unique()

Eng_202122_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)(3)`, MenB = MenB, Rota = Rotavirus) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator)) 

LA_202122_12_m <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                             sheet = "Table 8c", skip = 21) %>% 
  select(Area = ...2, DTaPIPVHibHepB = `(DTaP/IPV/Hib/HepB)(2)`, PCV2 = `(PCV)(3)`, MenB = MenB, Rota = Rotavirus) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Numerator') %>% 
  mutate(Numerator = as.numeric(Numerator)) %>%
  bind_rows(Eng_202122_12_m) %>% 
  left_join(LA_202122_12_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_202122_12_m_p, Eng_202122_12_m, Eng_202122_12_m_p)

LA_202122_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                               sheet = "Table 9b", skip = 21) %>% 
  select(Area = ...2, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib/HepB)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2021/22',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

Eng_202122_24_m_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                               sheet = "Table 9b", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `(thousands)`, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib/HepB)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC`, `MenB Booster` = MenB) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2021/22',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LA_202122_24_m_p <- LA_202122_24_m_p %>% 
  bind_rows(Eng_202122_24_m_p) %>% 
  unique()

Eng_202122_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                             sheet = "Table 9c", skip = 21) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib/HepB)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC` = `Hib/MenC`, `MenB Booster` = MenB) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator))


LA_202122_24_m <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                             sheet = "Table 9c", skip = 21) %>% 
  select(Area = ...2, `DTaP/IPV/Hib(Hep)` = `(DTaP/IPV/Hib/HepB)(2)`, MMR1 = MMR, `PCV Booster` = `(PCV)`, `Hib/MenC` = `Hib/MenC`, `MenB Booster` = MenB) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib(Hep)`, MMR1, `PCV Booster`, `Hib/MenC`, `MenB Booster`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_202122_24_m) %>% 
  left_join(LA_202122_24_m_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_202122_24_m_p, Eng_202122_24_m_p, Eng_202122_24_m)

LA_202122_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  select(Area = ...2, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2021/22',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

Eng_202122_5_y_p <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                              sheet = "Table 10b", skip = 20) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, Denominator = `aged 5`, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  mutate(Denominator = as.numeric(Denominator)*1000) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Proportion = as.numeric(Proportion) / 100) %>% 
  mutate(Year = '2021/22',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') %>% 
  mutate(Term = ifelse(Term == 'Measles, mumps, and rubella vaccine; first dose by 1 year', 'Measles, mumps, and rubella vaccine; first dose', ifelse(Term == 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by 2 years', 'Haemophilus influenzae type b/Meningococcal group C disease; booster dose by five years', Term)))

LA_202122_5_y_p <- LA_202122_5_y_p %>% 
  bind_rows(Eng_202122_5_y_p) %>% 
  unique()

Eng_202122_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                            sheet = "Table 10c", skip = 19) %>% 
  filter(...1 == 'England') %>% 
  select(Area = ...1, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator))

LA_202122_5_y <- read_excel("child_immunisations/data/Child_immunisation_LA_202122.xlsx", 
                            sheet = "Table 10c", skip = 19) %>% 
  select(Area = ...2, `DTaP/IPV/Hib` = `(DTaP/IPV/Hib)`, DTaPIPV = Pertussis, MMR1 = MMR...8, MMR2 = MMR...9, `Hib/MenC`) %>% 
  filter(Area != 'Local Authority (LA)' & !is.na(Area)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(`DTaP/IPV/Hib`, MMR1, MMR2, DTaPIPV, `Hib/MenC`),
               values_to = 'Numerator') %>%
  mutate(Numerator = as.numeric(Numerator)) %>% 
  bind_rows(Eng_202122_5_y) %>% 
  left_join(LA_202122_5_y_p, by = c('Area', 'Item')) %>% 
  mutate(Benchmark = factor(ifelse(Proportion < .9, 'Low (<90%)', ifelse(Proportion < .95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  select(Year, Area, Age, Item, Term, Numerator, Denominator, Proportion, Benchmark) %>% 
  mutate(Term = ifelse(Year == '2020/21' & Item == 'PCV2', 'PCV vaccine (pneumococcal disease; second dose - scheduling has since changed)', Term))

rm(LA_202122_5_y_p, Eng_202122_5_y, Eng_202122_5_y_p)

LA_202122 <- LA_202122_12_m %>% 
  bind_rows(LA_202122_24_m) %>% 
  bind_rows(LA_202122_5_y) %>% 
  filter(Area %in% c('West Sussex', 'England'))

rm(LA_202122_12_m, LA_202122_24_m, LA_202122_5_y)

lookup_terms <- data.frame(Item = c('DTaPIPVHibHepB', 'PCV2', 'MenB', 'Rota', 'MMR1', 'PCV Booster', 'Hib/MenC', 'DTaP/IPV/Hib(Hep)', 'MenB Booster', 'MMR2', 'DTaPIPV'), Description = c('DTaP/IPV/Hib/HepB vaccine*', 'Pneumococcal conjulate vaccine (PCV)', 'Meningococcal group B', 'Rotavirus', 'Measles, mumps, and rubella vaccine dose 1', 'PCV booster', 'Haemophilus influenzae type B and Meningococcal group C booster', '6-in-1 booster (three doses by second birthday)', 'Meningococcal group B booster', 'Measles, mumps, and rubella vaccine dose 1 and 2', 'Diphtheria, Tetanus, Polio, Pertussis booster'))

LA_annual_df_a <- LA_201718 %>% 
  bind_rows(LA_201819) %>% 
  bind_rows(LA_201920) %>% 
  bind_rows(LA_202021) %>% 
  bind_rows(LA_202122) %>% 
  left_join(lookup_terms, by = 'Item') %>% 
  mutate(phe_proportion(., Numerator, Denominator)) %>% 
  select(!c('Term', 'statistic', 'method', 'confidence', 'value'))

eng_annual_df <- LA_annual_df_a %>% 
  filter(Area == 'England') %>% 
  select(Year, Age, Item, Eng_LCL = lowercl, Eng_UCL = uppercl)

LA_annual_df <- LA_annual_df_a %>% 
  left_join(eng_annual_df, by = c('Year', 'Age', 'Item')) %>% 
  mutate(Significance = ifelse(Area == 'England', 'England', ifelse(lowercl > Eng_UCL, 'Higher', ifelse(uppercl < Eng_LCL, 'Lower', 'Similar')))) %>% 
  select(Area, Year, Age, Item, Description, Numerator, Denominator, Proportion, Lower_CL = lowercl, Upper_CL = uppercl, Benchmark, Significance) %>% 
  ungroup()

LA_annual_table_values <- LA_annual_df %>%
  filter(Area == 'West Sussex') %>% 
  select(Age, Year, Item, Proportion) %>% 
  mutate(Proportion = ifelse(is.na(Proportion), '-', paste0(round(Proportion * 100, 1), '%'))) %>% 
  mutate(Proportion = ifelse(Year == '2021/22' & Age == '12 months' & Item == 'DTaPIPVHibHepB', '94.9%', Proportion)) %>% 
  pivot_wider(names_from = 'Year',
              values_from = 'Proportion') %>% 
  mutate(`2017/18` = replace_na(`2017/18`, '-')) 

LA_annual_table_labels <- LA_annual_df %>%
  filter(Area == 'West Sussex') %>% 
  select(Age, Year, Item, Numerator, Denominator, Proportion) %>%
  mutate(Proportion = ifelse(is.na(Proportion), '-', paste0(round(Proportion *100, 1), '% (', format(Numerator, big.mark = ','),'/', format(Denominator, big.mark = ','),')'))) %>%
  select(!c(Numerator, Denominator)) %>% 
  pivot_wider(names_from = 'Year',
              values_from = 'Proportion') %>% 
  mutate(`2017/18` = replace_na(`2017/18`, '-')) 

LA_annual_table_benchmark_values <- LA_annual_df %>% 
  filter(Area == 'West Sussex') %>% 
  select(Age, Year, Item, Benchmark) %>% 
  mutate(Benchmark = ifelse(is.na(Benchmark), '-', as.character(Benchmark))) %>% 
  pivot_wider(names_from = 'Year',
              values_from = 'Benchmark',
              names_prefix = 'Benchmark') %>% 
  mutate(`Benchmark2017/18` = replace_na(`Benchmark2017/18`, '-'))

LA_annual_table_values %>% 
  left_join(LA_annual_table_benchmark_values, by = c('Age', 'Item')) %>% 
  toJSON() %>% 
  write_lines(paste0(output_directory, '/LTLA_annual_table.json'))

LA_annual_df %>% 
  toJSON() %>% 
  write_lines(paste0(output_directory, '/LTLA_annual.json'))

LTLA_Q1_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q1.ods'),
                           sheet = '12m_UTLA_GOR',
                           skip = 4) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '12m denominator', DTaPIPVHibHepB = '12m DTaP/IPV/Hib %', PCV2 = '12m PCV1%', MenB = '12m MenB%', Rota = '12m Rota%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>%   mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q1',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_Q2_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q2.ods'),
                           sheet = '12m_UTLA_GOR',
                           skip = 4) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '12m denominator', DTaPIPVHibHepB = '12m DTaP/IPV/Hib %', PCV2 = '12m PCV1%', MenB = '12m MenB%', Rota = '12m Rota%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>%   mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q2',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_Q3_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q3.ods'),
                           sheet = '12m_UTLA_GOR',
                           skip = 4) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '12m denominator', DTaPIPVHibHepB = '12m DTaP/IPV/Hib/HepB %', PCV2 = '12m PCV1%', MenB = '12m MenB%', Rota = '12m Rota%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, Rota),
               values_to = 'Proportion') %>% 
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q3',
         Age = '12 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_12_month_202223 <- LTLA_Q1_202223 %>% 
  bind_rows(LTLA_Q2_202223) %>% 
  bind_rows(LTLA_Q3_202223) 

rm(LTLA_Q1_202223, LTLA_Q2_202223, LTLA_Q3_202223)

LTLA_Q1_24_m_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q1.ods'),
                           sheet = '24m_UTLA_GOR',
                           skip = 4) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '24m denominator', DTaPIPVHibHepB = '24m DTaP/IPV/Hib%', PCV2 = '24m PCV Booster%', MenB = '24m MenB Booster%', `Hib/MenC` = '24m Hib/MenC%', MMR1 = '24m MMR1%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  mutate(DTaPIPVHibHepB = as.numeric(DTaPIPVHibHepB)) %>% 
  mutate(MenB = as.numeric(MenB)) %>% 
  mutate(PCV2 = as.numeric(PCV2)) %>% 
  mutate(MMR1 = as.numeric(MMR1)) %>% 
  mutate(`Hib/MenC` = as.numeric(`Hib/MenC`)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, MMR1, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>%   mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q1',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_Q2_24_m_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q2.ods'),
                           sheet = '24m_UTLA_GOR',
                           skip = 5) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '24m denominator', DTaPIPVHibHepB = '24m DTaP/IPV/Hib%', PCV2 = '24m PCV Booster%', MenB = '24m MenB Booster%', `Hib/MenC` = '24m Hib/MenC%', MMR1 = '24m MMR1%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  mutate(DTaPIPVHibHepB = as.numeric(DTaPIPVHibHepB)) %>% 
  mutate(MenB = as.numeric(MenB)) %>% 
  mutate(PCV2 = as.numeric(PCV2)) %>% 
  mutate(MMR1 = as.numeric(MMR1)) %>% 
  mutate(`Hib/MenC` = as.numeric(`Hib/MenC`)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, MMR1, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>%   mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q2',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_Q3_24_m_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q3.ods'),
                           sheet = '24m_UTLA_GOR',
                           skip = 5) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '24m denominator', DTaPIPVHibHepB = '24m DTaP/IPV/Hib/HepB3%', PCV2 = '24m PCV Booster%', MenB = '24m MenB Booster%', `Hib/MenC` = '24m Hib/MenC%', MMR1 = '24m MMR1%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  mutate(DTaPIPVHibHepB = as.numeric(DTaPIPVHibHepB)) %>% 
  mutate(MenB = as.numeric(MenB)) %>% 
  mutate(PCV2 = as.numeric(PCV2)) %>% 
  mutate(MMR1 = as.numeric(MMR1)) %>% 
  mutate(`Hib/MenC` = as.numeric(`Hib/MenC`)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, PCV2, MenB, MMR1, `Hib/MenC`),
               values_to = 'Proportion') %>%
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q3',
         Age = '24 months') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_24_month_202223 <- LTLA_Q1_24_m_202223 %>% 
  bind_rows(LTLA_Q2_24_m_202223) %>% 
  bind_rows(LTLA_Q3_24_m_202223) 

rm(LTLA_Q1_24_m_202223, LTLA_Q2_24_m_202223, LTLA_Q3_24_m_202223)

LTLA_Q1_5y_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q1.ods'),
                                sheet = '5y_UTLA_GOR',
                                skip = 4) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '5y denominator', DTaPIPVHibHepB = '5y DTaP/IPV/Hib%', `Hib/MenC` = '5y Hib/MenC%', MMR1 = '5y MMR1%', MMR2 = '5y MMR2%', DTaPIPV = '5y DTaPIPV%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  mutate(DTaPIPVHibHepB = as.numeric(DTaPIPVHibHepB)) %>% 
  mutate(DTaPIPV = as.numeric(DTaPIPV)) %>% 
  mutate(MMR1 = as.numeric(MMR1)) %>% 
  mutate(MMR2 = as.numeric(MMR2)) %>% 
  mutate(`Hib/MenC` = as.numeric(`Hib/MenC`)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, DTaPIPV, MMR1, MMR2, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>%   mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q1',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_Q2_5y_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q2.ods'),
                                sheet = '5y_UTLA_GOR',
                                skip = 5) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '5y denominator', DTaPIPVHibHepB = '5y DTaP/IPV/Hib%', `Hib/MenC` = '5y Hib/MenC%', MMR1 = '5y MMR1%', MMR2 = '5y MMR2%', DTaPIPV = '5y DTaPIPV%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  mutate(DTaPIPVHibHepB = as.numeric(DTaPIPVHibHepB)) %>% 
  mutate(DTaPIPV = as.numeric(DTaPIPV)) %>% 
  mutate(MMR1 = as.numeric(MMR1)) %>% 
  mutate(MMR2 = as.numeric(MMR2)) %>% 
  mutate(`Hib/MenC` = as.numeric(`Hib/MenC`)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, DTaPIPV, MMR1, MMR2, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>%   mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q2',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_Q3_5y_202223 <- read_ods(paste0(data_directory, '/Child_immunisation_LA_202223_Q3.ods'),
                                sheet = '5y_UTLA_GOR',
                                skip = 5) %>% 
  filter(`UTLA name` == 'West Sussex') %>% 
  select(Area = 'UTLA name', Denominator = '5y denominator', DTaPIPVHibHepB = '5y DTaP/IPV/Hib/HepB3%', `Hib/MenC` = '5y Hib/MenC%', MMR1 = '5y MMR1%', MMR2 = '5y MMR2%', DTaPIPV = '5y DTaPIPV%') %>% 
  mutate(Denominator = as.numeric(Denominator)) %>% 
  mutate(DTaPIPVHibHepB = as.numeric(DTaPIPVHibHepB)) %>% 
  mutate(DTaPIPV = as.numeric(DTaPIPV)) %>% 
  mutate(MMR1 = as.numeric(MMR1)) %>% 
  mutate(MMR2 = as.numeric(MMR2)) %>% 
  mutate(`Hib/MenC` = as.numeric(`Hib/MenC`)) %>% 
  pivot_longer(names_to = 'Item',
               cols = c(DTaPIPVHibHepB, DTaPIPV, MMR1, MMR2, `Hib/MenC`),
               values_to = 'Proportion') %>% 
  mutate(Benchmark = factor(ifelse(Proportion < 90, 'Low (<90%)', ifelse(Proportion < 95, 'Medium (90-95%)', 'High (95%+)')), levels = c('Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'))) %>% 
  mutate(Proportion_2 = paste0(round(as.numeric(Proportion), 1), '%')) %>%
  mutate(Year = '2022/23 Q3',
         Age = '5 years') %>% 
  left_join(Vaccination_terms_df, by = 'Item') 

LTLA_5_year_202223 <- LTLA_Q1_5y_202223 %>% 
  bind_rows(LTLA_Q2_5y_202223) %>% 
  bind_rows(LTLA_Q3_5y_202223) 

rm(LTLA_Q1_5y_202223, LTLA_Q2_5y_202223, LTLA_Q3_5y_202223)

LA_quarterly_table_values <- LTLA_12_month_202223 %>% 
  mutate(Proportion = as.numeric(Proportion)) %>% 
  bind_rows(LTLA_24_month_202223) %>% 
  bind_rows(LTLA_5_year_202223) %>% 
  select(Age, Year, Item, Proportion = Proportion_2) %>% 
  pivot_wider(names_from = 'Year',
              values_from = 'Proportion')

LA_quarterly_table_labels <- LTLA_12_month_202223 %>% 
  mutate(Proportion = as.numeric(Proportion)) %>% 
  bind_rows(LTLA_24_month_202223) %>% 
  bind_rows(LTLA_5_year_202223) %>% 
  mutate(Numerator = Denominator * (as.numeric(Proportion) / 100)) %>% 
  select(Age, Year, Item, Numerator, Denominator, Proportion = Proportion_2) %>%
  mutate(Proportion = ifelse(is.na(Proportion), '-', paste0(Proportion, ' (', format(Numerator, big.mark = ','),'/', format(Denominator, big.mark = ','),')'))) %>%
  select(!c(Numerator, Denominator)) %>% 
  pivot_wider(names_from = 'Year',
              values_from = 'Proportion') %>% 
  mutate()

LA_quarterly_table_benchmark_values <-LTLA_12_month_202223 %>% 
  mutate(Proportion = as.numeric(Proportion)) %>% 
  bind_rows(LTLA_24_month_202223) %>% 
  bind_rows(LTLA_5_year_202223) %>% 
  select(Age, Year, Item, Benchmark) %>% 
  mutate(Benchmark = ifelse(is.na(Benchmark), '-', as.character(Benchmark))) %>% 
  pivot_wider(names_from = 'Year',
              values_from = 'Benchmark',
              names_prefix = 'Benchmark')

LA_quarterly_table_labels %>% 
  left_join(LA_quarterly_table_benchmark_values, by = c('Age', 'Item')) %>% 
  toJSON() %>% 
  write_lines(paste0(output_directory, '/LTLA_quarterly_table.json'))

# GP ####

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

# download.file('https://files.digital.nhs.uk/assets/ods/current/epraccur.zip',
#               paste0(data_directory, '/epraccur.zip'),
#               mode = 'wb')
# 
# unzip(paste0(data_directory, '/epraccur.zip'),
#        exdir = data_directory)

gp_mapping <- read_csv(paste0(data_directory, '/epraccur.csv'),
                       col_names = FALSE) %>% 
  select(ODS_Code = X1, ODS_Name = X2, Postcode = X10) %>% 
  mutate(ODS_Name = gsub('Woodlands&Clerklands', 'Woodlands & Clerklands', gsub('\\(Aic\\)', '\\(AIC\\)', gsub('\\(Acf\\)', '\\(ACF\\)', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ',  str_to_title(ODS_Name))))))))

# Geolocating practices ####
gp_mapping <- gp_mapping %>% 
  filter(ODS_Code  %in% GP_annual_df$ODS_Code)

#setdiff(GP_annual_df$ODS_Code, gp_mapping$ODS_Code)
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

GP_annual_df_attempt_one %>% 
  filter(ODS_Code != 'V81999') %>% 
  toJSON() %>% 
  write_lines(paste0(output_directory, '/GP_immunisations.json'))

areas <- c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing')

# Load LTLA boundaries #
# lad_boundaries_clipped_sf <- st_read('https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_May_2022_UK_BFC_V3_2022/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson') %>% 
#   filter(LAD22NM %in% c('Chichester')) 
# 
# lad_boundaries_full_extent_sf <- st_read('https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_May_2022_UK_BFE_V3_2022/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson') %>% 
#   filter(LAD22NM %in% areas & LAD22NM != 'Chichester')
# 
# lad_boundaries_sf <- rbind(lad_boundaries_clipped_sf, lad_boundaries_full_extent_sf)
# lad_boundaries_spdf <- as_Spatial(lad_boundaries_sf, IDs = lad_boundaries_sf$LAD22NM)
# 
# geojson_write(ms_simplify(geojson_json(lad_boundaries_spdf), keep = 0.3), file = paste0(output_directory, '/west_sussex_LTLAs.geojson'))

# Seasonal flu school age ####
# https://www.gov.uk/government/statistics/seasonal-influenza-vaccine-uptake-in-children-of-school-age-monthly-data-2022-to-2023

if(file.exists(paste0(data_directory, '/Child_immunisation_school_flu_201819.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/780385/Child_Flu_Programme_Jan_2019_Tables_PrimarySchoolAge.ods',
                paste0(data_directory, '/Child_immunisation_school_flu_201819.ods'),
                mode = 'wb')
}

if(file.exists(paste0(data_directory, '/Child_immunisation_school_flu_201920.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/867127/Child_Flu_Programme_January_2020_Tables_PrimarySchoolAge_FORMATTED.ods',
                paste0(data_directory, '/Child_immunisation_school_flu_201920.ods'),
                mode = 'wb')
}

if(file.exists(paste0(data_directory, '/Child_immunisation_school_flu_202021.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/964663/Child_Flu_Programme_January_2021_Tables_PrimarySchoolAge_final.ods',
                paste0(data_directory, '/Child_immunisation_school_flu_202021.ods'),
                mode = 'wb')
}

if(file.exists(paste0(data_directory, '/Child_immunisation_school_flu_202122.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1056997/Seasonal_influenza_vaccine_uptake_childhood_January_2122.ods',
                paste0(data_directory, '/Child_immunisation_school_flu_202122.ods'),
                mode = 'wb')
}

if(file.exists(paste0(data_directory, '/Child_immunisation_school_flu_202223.ods')) != TRUE){
  download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1137931/UKHSA_Seasonal_Childhood_Flu_Vaccine_Uptake_January-2023.ods',
                paste0(data_directory, '/Child_immunisation_school_flu_202223.ods'),
                mode = 'wb')
}

# 2018/19 school age flu ####

raw_flu_df <- read_csv(paste0(data_directory,'/flu_primary_uptake.csv'),
         col_types = cols(Numerator = col_double(), Denominator = col_double())) %>% 
  filter(Area %in% c('West Sussex', 'Total')) %>% 
  mutate(Proportion = Numerator / Denominator) %>% 
  mutate(Label = paste0(round((Proportion * 100),1), '% (', format(Numerator, big.mark = ',', trim = TRUE), '/', format(Denominator, big.mark = ',', trim = TRUE), ')')) %>% 
  mutate(Area = ifelse(Area == 'Total','England', Area))

# There is primary school coverage
primary_school_df <- raw_flu_df %>% 
  filter(Year %in% c('September 2019 to January 2020', 'September 2020 to January 2021', 'September 2021 to January 2022', 'September 2022 to January 2023')) %>% 
  filter(`Year group` %in% c('Reception', 'Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5', 'Year 6')) %>% 
  group_by(Area, Year) %>% 
  summarise(Numerator = sum(Numerator, na.rm = TRUE),
            Denominator = sum(Denominator, na.rm = TRUE)) %>% 
  mutate(Proportion = Numerator / Denominator) %>% 
  mutate(Label = paste0(round((Proportion * 100),1), '% (', format(Numerator, big.mark = ',', trim = TRUE), '/', format(Denominator, big.mark = ',', trim = TRUE), ')'))  %>% 
  ungroup() %>% 
  mutate(phe_proportion(., Numerator, Denominator))

eng_df <- primary_school_df %>% 
  filter(Area == 'England') %>% 
  select(Year, Eng_LCL = lowercl, Eng_UCL = uppercl)

primary_school_df %>% 
  left_join(eng_df, by = 'Year') %>% 
  mutate(Significance = ifelse(Area == 'England', 'England', ifelse(lowercl > Eng_UCL, 'Higher', ifelse(uppercl < Eng_LCL, 'Lower', 'Similar')))) %>% 
  select(Area, Year, Numerator, Denominator, Proportion, Lower_CL = lowercl, Upper_CL = uppercl, Significance) %>% 
  mutate(Year_short = ifelse(Year == 'September 2019 to January 2020', '2019/20', ifelse(Year == 'September 2020 to January 2021', '2020/21',ifelse(Year == 'September 2021 to January 2022', '2021/22',ifelse(Year == 'September 2022 to January 2023', '2022/23', Year))))) %>%
  toJSON() %>% 
  write_lines(paste0(output_directory, '/primary_school_flu_immunisations.json'))

primary_school_df %>% 
  select(Area, Year, Label) %>% 
  pivot_wider(names_from = 'Year',
              values_from = 'Label') %>% 
  mutate(`September 2019 to January 2020` = replace_na(`September 2019 to January 2020`, '-')) %>% 
  mutate(`September 2020 to January 2021` = replace_na(`September 2020 to January 2021`, '-')) %>% 
  mutate(`September 2021 to January 2022` = replace_na(`September 2021 to January 2022`, '-')) %>% 
  mutate(`September 2022 to January 2023` = replace_na(`September 2022 to January 2023`, '-')) 

PHEindicatormethods::phe_proportion(primary_school_df, x = Numerator, n = Denominator)[4]

primary_school_df %>% 

  

flu_primary_uptake <- read_csv(paste0(data_directory,'/flu_primary_uptake.csv'),
                               col_types = cols(Numerator = col_double(), Denominator = col_double())) %>% 
  filter(Area == 'West Sussex') %>% 
  mutate(Proportion = Numerator / Denominator) %>% 
  mutate(Label = paste0(round((Proportion * 100),1), '% (', format(Numerator, big.mark = ',', trim = TRUE), '/', format(Denominator, big.mark = ',', trim = TRUE), ')')) %>%
  select(Year, `Year group`, Label) %>% 
  pivot_wider(names_from = 'Year',
              values_from = 'Label') %>% 
  mutate(`September 2018 to January 2019` = replace_na(`September 2018 to January 2019`, '-')) %>% 
  mutate(`September 2019 to January 2020` = replace_na(`September 2019 to January 2020`, '-')) %>% 
  mutate(`September 2020 to January 2021` = replace_na(`September 2020 to January 2021`, '-')) %>% 
  mutate(`September 2021 to January 2022` = replace_na(`September 2021 to January 2022`, '-')) %>% 
  mutate(`September 2022 to January 2023` = replace_na(`September 2022 to January 2023`, '-')) 



flu_primary_uptake %>% 
  toJSON() %>% 
  write_lines(paste0(output_directory, '/school_flu_immunisations.json'))

# Data is presented for secondary school-aged children for the first time in this month’s data. This season vaccination of younger children and those in a-risk groups were prioritised first. Vaccination in secondary schools and catch-up of all other eligible children will continue throughout the new year. Note that secondary school-aged children in clinical risk groups have been eligible since 1 September 2022. 

# HPV school age
# https://www.gov.uk/government/statistics/human-papillomavirus-hpv-vaccine-coverage-estimates-in-england-2021-to-2022




# Outputs

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
