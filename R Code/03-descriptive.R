### Session 2: Descriptive statistics ##########################################

### Assignment operator ########################################################

  x <- 5
  x
  y <- 13 # Hotkeys "ALT" + "-" for "<-" 
  y
  x+y # Does not change x or y
  x
  z <- x+y
  z
  sqrt(y)
  x==5
  x==3
  x>y
  
  x+x
  somewhatlongname <- 5
  x.1_12 <- 3  
  
  a<-1
  a< -1
  
  text <- "Hello world!"
  text 
  
  x # Should still be 5
  x <- 1 # x gets replaced without warning
  x

  
### Example data ###############################################################
  
  # Source: 
  # https://www.diw.de/documents/dokumentenarchiv/17/diw_01.c.412698.de/soep_lebensz_en.zip
  # https://www.diw.de/en/diw_02.c.222838.en/soep_in_the_college_classroom.html
  # Download and unzip first
  # Data comes in Stata's dta format
  
  # Load foreign package
  library(foreign)
  
  # Load data
  soep <- read.dta(file="U:/soep_lebensz_en.dta",
                   convert.factors=F)
  
  
### Viewing data ###############################################################  
  
  # View data in console
  soep
  
  # Class of object
  class(soep) 
  
  # Overview of data
  head(soep)
  tail(soep)
  View(soep) # Or click in R Studio under "Environment" tab
  
  # Variable names
  names(soep)
  
  # Size of data set
  dim(soep)
  
  
### View parts of data #########################################################
  
  # Variable names
  soep$id # Vector
  soep["id"] # Data frame  
  
  
### Restricting data ###########################################################
  
  # Restrict data to last year
  soep <- subset(x=soep,
                 subset=year==2004)
  
  
### Descriptive statistics #####################################################
  
  # Mean
  mean(soep$satisf_org)
  mean(soep$no_kids)
  mean(soep$no_kids,na.rm=T)
  
  # Median
  median(soep$satisf_org)
  median(soep$no_kids,na.rm=T)
  
  # Standard deviation
  sd(soep$satisf_org)
  sd(soep$no_kids,na.rm=T)
  
  
  # Variance
  var(soep$satisf_org)
  var(soep$no_kids,na.rm=T)
  
  # Quantiles
  quantile(soep$satisf_org)
  quantile(soep$no_kids,na.rm=T)
  
  # Summary
  summary(soep$satisf_org)
  summary(soep$no_kids)
  summary(soep)
  
  
### Tables #####################################################################
  
  # Simple tables 
  table(soep$no_kids)
  table(soep$sex)
  
  # Cross tabulations
  table(soep$no_kids,soep$sex)
  table(soep$no_kids,soep$sex,dnn=c("Kids","Sex"))
  
  # Tables can be stored in objects
  tab <- table(soep$no_kids,soep$sex,dnn=c("Kids","Sex"))
  
  # Proportions
  prop.table(tab)
  prop.table(tab,1)
  prop.table(tab,2)
  
  
### Condiitonal statistics #####################################################
  
  by(data=soep$satisf_org,
     INDICES=soep$no_kids,
     FUN=mean)
  
  
### Reading another data type: CSV #############################################

  # Data source and description:
  # https://www.google.com/covid19/mobility/
  
  # Load data 
  covid <- read.csv("D:/Global_Mobility_Report.csv")
  
  # Restrict data to Germany
  covid <- subset(x=covid,
                  subset=country_region=="Germany")
  
  # Restrict data further to Meck-Pomm (where the MPIDR is)
  covid <- subset(x=covid,
                  subset=sub_region_1=="Mecklenburg-Vorpommern")
  
  # Preview of next session: Plotting (here: base R)
  covid$date <- as.Date(x=covid$date,
                        format="%Y-%m-%d")
  plot(x=covid$date,
       y=covid$transit_stations_percent_change_from_baseline,
       xlab="Date",
       ylab="Percentage change to baseline",
       panel.first=grid(),
       main="Public transportation use",
       type="l")
