### Solutions for the exercises for session 2 ##################################

### Exercise 1 ####

  x <- sqrt(2)
  y <- x^2
  y==2
  # R tells us that 2 and y are NOT equal, although they should be.
  # The reason for this is limited accuracy of computers. The square root
  # of 2 is an irrational number, with infintely many, non-repeating 
  # decimal places. This means that you cannot write it down, and computers
  # cannot store it. Because of this, the result of the computation sqrt(2)
  # above is not exactly equal to the real square root of two. 
  # Google 'floating point arithmetics' if you find this interesting.

### Exercise 2 ####

  # Load data
  file <- "https://raw.githubusercontent.com/kosukeimai/qss/master/CAUSALITY/resume.csv"
  experiment <- read.csv(file)
  
  # Look inside
  head(experiment)
  
  # Create table
  tab <- table(experiment$race,
               experiment$call,
               dnn=c("Race","Call"))
  
  # Turn into relative proportions (row-wise)
  prop.table(tab,1)
  
