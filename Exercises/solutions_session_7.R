### Birth register data ########################################################

### Loading packages ###########################################################

  # ggplot, dplyr
  library(tidyverse)
  # For loading large data
  library(data.table)
  # Downloading data
  library(httr)


### Loading data ###############################################################

  # Data available from:
  # https://www.nber.org/data/vital-statistics-natality-data.html
  
  # Data for 2023
  url <- "https://data.nber.org/nvss/natality/csv/2023/natality2023us.csv"
  # Documentation:
  # https://data.nber.org/nvss/natality/inputs/pdf/2023/UserGuide2023.pdf

  # Download, the file is around 2GB, might take some time
  file1 <- "U:/Data/nat2023us.csv"
  if(!file.exists(file1)) {
    GET(url,write_disk(file1, overwrite = TRUE), progress() )
  }
  
  # Load & save downloaded file
  file2 <- "U:/Data/usregister.Rdata"
  if(!file.exists(file2)) {
    dat <- fread(file1,select=c("restatus",
                                "mager","fagecomb",
                                "dbwt",
                                "cig_1","cig_2","cig_3"))
    save(dat,file=file2)
  }
  
  # Load
  load(file2)


### Editing data ###############################################################

  # Select & rename variables
  dat <- dat |> rename(mage=mager, # mother's age
                       fage=fagecomb, # father's age
                       weight=dbwt, # birth weight in grams
                       resident=restatus) # residency status

  # Drop if not resident
  dat$resident |> table()
  dat <- dat |> filter(resident!=4)
  
  # Drop missing age of father
  dat$fage |> summary()
  dat <- dat |> filter(fage!=99)
  
  # Drop missing birth weight
  dat$weight |> summary()
  dat <- dat |> filter(weight!=9999)
  
  # Restrict age range
  summary(dat)
  dat <- dat |> filter(mage%in%15:49 & fage%in%15:59)
  

### Generate variables #########################################################

  # Smoking
  summary(dat)
  dat <- dat %>% mutate( dcig1 = ifelse(cig_1%in%1:98,1,0),
                         dcig2 = ifelse(cig_2%in%1:98,1,0),
                         dcig3 = ifelse(cig_3%in%1:98,1,0),
                         dcig  = dcig1+dcig2+dcig3,
                         dcig  = ifelse(dcig>0,1,0),
                         dcig  = ifelse(cig_1==99,NA,dcig),
                         dcig  = ifelse(cig_2==99,NA,dcig),
                         dcig  = ifelse(cig_3==99,NA,dcig))
  
  # Generate further variables: difference and interactions squared
  dat <- dat |> mutate(i_age=mage * fage,
                       mage2=mage^2,
                       fage2=fage^2,
                       i_age2=i_age^2)


### Regression estimates #######################################################

  # Estimate linear model
  fit1 <- lm(formula=weight~mage+mage2+fage2+fage+i_age+i_age2+dcig,
             data=dat)
  
  # Look at results
  summary(fit1)
  coef(fit1)["dcig"]
