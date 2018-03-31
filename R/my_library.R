# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Describe what we are doing.
cat('Building library functions...\n')

#
# Custdata Accessor Functions
#

# Builds a path to a custdata input file.
build_custdata_input_file_path <- function(file_name) {
  build_input_file_name(build_custdata_path(),
                        get_custdata_prefix(),
                        file_name)
}

# Builds a path to a custdata output file.
build_custdata_output_file_path <- function(file_name) {
  build_output_file_name(build_custdata_path(),
                         get_custdata_prefix(),
                         file_name)
}

# Builds a path to a custdata file.
build_custdata_path <- function() {
  file.path(get_project_path(), get_custdata_directory())
}

# Builds a custdata R script name.
build_custdata_r_script_name <- function(file_name) {
  build_r_script_name(get_custdata_prefix(), file_name)
}

# Builds a path to a sequential custdata output file.
build_sequential_custdata_output_file_path <- function(file_name, number) {
  build_sequential_output_file_name(build_custdata_path(),
                                    get_custdata_prefix(),
                                    file_name, number)
}

# Conditionally executes a custdata R script.
conditionally_execute_custdata_script <- function(file_name) {
  
  # Does the file already exist?
  if (does_custdata_output_file_exist(file_name)) {
    
    # The file already exists.
    cat(paste('The file \'', file_name, '\' already exists...\n', sep = ''))
  }
  
  # The file does not exist.
  else {
    
    # Source the appropriate R script.
    cat(paste('The file \'', file_name, '\' does not yet exists...\n', sep = ''))
    source(build_custdata_r_script_name(file_name))
  }
}

# Determines if a custdata input file exists.
does_custdata_input_file_exist <- function(file_name) {
  file.exists(build_custdata_input_file_path(file_name))
}

# Determines if a custdata output file exists.
does_custdata_output_file_exist <- function(file_name) {
  
  # Look for both the non-sequential, and the 1st sequential targets.
  file.exists(build_custdata_output_file_path(file_name)) |
    file.exists(build_sequential_custdata_output_file_path(file_name, 1))
}

# Gets the directory for custdata files.
get_custdata_directory <- function() {
  'Custdata'
}

# Gets the prefix for custdata input and output files.
get_custdata_prefix <- function() {
  'custdata'
}

# Reads a clean custdata input file.
read_clean_custdata_csv <- function(file_name) {
  read.csv(build_custdata_output_file_path(file_name))
}

# Reads a clean custdata input file in pieces.
read_clean_custdata_csv_in_pieces <- function(file_name, pieces) {
  
  # Build a list of data frames, one element for each piece.
  data_frames <- lapply(seq(1:pieces), function(x) {
    
    # Read the first/next piece.
    read_clean_sequential_custdata_csv(file_name, x)
  })
  
  # Bind the frames together.
  do.call(rbind, data_frames)
}

# Reads a clean sequential custdata input file.
read_clean_sequential_custdata_csv <- function(file_name, number) {
  read.csv(build_sequential_custdata_output_file_path(file_name, number))
}

# Reads a custdata input file.
read_custdata_csv <- function(file_name, my_quote = '"') {
  read.csv(build_custdata_input_file_path(file_name), quote = my_quote)
}

# Writes a custdata output file.
write_custdata_csv <- function(data_frame, file_name) {
  write.csv(data_frame, build_custdata_output_file_path(file_name),
            row.names = F)
}

# Writes a custdata csv in pieces.
write_custdata_csv_in_pieces <- function(data_frame, file_name, pieces) {

  sapply(seq(1:pieces), function(x) {
    write_sequential_custdata_csv(create_subset(data_frame, x, pieces),
                                  file_name, x)})
}

# Writes a sequential custdata output file.
write_sequential_custdata_csv <- function(data_frame, file_name, number) {
  write.csv(data_frame,
            build_sequential_custdata_output_file_path(file_name, number),
            row.names = F)
}

#
# Inflation Accessor Functions
#

# Builds a path to an inflation input file.
build_inflation_input_file_path <- function(file_name =
                                              get_inflation_file_name()) {

  file.path(build_inflation_path(),
            paste(file_name, get_extension_type(),
                  sep = get_extension_separator()))
}

# Builds a path to an inflation file.
build_inflation_path <- function() {
  file.path(get_project_path(), get_inflation_directory())
}

