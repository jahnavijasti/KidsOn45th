# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg
#
# This script attempts to answer the question: What has been the
# month-over-month number of items purchased per transaction?

# Clear the console, and the environment.
cat("\014")
rm(list=ls())

# Source the library.
cat(paste('The working directory is: \'', getwd()), '\'...', sep = '')
source('my_library.R')

# Calculates the average price of items purchased per transaction per month.
calculate_average_item_cost_per_month <- function(data_frame) {
  
  # Declare the column names in the result.
  column_names <- c('month_cut',
                    'mean_item_cost',
                    'month_start')
  
  # Declare the time interval of interest.
  interval = 'month'
  
  # Aggregate the mean of sold price by date sold.
  by_date <- aggregate(soldprice ~ date_sold, data = data_frame, mean)
  
  # Make a cut of the date sold by month.
  by_date$month_cut <- cut(as.Date(by_date$date_sold,
                                   format=get_kids_on_45th_date_format()),
                           breaks = interval, labels = F)
  
  # Aggregate again by the month cut, and take the mean.
  mean_per_month <- aggregate(soldprice ~ month_cut, data = by_date, mean)
  
  # Now add a month start field.
  mean_per_month$month_start <-
    seq(as.Date(get_interval_start(by_date, min, interval)),
        as.Date(get_interval_start(by_date, max, interval)),
        by = interval)
  
  # Change the column names.  Reorder the columns, and return.
  colnames(mean_per_month) <- column_names
  mean_per_month[,c(column_names[1], column_names[3], column_names[2])]
}

# Plots mean item cost by month.
do_plot <- function(mean_item_cost_by_month, title, legend_position, lessThan=T) {
  
  # Create labels for a plot.
  my_labels <- c(as.Date(cut(min(mean_item_cost_by_month$month_start[1] - 1),
                             breaks = 'month')),
                 mean_item_cost_by_month$month_start)
  
  # Create intervals at which ticks will be shown on the x-axis.
  intervals <- seq(mean_item_cost_by_month$month_cut[1] - 1,
                   mean_item_cost_by_month$month_cut[nrow(mean_item_cost_by_month)],
                   12)
  
  # Plot mean item cost by month, but leave off the x-axis and y-axis tick
  # marks.
  plot(mean_item_cost ~ month_cut,
       data = mean_item_cost_by_month,
       xaxt = 'n',
       xlab = 'Date',
       yaxt = 'n',
       ylab = '',
       main = paste(title, 'Item Mean Cost Increases Are',
                    ifelse(lessThan, 'Less', 'Greater'), 'Than Inflation'))
  
  # Put on our own x-axis tick marks, and our own y-axis tick marks with a
  # currency symbol, and to two decimal places.
  axis(2, at=axTicks(2), labels=sprintf('$%.2f', axTicks(2)), las = 1)
  axis(1, at=intervals, labels = format(my_labels[intervals + 1], '%b %y'))

  # Declare colors for the trendlines that follow.
  actual_trendline_color <- 'red'
  expected_trendline_color <- 'dark green'
  
  # Build a price model based on the real data. Get a summary of the model.
  coefficient_name <- 'month_cut'
  my_model <- lm(log(mean_item_cost) ~ month_cut,
                 data = mean_item_cost_by_month)
  my_summary <- summary(my_model)
  
  # Draw an exponential trendline.
  x <- seq(-10., 130., 0.001)
  lines(x, exp(my_model$coefficients['(Intercept)'] + x *
                 my_model$coefficients[coefficient_name]),
        col=actual_trendline_color)
  
  # Declare and initialize format, and month cuts for first and last months.
  my_format <- get_inflation_date_format()
  first_month <- min(mean_item_cost_by_month$month_cut, na.rm = T)
  last_month <- max(mean_item_cost_by_month$month_cut, na.rm = T)
  
  # Determine what the model thinks item mean cost should be at month zero.
  at_zero <- exp(predict(my_model, data.frame(month_cut = first_month)))
  
  # Determine what the same value *should* be based on the trend of inflation.
  at_last <- at_zero *
    cpi_function(create_timestamp('15-04-17', my_format)) /
    cpi_function(create_timestamp('15-01-07', my_format))
  
  # Build a data frame with the expected sales by month.
  expected_cost_by_month <- data.frame(month_cut = c(first_month, last_month),
                                       mean_item_cost = c(at_zero, at_last))
  
  # Build an expected price model. Get a summary of the model.
  expected_model <- lm(log(mean_item_cost) ~ month_cut,
                       data = expected_cost_by_month)
  expected_summary <- summary(expected_model)
  
  # Draw an exponential trendline.
  lines(x, exp(expected_model$coefficients['(Intercept)'] +
                 x * expected_model$coefficients[coefficient_name]),
        col=expected_trendline_color)
  
  # Declare a few more local variables.
  my_digits <- 2
  my_format <- 'e'
  p_value_index <- 8
  
  # Draw a legend with the slope of the trend line and its p-value
  # signficance for the actual cost model.  The expected model has no p-value
  # as we modeled it with only two points.
  legend('topleft',
         legend = c(paste('Mean Cost:',
                          formatC(my_model$coefficients['month_cut'],
                                  format = my_format, digits = my_digits),
                          'per month; P-value:',
                          formatC(my_summary$coefficients[p_value_index],
                                  format = my_format, digits = my_digits)),
                    paste('Inflation:',
                          formatC(expected_model$coefficients['month_cut'],
                                  format = my_format, digits = my_digits),
                          'per month')),
         col = c(actual_trendline_color, expected_trendline_color),
         lty=1:1, cex=0.8)
}

# Read in sold products from 2008, the products purchased from 2009 to 2017.
# The data from 2009 to 2017 is large, so it comes in several pieces. Bind the
# two datasets, as the data have the same format.
sold_products <- read_clean_sales_csv('pp_soldprod2008')
sold_products <- rbind(sold_products,
                       read_clean_sales_csv_in_pieces('pp_sold_products',
                                                      get_sales_sold_products_piece_count()))

# Exclude store purchased items.
exclude_store <- sold_products[sold_products$customer_no_sold != store_id,]

# Declare a factor of exploration paths.
cases <- as.factor(seq(1:5))
current_case <- cases[3]

# Case 1: Both consignment and new.
if (cases[1] == current_case) {

  do_plot(calculate_average_item_cost_per_month(exclude_store),
          'Consignment and New', lessThan = F)
  
# Case 2: Only consignment items.
} else if (cases[2] == current_case) {
  
  do_plot(calculate_average_item_cost_per_month(
    exclude_store[exclude_store$customer_no_product != new_product_id,]),
    'Consignment', lessThan = F)
  
# Case 3: Only new items.
} else if (cases[3] == current_case) {
  
  do_plot(calculate_average_item_cost_per_month(
    exclude_store[exclude_store$customer_no_product == new_product_id,]),
    'New', lessThan = T)
  
# Undefined cases.
} else {
  
  # Just put a message on the console.
  cat(paste('Case number', current_case, 'is currently undefined.'))
}

# Clean up...
rm(current_case)
rm(cases)
rm(exclude_store)
rm(sold_products)
rm(do_plot)
rm(calculate_average_item_cost_per_month)
