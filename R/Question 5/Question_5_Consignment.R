# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg
#
# This script attempts to answer the question: What are the seasonal and
# trends in consignment items sales?

# Clear the console, and the environment.
cat("\014")
rm(list=ls())

# Declare library packages for table production.
library(gridExtra)
library(grid)

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
  by_date <- aggregate(soldprice_norm ~ date_sold, data = data_frame, mean)
  
  # Make a cut of the date sold by month.
  by_date$month_cut <- cut(as.Date(by_date$date_sold,
                                   format=get_kids_on_45th_date_format()),
                           breaks = interval, labels = F)
  
  # Aggregate again by the month cut, and take the mean.
  mean_per_month <- aggregate(soldprice_norm ~ month_cut, data = by_date, mean)
  
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
                   length(month.name))
  
  # Plot mean item cost by month, but leave off the x-axis and y-axis tick
  # marks.
  plot(mean_item_cost ~ month_cut,
       data = mean_item_cost_by_month,
       xaxt = 'n',
       xlab = 'Date',
       yaxt = 'n',
       ylab = '',
       main = title)
  
  # Put on our own x-axis tick marks, and our own y-axis tick marks with a
  # currency symbol, and to two decimal places.
  axis(2, at=axTicks(2), labels=sprintf('$%.2f', axTicks(2)), las = 1)
  axis(1, at=intervals, labels = format(my_labels[intervals + 1], '%b %y'))
  
  # Build a price model based on the real data. Get a summary of the model.
  coefficient_name <- 'month_cut'
  my_model <- lm(log(mean_item_cost) ~ month_cut,
                 data = mean_item_cost_by_month)
  my_summary <- summary(my_model)
  
  # Draw an exponential trendline.
  trendline_color <- 'red'
  x <- seq(-10., 130., 0.001)
  lines(x, exp(my_model$coefficients['(Intercept)'] + x *
                 my_model$coefficients[coefficient_name]),
        col=trendline_color)
  
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
                                  format = my_format, digits = my_digits))),
         col = trendline_color, lty=1:1, cex=0.8)
}

# Uses plot.ts to plot a time series, but turns the ticks on the Y axis so that
# they're horizontal, and also adds currency signs to the Y axis ticks.
do_ts_plot <- function(time_series, title) {
  
  # Plot the mean item price per month.
  plot.ts(time_series, ylab = '', yaxt = 'n', main = title)
  axis(2, at=axTicks(2), labels=sprintf('$%.2f', axTicks(2)), las = 1)
}

# This plotting function is borrowed from plot.decomposed.ts, but adds a
# parameter for an explicit title.
my_plot.decomposed.ts <- function(x,
                                  title = 'Decomposition of additive time series',
                                  ...) {
  
  xx <- x$x
  if (is.null(xx)) 
    xx <- with(x, if (type == "additive") 
      random + trend + seasonal
      else random * trend * seasonal)
  plot(cbind(observed = xx, trend = x$trend, seasonal = x$seasonal, 
             random = x$random), main = title, ...)
}

# Read in sold products from 2008, and the sold products purchased from 2009
# to 2017. The data from 2009 to 2017 is large, so it comes in several pieces.
# Bind the two datasets. The data have the same format.
sold_products <- read_clean_sales_csv('pp_soldprod2008')
sold_products <- rbind(sold_products,
                       read_clean_sales_csv_in_pieces('pp_sold_products',
                                                      get_sales_sold_products_piece_count()))

# Exclude store purchased items. Do other row exclusions, as required.
exclude_store <- sold_products[sold_products$customer_no_sold != store_id,]
source <- exclude_store[exclude_store$customer_no_product != new_product_id,]
mean_per_month <- calculate_average_item_cost_per_month(source)

# Declare some variables.
month_count <- length(month.name)
ts_day <- 1
ts_end_year <- 2017
ts_month <- 1
ts_start_year <- 2008

# Create a time series from the mean item price per month.
my_ts <- ts(mean_per_month$mean_item_cost, start = c(ts_start_year, ts_month, ts_day),
            end = c(ts_end_year, ts_month, ts_day),
            frequency = month_count)

# Plot the mean item price per month.
do_ts_plot(my_ts,
           title = 'Per Month Normalized Item Price Per Month for Consignment Items')

# Decompose the time series, and then plot that.
ts_decomposition <- decompose(my_ts)
row_count <- length(as.numeric(ts_decomposition$seasonal))
my_plot.decomposed.ts(ts_decomposition,
                      title = 'Components of Per Month Normalized Item Price for Consignment Items')

# Display price trends without seasonality.
trend_per_month <- mean_per_month[1:row_count,]
trend_per_month$mean_item_cost <- as.numeric(ts_decomposition$trend)
trend_per_month[complete.cases(trend_per_month),]
do_plot(trend_per_month,
        'Consignment Item Adjusted Price Trends (minus Seasonality & Randomness)')

# Get the mean seasonality.
mean_seasonality <- sapply(seq(1:12), FUN = function(x) {
  mean(ts_decomposition$seasonal[seq(x, row_count, month_count)])
})

# Build a seasonality table.
seasonality_table <- data.frame(month = month.name,
                                adjustment = sprintf("$%0.2f",
                                                     round_currency(as.numeric(mean_seasonality))))
seasonality_table <- seasonality_table[complete.cases(seasonality_table),]
colnames(seasonality_table) <- c('Month', 'Adjustment')

# Display the table.
plot.new()
text(x = 0.15, y = 0.5, 'Table of\nSeasonal Variances\nfor Consignment\nItem Sales')
grid.table(seasonality_table)

# Clean up...
rm(seasonality_table)
rm(mean_seasonality)
rm(trend_per_month)
rm(row_count)
rm(ts_decomposition)
rm(my_ts)
rm(ts_start_year)
rm(ts_month)
rm(ts_end_year)
rm(ts_day)
rm(month_count)
rm(mean_per_month)
rm(source)
rm(exclude_store)
rm(sold_products)
