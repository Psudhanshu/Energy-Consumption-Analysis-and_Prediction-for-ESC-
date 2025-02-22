library(arrow)
library(tidyverse)
library(ggplot2)
#reading the house data
house <- read_parquet("https://intro-datascience.s3.us-east-2.amazonaws.com/SC-data/static_house_info.parquet")
library(readr)
combined_data <- read_csv("combined_house_data.csv")
energy_data <- combined_data
#str(distinct(combined_data))
energy_data <- merge(x=energy_data,y=house,by.x = "building_id",by.y = "bldg_id")
#View(energy_data)
energy_consumption <- rowSums(energy_data[,3:44])
eng <- data.frame(energy_data[,1:2],energy_consumption,energy_data[,45:221])
str(eng)
#View(eng)
#eng <- eng[eng$Dry.Bulb.Temperature...C. > mean( eng$Dry.Bulb.Temperature...C.), ]
eng[,"applicability"] <- as.factor(eng[,"applicability"])
for (i in 1:ncol(eng)){
  if(is.character(eng[,i])){
    eng[,i] <- as.factor(eng[,i])
  }
}
x=length(levels(eng[,1]))!=1
for(i in 2:ncol(eng)){
  if(is.factor(eng[,i])){
  x=append(x,length(levels(eng[,i]))!=1)
  }
  else{
  x=append(x,length(unique(eng[,i]))!=1)
  }
}
cleandf <- eng[,x]
for(i in 1:ncol(cleandf)){
  if(is.numeric(cleandf[,i])){
    cleandf[,i]<-asinh(cleandf[,i])
  }
}
View(cleandf)
summary(cleandf$energy_consumption)


plot(cleandf$energy_consumption,cleandf$Relative.Humidity....)
boxplot(cleandf$energy_consumption~cleandf$in.cooling_setpoint)
ggplot(cleandf, aes(x = in.city, y = energy_consumption)) +
  geom_bar(stat = "summary", fun = "sum", fill = "skyblue")+
  theme(axis.text.x = element_text(angle =45,hjust = 1))


library(caret)
fit <- train( energy_consumption~ ., data = cleandf, method = "lm")
summary(fit)
significant_features <- varImp(fit, scale = FALSE)
sig <- significant_features$importance
sig$features <- rownames(sig)
sig <- sig[order(-sig$Overall),]
#write.csv(sig, file = "significant_update.csv", row.names = FALSE)

sig<-read_csv("/Users/vinaykumarc/significant_update.csv")
View(sig)
columnsdf <- c("in.heating_setpoint","Dry.Bulb.Temperature...C.","in.lighting",
             "in.misc_pool","in.misc_hot_tub_spa","in.occupants",
             "in.cooling_setpoint","in.cooling_setpoint_offset_magnitude",
             "in.misc_gas_fireplace","in.window_areas","in.income",
             "in.misc_freezer","Global.Horizontal.Radiation..W.m2.",
             "in.misc_pool_heater","in.sqft","in.cooking_range","Direct.Normal.Radiation..W.m2.",
             "Wind.Speed..m.s.","in.cooling_setpoint_offset_period","in.geometry_foundation_type",
             "in.misc_gas_grill","in.misc_well_pump","in.ducts","in.roof_material",
             "in.hot_water_fixtures","in.misc_extra_refrigerator","energy_consumption"
             )
x=cleandf[,columnsdf]
# write.csv(x, file = "filtered.csv", row.names = FALSE)
# linear model
# fit <- train(energy_consumption~ ., data = x, method = "lm")
# summary(fit)

library(e1071)
library(caret)
set.seed(2701) 
training <- createDataPartition(x$energy_consumption, p = 0.7, list = FALSE)
train_data <- x[training, ]
test_data <- x[-training, ]

svr_model <- svm(energy_consumption~ ., data = train_data
                   , type = "eps-regression", kernel = "radial")
summary(svr_model)
predictions <- predict(svr_model, test_data)
test_actual <- test_data$energy_consumption
rmse <- sqrt(mean((predictions - test_actual)^2))
print(paste("RMSE:", rmse))
residuals <- test_actual - predictions
ss_res <- sum(residuals^2)
ss_tot <- sum((test_actual - mean(test_actual))^2)
r_squared <- 1 - (ss_res / ss_tot)
r_squared

saveRDS(svr_model, file = "svr_model.rds")
svr_model <- readRDS("svr_model.rds")








library(lightgbm)
library(data.table)

dtrain <- lgb.Dataset(data = as.matrix(x[, -ncol(x)]),
                      label = x$energy_consumption)
params <- list(
  objective = "regression",
  metric = "rmse",
  num_leaves = 100,
  learning_rate = 0.9,
  n_estimators = 100
)
model <- lgb.train(
  params = params,
  data = dtrain,
  nrounds = 100,
  valids = list(test = dtrain),
  early_stopping_rounds = 30,
  verbose = 1
)

x <- x[complete.cases(x), ]
# LINEAR REGRESSION
# Define linear regression formula
formula <- energy_consumption ~ in.heating_setpoint + Dry.Bulb.Temperature...C. + in.lighting + in.misc_pool + in.misc_hot_tub_spa + in.occupants + in.cooling_setpoint + in.cooling_setpoint_offset_magnitude + in.misc_gas_fireplace + in.window_areas + in.income + in.misc_freezer + Global.Horizontal.Radiation..W.m2. + in.misc_pool_heater + in.sqft + in.cooking_range + Direct.Normal.Radiation..W.m2. + Wind.Speed..m.s. + in.cooling_setpoint_offset_period + in.geometry_foundation_type + in.misc_gas_grill + in.misc_well_pump + in.ducts + in.roof_material + in.hot_water_fixtures + in.misc_extra_refrigerator

# Fit linear regression model
lm_model <- lm(formula, data = x)

# Summary of linear regression model
summary(lm_model)

predictions <- predict(lm_model, test_data)
test_actual <- test_data$energy_consumption
rmse <- sqrt(mean((predictions - test_actual)^2))
print(paste("RMSE:", rmse))
r_squared <- 1 - (sum((test_actual - predictions)^2) / sum((test_actual - mean(test_actual))^2))
print(paste("R-squared:", r_squared))



# RIDGE REGRESSION
