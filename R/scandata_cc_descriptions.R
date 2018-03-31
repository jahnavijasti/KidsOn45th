# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
cat("\014")
rm(list=ls())
source('my_library.R')

# Declare the target character and target column for quote character
# replacement.
target_char <- get_substitute_quote_char()
target_column <- 2

# Read the data.
file_name <- 'cc_descriptions'
cat(paste('Cleaning: \'', build_scandata_input_file_path(file_name), '\'...',
          sep = ''))
cc_descriptions <- read_scandata_csv(file_name, my_quote = target_char)

# Create a vector of column names. Set the column names in the cc_descriptions.
my_colnames <- c(
  'id',
  'description',
  'code'
)

# Set column names in the cc_descriptions data. Substitute quote characters in
# the description field.
colnames(cc_descriptions) <- my_colnames
cc_descriptions[,target_column] <- gsub(get_quote_char(),
                                        target_char,
                                        cc_descriptions[,target_column])

# Write the csv file.
write_scandata_csv(cc_descriptions, file_name)

# Clean up...
rm(my_colnames)
rm(cc_descriptions)
rm(file_name)
rm(target_column)
rm(target_char)
