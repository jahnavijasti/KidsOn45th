# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Declare the target character and target column for quote character
# replacement.
target_char <- get_substitute_quote_char()
target_column <- 4

# Read the data.
file_name <- 'pp_categories'
cat(paste('Cleaning: \'', build_product_input_file_path(file_name), '\'...',
          sep = ''))
pp_categories <- read_product_csv(file_name, my_quote = target_char)

# Create a vector of column names. Set the column names in the users.
my_colnames <- c(
  'id',
  'index',
  'cat_code',
  'cat_description'
  )

# Set column names in the pp_categories data.
colnames(pp_categories) <- my_colnames

# Substitute quote characters in the description field.
pp_categories[,target_column] <- gsub(get_quote_char(),
                                      target_char,
                                      pp_categories[,target_column])

# Write the csv file.
write_product_csv(pp_categories, file_name)

# Clean up...
rm(my_colnames)
rm(pp_categories)
rm(file_name)
rm(target_column)
rm(target_char)