# Determines if an inflation input file exists.
does_inflation_input_file_exist <- function(file_name =
                                              get_inflation_file_name()) {
  file.exists(build_inflation_input_file_path(file_name))
}

# Gets the directory for inflation files.
get_inflation_directory <- function() {
  'Inflation'
}

# Gets the name of the standard inflation file.
get_inflation_file_name <- function() {
  'SeattleInflation'
}

#
# Product Accessor Functions
#

# Builds a path to a product input file.
build_product_input_file_path <- function(file_name) {
  build_input_file_name(build_product_path(),
                        get_product_prefix(),
                        file_name)
}

# Builds a path to a product output file.
build_product_output_file_path <- function(file_name) {
  build_output_file_name(build_product_path(),
                         get_product_prefix(),
                         file_name)
}

# Builds a path to a product file.
build_product_path <- function() {
  file.path(get_project_path(), get_product_directory())
}

# Builds a product R script name.
build_product_r_script_name <- function(file_name) {
  build_r_script_name(get_product_prefix(), file_name)
}

# Builds a path to a sequential product output file.
build_sequential_product_output_file_path <- function(file_name, number) {
  build_sequential_output_file_name(build_product_path(),
                                    get_product_prefix(),
                                    file_name, number)
}

# Conditionally executes a product R script.
conditionally_execute_product_script <- function(file_name) {
  
  # Build an output file path. Does the file already exist?
  file_path <- build_product_output_file_path(file_name)
  if (file.exists(file_path)) {
    
    # The file already exists.
    cat(paste('The file \'', file_name, '\' already exists...\n', sep = ''))
  }
  
  # The file does not exist.
  else {
    
    # Source the appropriate R script.
    cat(paste('The file \'', file_path, '\' does not yet exists...\n', sep = ''))
    source(build_product_r_script_name(file_name))
  }
}

# Determines if a product input file exists.
does_product_input_file_exist <- function(file_name) {
  file.exists(build_product_input_file_path(file_name))
}

# Determines if a product output file exists.
does_product_output_file_exist <- function(file_name) {
  
  # Look for both the non-sequential, and the 1st sequential targets.
  file.exists(build_product_output_file_path(file_name)) |
    file.exists(build_sequential_product_output_file_path(file_name, 1))
}

# Gets the directory for product files.
get_product_directory <- function() {
  'Product'
}

# Gets the prefix for product input and output files.
get_product_prefix <- function() {
  'product'
}

# Reads a clean product input file.
read_clean_product_csv <- function(file_name) {
  read.csv(build_product_output_file_path(file_name))
}

# Reads a clean product input file in pieces.
read_clean_product_csv_in_pieces <- function(file_name, pieces) {
  
  # Build a list of data frames, one element for each piece.
  data_frames <- lapply(seq(1:pieces), function(x) {
    
    # Read the first/next piece.
    read_clean_sequential_product_csv(file_name, x)
  })
  
  # Bind the frames together.
  do.call(rbind, data_frames)
}

# Reads a clean sequential product input file.
read_clean_sequential_product_csv <- function(file_name, number) {
  read.csv(build_sequential_product_output_file_path(file_name, number))
}

# Reads a product input file.
read_product_csv <- function(file_name, my_quote = '"') {
  read.csv(build_product_input_file_path(file_name), quote = my_quote)
}

# Writes a product output file.
write_product_csv <- function(data_frame, file_name) {
  write.csv(data_frame, build_product_output_file_path(file_name),
            row.names = F)
}

# Writes a product csv in pieces.
write_product_csv_in_pieces <- function(data_frame, file_name, pieces) {
  
  sapply(seq(1:pieces), function(x) {
    write_sequential_product_csv(create_subset(data_frame, x, pieces),
                                  file_name, x)})
}

# Writes a sequential product output file.
write_sequential_product_csv <- function(data_frame, file_name, number) {
  write.csv(data_frame,
            build_sequential_product_output_file_path(file_name, number),
            row.names = F)
}

#
# Sales Accessor Functions
#

# Builds a path to a sales input file.
build_sales_input_file_path <- function(file_name) {
  build_input_file_name(build_sales_path(),
                        get_sales_prefix(),
                        file_name)
}

