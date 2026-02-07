#Loading the dataset
unemployment_data <- read.csv("C:\\Users\\h4has\\OneDrive\\Desktop\\lfs_month_duration.csv")
head(unemployment_data)

###############Data Preprocessing##############################

#Checking for missing values
colSums(is.na(unemployment_data))
#Summary statistics
summary(unemployment_data)
#Checking data types
str(unemployment_data)
#Converting data column into date datatype as its character by default
unemployment_data$date <- as.Date(unemployment_data$date, format="%Y-%m-%d")
#Rechecking data types after conversion
str(unemployment_data)

#####################Exploratory Data Analysis##########################################

#Histograms for each numeric variable
numeric_vars <- names(unemployment_data)[sapply(unemployment_data, is.numeric)]
par(mfrow=c(3,3))  # Arrange plots in a 3x3 grid for histograms
for (var in numeric_vars) {
  hist(unemployment_data[[var]], main=paste("Histogram of", var), xlab=var, col="lightblue", border="black")
}
par(mfrow=c(1,1))  # Reset plot layout

#Boxplots to identify outliers
par(mfrow=c(3,3))  # Arrange plots in a 3x3 grid for boxplots
for (var in numeric_vars) {
  boxplot(unemployment_data[[var]], main=paste("Boxplot of", var), ylab=var, col="lightgreen")
}
par(mfrow=c(1,1))  # Reset plot layout

#Plotting unemployed over time
library(ggplot2)
ggplot(unemployment_data, aes(x=date, y=unemployed)) + 
  geom_line(color="blue") + 
  labs(title="Unemployment Trend Over Time", x="Date", y="Unemployed")

#Correlation matrix and heatmap
cor_matrix <- cor(unemployment_data[, numeric_vars], use = "complete.obs")
library(ggcorrplot)
ggcorrplot(cor_matrix, lab = TRUE, colors = c("blue", "white", "red"))

##################### Time Series Analysis ##############################

library(ggplot2)

# Time series plot: Total vs Active Unemployment
ggplot(unemployment_data, aes(x = date)) +
  geom_line(aes(y = unemployed, color = "Total Unemployment"), size = 1) +
  geom_line(aes(y = unemployed_active, color = "Active Unemployment"), size = 1) +
  scale_color_manual(values = c("Total Unemployment" = "blue",
                                "Active Unemployment" = "red")) +
  labs(
    title = "Unemployment Trends Over Time (2016–2024)",
    x = "Year",
    y = "Number of Unemployed",
    color = "Legend"
  ) +
  theme_minimal()

##################### Regression Analysis ##############################

# Fit linear regression model
unemployment_model <- lm(unemployed_active ~ unemployed,
                          data = unemployment_data)

# View model summary
summary(unemployment_model)

##################### Model Diagnostics ##############################

# Residual summary
summary(residuals(unemployment_model))

# Residual standard error
sigma(unemployment_model)

# Confidence intervals for coefficients
confint(unemployment_model)


##################### Regression Plot ##############################

ggplot(unemployment_data,
       aes(x = unemployed, y = unemployed_active)) +
  geom_point(color = "black", alpha = 0.6) +
  geom_smooth(method = "lm",
              se = TRUE,
              color = "blue",
              fill = "grey80") +
  labs(
    title = "Regression Analysis: Total vs Active Unemployment",
    x = "Total Unemployed",
    y = "Active Unemployed"
  ) +
  theme_minimal()

