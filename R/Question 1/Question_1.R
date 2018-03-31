# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg
#
# This script attempts to answer the quesetion: What has the effect of
# inflation been during the time the data was recorded?

# Clear the console, and the environment.
cat("\014")
rm(list=ls())

# Source the library.  Copy the inflation data.
cat(paste('The working directory is: \'', getwd()), '\'...', sep = '')
source('my_library.R')
local_inflation <- inflation_data

# Normalize the CPI indices from 1.0.  Get the last u-index.
normalizer <- 100.
local_inflation$u_index <- local_inflation$u_index / normalizer
local_inflation$w_index <- local_inflation$w_index / normalizer
last_u_index <- local_inflation[nrow(local_inflation),]$u_index

# Create a prediction function. Plot CPI-U against timestamp. Don't put in
# default tickmarks for the X axis.
prediction_function <- splinefun(x = local_inflation$timestamp, y = local_inflation$u_index)
plot(u_index ~ timestamp,
     data = local_inflation,
     xaxt = 'n',
     xlab = 'Date',
     ylab = 'Seattle CPI (All Urban Consumers)',
     las  = 1,
     main = 'Seattle Consumer Price Index, CPI (1982 - 1984 = 100)')

# Create custom tickmarks for the X axis.
my_labels <- c('Aug 1998',
               'Oct 2001',
               'Dec 2004',
               'Feb 2008',
               'Apr 2011',
               'Jun 2014',
               'Aug 2017')
axis(1, at=seq(9.0e+08, 1.5e+09, 1.0e+08), labels = my_labels)

# Put in a colored line along the CPI prediction function.
x <- seq(8.8e+08, 1.5e+09, 1.0e+06)
y <- prediction_function(x)
lines(x, y, col='red')

# A message above the plot.
text(1.0e+09, 2.5, 'The CPI function is traced in
     red between the points.  The function
     is continuous, and so is its
     1st derivative.', col = 'red')

# A message below the plot.
text(1.3e+09, 2, 'To normalize a sale to
     June, 2017, multiply the sale
     amount by the CPI function
     value for June 2017, then divide by
     the spline function value for the
     date of the sale.',
     col = 'blue')

# Clean up...
rm(x)
rm(y)
rm(my_labels)
rm(prediction_function)
rm(last_u_index)
rm(local_inflation)
rm(normalizer)