# Builds a path to a sales output file.
build_sales_output_file_path <- function(file_name) {
  build_output_file_name(build_sales_path(),
                         get_sales_prefix(),
                         file_name)
}

# Builds a path to a sales file.
build_sales_path <- function() {
  file.path(get_project_path(), get_sales_directory())
}

# Builds a sales R script name.
build_sales_r_script_name <- function(file_name) {
  build_r_script_name(get_sales_prefix(), file_name)
}

# Builds a path to a sequential sales output file.
build_sequential_sales_output_file_path <- function(file_name, number) {
  build_sequential_output_file_name(build_sales_path(),
                                    get_sales_prefix(),
                                    file_name, number)
}

# Conditionally executes a sales R script.
conditionally_execute_sales_script <- function(file_name) {
  
  # Does the file already exist?
  if (does_sales_output_file_exist(file_name)) {
    
    # The file already exists.
    cat(paste('The file \'', file_name, '\' already exists...\n', sep = ''))
  }
  
  # The file does not exist.
  else {
    
    # Source the appropriate R script.
    cat(paste('The file \'', file_name, '\' does not yet exists...\n', sep = ''))
    source(build_sales_r_script_name(file_name))
  }
}

# Determines if a sales input file exists.
does_sales_input_file_exist <- function(file_name) {
  file.exists(build_sales_input_file_path(file_name))
}

# Determines if a sales output file exists.
does_sales_output_file_exist <- function(file_name) {
  
  # Look for both the non-sequential, and the 1st sequential targets.
  file.exists(build_sales_output_file_path(file_name)) |
    file.exists(build_sequential_sales_output_file_path(file_name, 1))
}

# Gets the directory for sales files.
get_sales_directory <- function() {
  'Sales'
}

# Gets the prefix for sales input and output files.
get_sales_prefix <- function() {
  'sales'
}

# Gets the number of pieces of the clean pp_sold_products csv file.
get_sales_sold_products_piece_count <- function() {
  3
}

# Reads a clean sales input file.
read_clean_sales_csv <- function(file_name) {
  read.csv(build_sales_output_file_path(file_name))
}

# Reads a clean sales input file in pieces.
read_clean_sales_csv_in_pieces <- function(file_name, pieces) {
  
  # Build a list of data frames, one element for each piece.
  data_frames <- lapply(seq(1:pieces), function(x) {
    
    # Read the first/next piece.
    read_clean_sequential_sales_csv(file_name, x)
  })
  
  # Bind the frames together.
  do.call(rbind, data_frames)
}

# Reads a clean sequential sales input file.
read_clean_sequential_sales_csv <- function(file_name, number) {
  read.csv(build_sequential_sales_output_file_path(file_name, number))
}

# Reads a sales input file.
read_sales_csv <- function(file_name, my_quote = '"') {
  read.csv(build_sales_input_file_path(file_name), quote = my_quote)
}

# Writes a sales output file.
write_sales_csv <- function(data_frame, file_name) {
  write.csv(data_frame, build_sales_output_file_path(file_name),
            row.names = F)
}

# Writes a sales csv in pieces.
write_sales_csv_in_pieces <- function(data_frame, file_name, pieces) {
  
  sapply(seq(1:pieces), function(x) {
    write_sequential_sales_csv(create_subset(data_frame, x, pieces),
                                 file_name, x)})
}

# Writes a sequential sales output file.
write_sequential_sales_csv <- function(data_frame, file_name, number) {
  write.csv(data_frame,
            build_sequential_sales_output_file_path(file_name, number),
            row.names = F)
}

#
# Scandata Accessor Functions
#

# Builds a path to a scandata input file.
build_scandata_input_file_path <- function(file_name) {
  build_input_file_name(build_scandata_path(),
                        get_scandata_prefix(),
                        file_name)
}

# Builds a path to a scandata output file.
build_scandata_output_file_path <- function(file_name) {
  build_output_file_name(build_scandata_path(),
                         get_scandata_prefix(),
                         file_name)
}

# Builds a path to a scandata file.
build_scandata_path <- function() {
  file.path(get_project_path(), get_scandata_directory())
}

# Builds a scandata R script name.
build_scandata_r_script_name <- function(file_name) {
  build_r_script_name(get_scandata_prefix(), file_name)
}

