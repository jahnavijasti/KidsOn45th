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
file_name <- 'cc_con_check_in'
cat(paste('Cleaning: \'', build_scandata_input_file_path(file_name), '\'...',
          sep = ''))
cc_con_check_in <- read_scandata_csv(file_name, my_quote = target_char)

# Create the POSIX date fields.
date_fields <- c('in', 'out')
date_fields_posix <- build_posix_field_name(date_fields)

# Create a vector of column names.
my_colnames <- c('index',
                 'customer_no',
                 'scancode',
                 'description',
                 date_fields[1],
                 date_fields[2],
                 'clerk_id_in',
                 'verified',
                 'clerk_id_out',
                 'void')

# Create a vector of enhanced column names.
my_enhanced_colnames <- c(my_colnames[1],
                          my_colnames[2],
                          my_colnames[3],
                          my_colnames[4],
                          my_colnames[5],
                          date_fields_posix[1],
                          my_colnames[6],
                          date_fields_posix[2],
                          my_colnames[7],
                          my_colnames[8],
                          my_colnames[9],
                          my_colnames[10])

# Set column names in the cc_con_check_in data.
colnames(cc_con_check_in) <- my_colnames

# Create the POSIX fields in the data.
cc_con_check_in[,date_fields_posix] <- sapply(seq(1:length(date_fields)),
                                              FUN = function(x) {
                                                
  create_timestamp(cc_con_check_in[,date_fields[x]])
})

# Set column names in the cc_con_check_in data. Substitute quote characters in
# the description field.
colnames(cc_con_check_in) <- my_colnames
cc_con_check_in[,target_column] <- gsub(get_quote_char(),
                                        target_char,
                                        cc_con_check_in[,target_column])

# Write the csv file.
write_scandata_csv(cc_con_check_in, file_name)

# Clean up...
rm(my_enhanced_colnames)
rm(my_colnames)
rm(date_fields_posix)
rm(date_fields)
rm(cc_con_check_in)
rm(file_name)
rm(target_column)
rm(target_char)
