
install.packages("rugarch")   
install.packages("tseries")
install.packages("forecast")
install.packages("tseries")  
install.packages("ggpplot2")
install.packages("zoo")
install.packages("scales")


library(tseries)  # Load the package
library(rugarch)
library(tseries)
library(forecast)
library(tseries)
library(ggplot2)
library(zoo)
library(scales)


data <- read.csv(file.choose())  
colnames(data)


data$General <- as.numeric(gsub("%", "", data$General)) 
data$Food <- as.numeric(gsub("%", "", data$Food)) 
data$Non.food <- as.numeric(gsub("%", "", data$Non.food)) 

# Convert to time series
general_ts <- ts(data$General, frequency = 12)
food_ts <- ts(data$Food, frequency = 12)
nonfood_ts <- ts(data$Non.food, frequency = 12)

# Check Stationarity using Augmented Dickey-Fuller Test
adf.test(nonfood_ts)  # Perform for other series if needed


# If not stationary, take first differences
general_diff <- diff(general_ts, differences = 1)
food_diff <- diff(food_ts, differences = 1)
nonfood_diff <- diff(nonfood_ts, differences = 1)

# Identify best ARIMA model for differencing and lag selection
general_arima <- auto.arima(general_diff)
food_arima <- auto.arima(food_diff)
nonfood_arima <- auto.arima(nonfood_ts)


# Display selected ARIMA models
print(general_arima)
summary(food_arima)
summary(nonfood_arima)


# Fit a GARCH(1,1) model on the residuals
garch_spec <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1,1)),
                         mean.model = list(armaOrder = c(general_arima$arma[1], general_arima$arma[2]), include.mean = TRUE),
                         distribution.model = "norm")

general_garch <- ugarchfit(spec = garch_spec, data = residuals(general_arima))
food_garch <- ugarchfit(spec = garch_spec, data = residuals(food_arima))
nonfood_garch <- ugarchfit(spec = garch_spec, data = residuals(nonfood_arima))


# Print GARCH model summary
print(general_garch)
print(food_garch)
print(nonfood_garch)

# Extract Conditional Variance (Volatility)
vol_general <- sigma(general_garch)
vol_food <- sigma(food_garch)
vol_nonfood <- sigma(nonfood_garch)

# Plot volatility estimatess
plot(general_garch, which = "all")
plot(food_garch, which = "all")
plot(nonfood_garch, which = "all")


# Visualizing the Volatility
plot(vol_general, type = "l", col = "blue", main = "Volatility of General Inflation", ylab = "Conditional Volatility")
plot(vol_food, type = "l", col = "red", main = "Volatility of Food Inflation", ylab = "Conditional Volatility")
plot(vol_nonfood, type = "l", col = "green", main = "Volatility of Non-Food Inflation", ylab = "Conditional Volatility")


# Extract conditional variance (volatility)
general_volatility <- sigma(general_garch)
food_volatility <- sigma(food_garch)
nonfood_volatility <- sigma(nonfood_garch)

length(general_volatility)
length(general_volatility)
length(general_volatility)

# Ensure the Month column matches the length of volatility series (107 observations)
volatility_df <- data.frame(
  Month = data$Month[-1],  # Remove the first row to match differenced series
  General_Volatility = general_volatility,
  Food_Volatility = food_volatility,
  NonFood_Volatility = nonfood_volatility[1:107]  # Ensure nonfood_volatility is also 107
)

# Check the lengths to confirm
print(length(volatility_df$Month))  # Should be 107
print(length(volatility_df$General_Volatility))  # Should be 107
print(length(volatility_df$Food_Volatility))  # Should be 107
print(length(volatility_df$NonFood_Volatility))  # Should be 107


# Generate a sequence of months from Feb 2016 to Dec 2024
volatility_df$Month <- seq(as.Date("2016-02-01"), as.Date("2024-12-01"), by = "month")

# Convert to Year-Month format for better readability
library(zoo)
volatility_df$Month <- as.yearmon(volatility_df$Month)

# Check the first and last few rows to confirm
head(volatility_df)
tail(volatility_df)

volatility_df$Month <- as.Date(as.yearmon(volatility_df$Month))

ggplot(volatility_df, aes(x = Month)) +
  # Plot volatility lines
  geom_line(aes(y = General_Volatility, color = "General Inflation"), linewidth = 1) +
  geom_line(aes(y = Food_Volatility, color = "Food Inflation"), linewidth = 1) +
  geom_line(aes(y = NonFood_Volatility, color = "Non-Food Inflation"), linewidth = 1) +
  
  # Smooth trend lines (optional)
  geom_smooth(aes(y = General_Volatility, color = "General Inflation"), method = "loess", se = FALSE, linetype = "dashed") +
  geom_smooth(aes(y = Food_Volatility, color = "Food Inflation"), method = "loess", se = FALSE, linetype = "dashed") +
  geom_smooth(aes(y = NonFood_Volatility, color = "Non-Food Inflation"), method = "loess", se = FALSE, linetype = "dashed") +
  
  # Labels & Titles
  labs(title = "Volatility of Inflation Over Time",
       subtitle = "(Conditional Standard Deviation)",
       x = "Month", y = "Volatility",
       color = "Inflation Type") +
  
  # X-axis formatting
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", expand = c(0, 0)) +
  
  # Custom Colors
  scale_color_manual(values = c("General Inflation" = "#1f77b4", 
                                "Food Inflation" = "#d62728", 
                                "Non-Food Inflation" = "#2ca02c")) +
  
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels
        legend.position = "top",  # Move legend to top
        plot.title = element_text(face = "bold", size = 16, hjust = 0.5),  # Center-align title
        plot.subtitle = element_text(size = 12, hjust = 0.5, face = "italic"))  # Center-align subtitle and italicize

