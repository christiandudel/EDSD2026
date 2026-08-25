### Solutions for the exercises for session 1 ##################################

### Exercise 3 ####

  1234+1234
  151/7
  13^4 - 12^3 + 5
  20/0
  # Note that the last result (20/0) is 'Inf' which stands for
  # infinity. Mathematically, 20 divided by 0 is not defined and
  # one could expect an error message. However, division by zero
  # returns infinity in many programming language. If you run
  # some long and complicated calculations in R and end up with 'Inf'
  # as a result, then division by zero is a good candidate to check
  # when trying to find the error.
  

### Exercise 4 ####
  
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