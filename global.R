library(shiny)
source("compileUnitsSoldIntoDataFrame.R")
source("compileSalesRankIntoDataFrame.R")


## HOURLY SALES DATA?? ##
hourly <- TRUE

######################################
########## Units Sold Stuff ##########
######################################
unitsSoldData <- compileUnitsSoldIntoDataFrame("data/unitsSold")
unitsSoldData$Sum <- rowSums(unitsSoldData[2:length(unitsSoldData)], na.rm = TRUE)
unitsSoldTitles <- names(unitsSoldData[2:length(unitsSoldData)])
unitsSoldData$Week <- as.Date(cut(unitsSoldData$Week.Ending, breaks = "week", start.on.monday = FALSE))
unitsSoldData$Month <- as.Date(cut(unitsSoldData$Week.Ending, breaks = "month"))
unitsSoldData$Quarter <- as.Date(cut(unitsSoldData$Week.Ending, breaks = "quarter"))
unitsSoldData$Year <- as.Date(cut(unitsSoldData$Week.Ending, breaks = "year"))


######################################
######### Amazon Sales Rank ##########
######################################
salesRankData <- compileSalesRankIntoDataFrame("data/salesRank", hourly = hourly)
salesRankTitles <- names(salesRankData[2:length(salesRankData)])