# Builds a path to a sequential scandata output file.
build_sequential_scandata_output_file_path <- function(file_name, number) {
  build_sequential_output_file_name(build_scandata_path(),
                                    get_scandata_prefix(),
                                    file_name, number)
}

# Conditionally executes a scandata R script.
conditionally_execute_scandata_script <- function(file_name) {
  
  # Does the file already exist?
  if (does_scandata_output_file_exist(file_name)) {
    
    # The file already exists.
    cat(paste('The file \'', file_name, '\' already exists...\n', sep = ''))
  }
  
  # The file does not exist.
  else {
    
    # Source the appropriate R script.
    cat(paste('The file \'', file_name, '\' does not yet exist...\n',
              sep = ''))
    source(build_scandata_r_script_name(file_name))
  }
}

# Determines if a scandata input file exists.
does_scandata_input_file_exist <- function(file_name) {
  file.exists(build_scandata_input_file_path(file_name))
}

# Determines if a scandata output file exists.
does_scandata_output_file_exist <- function(file_name) {
  
  # Look for both the non-sequential, and the 1st sequential targets.
  file.exists(build_scandata_output_file_path(file_name)) |
    file.exists(build_sequential_scandata_output_file_path(file_name, 1))
}

# Gets the directory for scandata files.
get_scandata_directory <- function() {
  'Scandata'
}

# Gets the prefix for scandata input and output files.
get_scandata_prefix <- function() {
  'scandata'
}

# Reads a clean scandata input file.
read_clean_scandata_csv <- function(file_name) {
  read.csv(build_scandata_output_file_path(file_name))
}

# Reads a clean scandata input file in pieces.
read_clean_scandata_csv_in_pieces <- function(file_name, pieces) {
  
  # Build a list of data frames, one element for each piece.
  data_frames <- lapply(seq(1:pieces), function(x) {
    
    # Read the first/next piece.
    read_clean_sequential_scandata_csv(file_name, x)
  })
  
  # Bind the frames together.
  do.call(rbind, data_frames)
}

# Reads a clean sequential scandata input file.
read_clean_sequential_scandata_csv <- function(file_name, number) {
  read.csv(build_sequential_scandata_output_file_path(file_name, number))
}

# Reads a scandata input file.
read_scandata_csv <- function(file_name, my_quote = '"') {
  read.csv(build_scandata_input_file_path(file_name), quote = my_quote)
}

# Writes a scandata output file.
write_scandata_csv <- function(data_frame, file_name) {
  write.csv(data_frame, build_scandata_output_file_path(file_name),
            row.names = F)
}

# Writes a scandata csv in pieces.
write_scandata_csv_in_pieces <- function(data_frame, file_name, pieces) {
  
  sapply(seq(1:pieces), function(x) {
    write_scandata_product_csv(create_subset(data_frame, x, pieces),
                                 file_name, x)})
}

# Writes a sequential scandata output file.
write_sequential_scandata_csv <- function(data_frame, file_name, number) {
  write.csv(data_frame,
            build_sequential_scandata_output_file_path(file_name, number),
            row.names = F)
}

#
# Date Format Functions
#

# Gets the date format for Kids on 45th input data.
get_kids_on_45th_date_format <- function() {
  '%m/%d/%Y %I:%M:%S %p'
}

# Gets the date format for the inflation data.
get_inflation_date_format <- function() {
  '%d-%m-%y'
}

#
# Other Functions
#

# Builds an input file name path.
build_input_file_name <- function(directory, prefix, file_name) {
  file.path(directory, paste(prefix,
                             paste(file_name,
                                   get_extension_type(),
                                   sep = get_extension_separator()),
                             sep = get_file_name_separator()))
}

# Builds a normalized currency field name.
build_norm_field_name <- function(field_name) {
  build_suffixed_field_name(field_name, 'norm')
}

# Builds an output file name path.
build_output_file_name <- function(directory, prefix, file_name) {
  file.path(directory, paste(get_output_file_prefix(),
                             prefix,
                             paste(file_name,
                                   get_extension_type(),
                                   sep = get_extension_separator()),
                             sep = get_file_name_separator()))
}

# Builds a posix date field name.
build_posix_field_name <- function(field_name) {
  build_suffixed_field_name(field_name, 'posix')
}

