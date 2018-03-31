# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# cat(paste('The working directory is: \'', getwd()), '\'...', sep = '')
# source('my_library.R')

# Conditionally clean all the product files.
cat('Checking to make sure clean versions of all product files already exist...\n')
conditionally_execute_product_script('productsbu04older')
conditionally_execute_product_script('pp_presets')
conditionally_execute_product_script('pp_descriptions')
conditionally_execute_product_script('pp_categories')
conditionally_execute_product_script('pp_active_products')
conditionally_execute_product_script('active_back_up_3600')
