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
cat('Checking to make sure clean versions of all scandata files already exist...\n')
conditionally_execute_scandata_script('cc_descriptions')
conditionally_execute_scandata_script('cc_con_check_in')
