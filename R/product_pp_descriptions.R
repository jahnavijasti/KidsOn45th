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
target_column <- 2

# Read the data.
file_name <- 'pp_descriptions'
cat(paste('Cleaning: \'', build_product_input_file_path(file_name), '\'...',
          sep = ''))
pp_descriptions <- read_product_csv(file_name, my_quote = target_char)

# Create a vector of column names. Set the column names in the users.
my_colnames <- c(
  'id',
  'description',
  'code'
  )

# Set column names in the pp_descriptions data.
colnames(pp_descriptions) <- my_colnames

# Substitute quote characters in the description field.
pp_descriptions[,target_column] <- gsub(get_quote_char(),
                                   target_char,
                                   pp_descriptions[,target_column])

# Write the csv file.
write_product_csv(pp_descriptions, file_name)

# Clean up...
rm(my_colnames)
rm(pp_descriptions)
rm(file_name)
rm(target_column)
rm(target_char)
