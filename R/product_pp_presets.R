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
target_column <- 7

# Read the data.
file_name <- 'pp_presets'
cat(paste('Cleaning: \'', build_product_input_file_path(file_name), '\'...',
          sep = ''))
pp_presets <- read_product_csv(file_name, my_quote = target_char)

# Declare the currency field.
currency_fields <- c('listprice')

# Create a vector of column names. Set the column names in the users.
my_colnames <- c(
  'index',
  'preset_name',
  'type_code',
  'condition_code',
  'size_code',
  'notes',
  'p_description',
  'category',
  currency_fields[1]
)

# Set column names in the pp_presets data.
colnames(pp_presets) <- my_colnames

# Round the currency fields.
pp_presets[,currency_fields] <- sapply(seq(1:length(currency_fields)),
                                       FUN = function(x) {
                                         
                                         round_currency(pp_presets[,currency_fields[x]])
                                        })

# Substitute quote characters in the description field.
pp_presets[,target_column] <- gsub(get_quote_char(),
                                   target_char,
                                   pp_presets[,target_column])

# Write the csv file.
write_product_csv(pp_presets, file_name)

# Clean up...
rm(currency_fields)
rm(my_colnames)
rm(pp_presets)
rm(file_name)
rm(target_column)
rm(target_char)
