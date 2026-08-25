### Solutions for session 7

  # Function
  mad <- function(x,na.rm=F) {

    average <- mean(x,na.rm=na.rm)

    result <- abs(x-average)
    result <- mean(result,na.rm=na.rm)

    return(result)

  }

  # Test cases
  test1 <- 1:10
  test2 <- rnorm(1000)
  test3 <- c(2,5,13,NA,2)

  # Results
  mad(test1)
  mad(test2)
  mad(test3)
  mad(test3,na.rm=T)
