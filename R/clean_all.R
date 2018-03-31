# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
cat("\014")
rm(list=ls())
cat(paste('The working directory is: \'', getwd()), '\'...', sep = '')
source('my_library.R')

# Source all the database specific cleaning files.
cat('Cleaning all the database tables...\n')
source('custdata.R')
source('product.R')
source('scandata.R')
source('sales.R')
