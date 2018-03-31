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
target_column <- 8

# Read the data.
file_name <- 'productsbu04older'
cat(paste('Cleaning: \'', build_product_input_file_path(file_name), '\'...',
          sep = ''))
productsbu04older <- read_product_csv(file_name, my_quote = target_char)

# Create the POSIX date fields.
date_fields <- c('date_in')
date_fields_posix <- build_posix_field_name(date_fields)

# Create a vector of column names.
my_colnames <- c('category',
                 date_fields[1],
                 'clerk_id_in',
                 'type_code',
                 'product_scancode',
                 'customer_no_sold',
                 'p_description')

# Create a vector of enhanced column names.
my_enhanced_colnames <- c(my_colnames[1],
                          my_colnames[2],
                          date_fields_posix[1],
                          my_colnames[3],
                          my_colnames[4],
                          my_colnames[5],
                          my_colnames[6],
                          my_colnames[7])

# Set column names in the productsbu04older data.
colnames(productsbu04older) <- my_colnames

# Create the POSIX fields in the data.
productsbu04older[,date_fields_posix] <- sapply(seq(1:length(date_fields)),
                                                FUN = function(x) {
                                                
  create_timestamp(productsbu04older[,date_fields[x]])
})

# Substitute quote characters in the description field.
productsbu04older[,target_column] <- gsub(get_quote_char(),
                                          target_char,
                                          productsbu04older[,target_column])

# Reorder the productsbu04older data and write the csv file.
write_product_csv(productsbu04older[,my_enhanced_colnames], file_name)

# Clean up...
rm(my_enhanced_colnames)
rm(my_colnames)
rm(date_fields_posix)
rm(date_fields)
rm(productsbu04older)
rm(file_name)
rm(target_column)
rm(target_char)
