# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'users'
cat(paste('Cleaning: \'', build_custdata_input_file_path(file_name), '\'...',
          sep = ''))
users <- read_custdata_csv(file_name)

# Create a vector of column names. Set the column names in the users.
my_colnames <- c(
  'user_index',
  'user_code',
  'user_name_first',
  'user_name_list'
)

# Set column names in the users data, and write the csv file.
colnames(users) <- my_colnames
write_custdata_csv(users, file_name)

# Clean up...
rm(my_colnames)
rm(users)
rm(file_name)
