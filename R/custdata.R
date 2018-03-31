# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# cat(paste('The working directory is: \'', getwd()), '\'...', sep = '')
# source('my_library.R')

# Conditionally clean all the sales files.
cat('Checking to make sure clean versions of all custdata files already exist...\n')
conditionally_execute_custdata_script('users')
conditionally_execute_custdata_script('sales')
conditionally_execute_custdata_script('maillist_profiles')
conditionally_execute_custdata_script('hold')
conditionally_execute_custdata_script('customers_finance')
conditionally_execute_custdata_script('customers')
conditionally_execute_custdata_script('cnwa')