# Builds an R script name.
build_r_script_name <- function(prefix, file_name) {
  paste(paste(prefix, file_name, sep = get_file_name_separator()),
        '.R', sep = '')
}

# Builds a sequential output file name path.
build_sequential_output_file_name <- function(directory, prefix,
                                              file_name, number) {
  
  # Get the file name separator, and build an augmented file name.
  file_name_separator <- get_file_name_separator();
  augmented_file_name <- paste(file_name, number, sep = file_name_separator)
  
  # Construct the sequential output file name path.
  file.path(directory, paste(get_output_file_prefix(), prefix,
                             paste(augmented_file_name,
                                   get_extension_type(),
                                   sep = get_extension_separator()),
                             sep = file_name_separator))
}

# Builds a suffixed field.
build_suffixed_field_name <- function(field_name, suffix) {
  paste(field_name, suffix, sep = get_file_name_separator())
}

# Calculates a normalized price.
calculate_normalized_price <- function(price,
                                       timestamp,
                                       cpi = normalizaton_cpi,
                                       my_function = cpi_function) {
  round_currency(price * cpi / my_function(timestamp))
}

# Creates a CPI calculation function.
create_cpi_function <- function(data = inflation_data) {
  splinefun(x = data$timestamp, y = data$u_index)
}

# Creates inflation data.
create_inflation_data <- function(file_name = get_inflation_file_name()) {

  # Read a csv file with the expected properties given the file name.
  inflation <- read.csv(build_inflation_input_file_path(file_name),
                        sep = ' ', header = T,
                        na.string = 'x')
  date_format <- get_inflation_date_format()
  
  # Create the timestamp, and convert the date field.
  inflation$timestamp <- create_timestamp(inflation$date,
                                          date_format)
  inflation$date <- as.Date(inflation$date, format = date_format)
  
  # Declare and initialize the find and replace strings.
  to_find <- '%'
  to_replace <- ''
  
  # Convert percentage strings to numeric.
  inflation$u_change <- as.numeric(sub(to_find, to_replace,
                                       inflation$u_change))
  
  inflation$w_change <- as.numeric(sub(to_find, to_replace,
                                       inflation$w_change))
  
  inflation$growth <- as.numeric(sub(to_find, to_replace,
                                     inflation$growth))
  
  # Return the inflation data.
  inflation
}

# Creates a subset of a data frame.
create_subset <- function(data_frame, piece, of) {
  
  # Get the number of rows in the data frame, and create the subset.
  rows <- nrow(data_frame)
  data_frame[c(floor(rows * (piece - 1) / of + 1):floor(rows * piece / of)),]
}

# Creates an integer timestamp from a date string and an expected format.
create_timestamp <- function(date_time,
                             date_format = get_kids_on_45th_date_format()) {
  as.integer(as.POSIXct(date_time, format = date_format))
}

# Gets the extension separator.
get_extension_separator <- function() {
  '.'
}

# Gets the extension type.
get_extension_type <- function() {
  'csv'
}

# Gets the file name separator.
get_file_name_separator <- function() {
  '_'
}

# Gets the start of the time interval for a date identified in a data
# frame.
get_interval_start <- function(date_frame, my_function, interval) {
  
  cut(my_function(as.Date(date_frame$date_sold,
                          format = get_kids_on_45th_date_format())),
      breaks = interval)
}

# Gets a normalization CPI.
get_normalization_cpi <- function(data = inflation_data) {
  data[nrow(data),]$u_index
}

# Gets the output file prefix.
get_output_file_prefix <- function() {
  'clean'
}

# Gets the project path.
get_project_path <- function() {
  
  # Note: There might be a better way to do this with an environment variable.
  # We assume that the project path is the parent of this source directory.
  normalizePath('..')
}

# Gets the quote character.
get_quote_char <- function() {
  '"'
}

# Gets the substitute quote character.
get_substitute_quote_char <- function() {
  '|'
}

# Rounds a currency amount.
round_currency <- function(currency) {
  round(currency, 2)
}

# Declare and initialize global variables that are expensive to create.
cat('Building library global variables...\n')
inflation_data <- create_inflation_data()
cpi_function <- create_cpi_function()
normalizaton_cpi <- get_normalization_cpi()

# Declare common variables of interest.
new_product_id = 999
store_id = 600
