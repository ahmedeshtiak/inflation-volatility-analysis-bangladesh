# inflation-volatility-analysis-bangladesh
Time series modeling of general, food, and non-food inflation in Bangladesh using ARIMA and GARCH models in R. Includes volatility estimation, statistical testing, and dynamic visualization.

# Inflation Volatility Analysis in Bangladesh (2016–2024)

Inflation volatility in Bangladesh has been driven primarily by food price shocks, global commodity price fluctuations, and exchange rate instability. Recent years have seen persistently high and unstable inflation, especially in food items, disproportionately affecting low-income households. This volatility poses challenges for monetary policy and threatens overall economic stability.

This R project models and analyzes the volatility of General, Food, and Non-Food inflation in Bangladesh using ARIMA and GARCH time series models. The project includes preprocessing of monthly inflation data, stationarity tests, model selection, GARCH fitting, and visualization of conditional volatility trends.

## 📦 Packages Used
- `rugarch` – for GARCH modeling
- `forecast` – for ARIMA model selection
- `tseries` – for Augmented Dickey-Fuller test
- `ggplot2` – for data visualization
- `zoo` and `scales` – for time series formatting and plotting

## 🔍 Key Features
- Preprocesses monthly inflation data (2016–2024)
- Tests for stationarity using ADF
- Fits ARIMA models to identify appropriate lags
- Applies GARCH(1,1) models to model inflation volatility
- Visualizes conditional volatility trends over time using `ggplot2`

## 📈 Output
- Interactive volatility plots for General, Food, and Non-Food inflation
- Smoothed trend lines for comparative volatility interpretation
- A tidy data frame (`volatility_df`) ready for further policy or academic use
