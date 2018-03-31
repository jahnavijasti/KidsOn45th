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
cat('Checking to make sure clean versions of all sales files already exist...\n')
conditionally_execute_sales_script('transaction_types')
conditionally_execute_sales_script('state_sales_tax')
conditionally_execute_sales_script('sales')
conditionally_execute_sales_script('pp_soldprod2008')
conditionally_execute_sales_script('pp_sold_products')
conditionally_execute_sales_script('pp_returned_products')
conditionally_execute_sales_script('gift_cert')
