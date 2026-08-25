### Session 5: Birth register data #############################################

### Loading packages ###########################################################

    # ggplot, dplyr
    library(tidyverse)
    # For loading large data
    library(data.table)
    # Downloading data
    library(httr)


### Loading data (option 1) ####################################################

  # Data available from:
  # https://www.nber.org/data/vital-statistics-natality-data.html
  
  # Data for 2023
  url <- "https://data.nber.org/nvss/natality/csv/2023/natality2023us.csv"
  # Documentation:
  # https://data.nber.org/nvss/natality/inputs/pdf/2023/UserGuide2023.pdf
  
  # Download data manually with the link
  
  # Load data, takes a while!
  dat <- fread(file="U:/Data/natality2023us.csv",
               select=c("restatus",
                        "mager","fagecomb",
                        "dbwt"))

  
### Loading data (option 2) ####################################################  
    
  # Download, the file is around 2GB, might take some time
  file1 <- "U:/Data/natality2023us.csv"
  if(!file.exists(file1)) {
    GET(url,write_disk(file1, overwrite = TRUE), progress() )
  }
  
  # Load & save downloaded file
  file2 <- "U:/Data/usregister.Rdata"
  if(!file.exists(file2)) {
    dat <- fread(file1,select=c("restatus",
                                "mager","fagecomb",
                                "dbwt"))
    save(dat,file=file2)
  }
  
  # Load
  load(file2)

  
### Quick look at data #########################################################
  
  head(dat)
  summary(dat)
  dim(dat)
  

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

  # Generate key outcome: low birth weight
  dat <- dat |> mutate(low=ifelse(weight<2500,1,0))
  
  # Generate further variables: difference and interactions squared
  dat <- dat |> mutate(i_age=mage * fage,
                       mage2=mage^2,
                       fage2=fage^2,
                       i_age2=i_age^2)

  
### Regression estimates #######################################################
  
  # Estimate linear model
  fit1 <- lm(formula=low~mage+fage,
             data=dat)
  
  # Estimate logistic regression
  fit2 <- glm(low~mage+fage,
              data=dat,
              family = binomial(link = "logit"))
  
  # Estimate logistic regression
  fit3 <- glm(low~mage+mage2+fage2+fage+i_age+i_age2,
             data=dat,
             family = binomial(link = "logit"))

  # Look at results
  summary(fit1)
  summary(fit2)
  summary(fit3)
  
  # Compare models
  AIC(fit2)
  AIC(fit3)


### Predict ####################################################################  

  # Prediction data
  maternal <- 15:49
  paternal <- rep(30,length(maternal))
  predictdata <- data.frame(mage=maternal,
                            fage=paternal)
  
  predictdata <- predictdata |> mutate(i_age=mage * fage,
                                       mage2=mage^2,
                                       fage2=fage^2,
                                       i_age2=i_age^2)
  
  # Predict probability of low birth weight
  predictdata$model1 <- fit1 |> predict(newdata=predictdata)
  
  predictdata$model2 <- fit2 |> predict(newdata=predictdata,
                                        type="response")
  
  predictdata$model3 <- fit3 |> predict(newdata=predictdata,
                                        type="response")
  
  # Reshape for plotting
  predictdata <- predictdata |> pivot_longer(cols=c(model1,model2,model3))
  
  
### Plot #######################################################################
  
  predictdata |> ggplot(aes(x=mage,y=value,col=name)) +
                  geom_line()

  
### Nicer plot #################################################################
  
  predictdata$name <- predictdata$name |> recode(model1="OLS",
                                                 model2="Logistic",
                                                 model3="Logistic, non-linear")
  
  cols <- c("#2ca25f",
            "#f0027f",
            "#beaed4")
  
  predictdata |> ggplot(aes(x=mage,y=value,col=name)) +
                 geom_line(linewidth=1) +
                 labs(x="Maternal age",
                      y="Risk of low birth weight")+
                 scale_colour_manual(values = cols)+
                 theme_bw()
  