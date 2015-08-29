library(shiny)
source("~/Dropbox/Data Science Stuff/rfunctions/compileUnitsSoldIntoDataFrame.R")
source("~/Dropbox/Data Science Stuff/rfunctions/compileSalesRankIntoDataFrame.R")


## HOURLY SALES DATA?? ##
hourly <- FALSE

dataDirectory <- "~/Dropbox/Data Science Stuff/apps/data/"
unitsSoldDirectory <- paste(dataDirectory, "unitsSold", sep = "")
salesRankDirectory <- paste(dataDirectory, "salesRank", sep = "")

######################################
########## Units Sold Stuff ##########
######################################
unitsSoldData <- compileUnitsSoldIntoDataFrame(unitsSoldDirectory)
unitsSoldData$Sum <- rowSums(unitsSoldData[2:length(unitsSoldData)], na.rm = TRUE)
unitsSoldTitles <- names(unitsSoldData[2:length(unitsSoldData)])
unitsSoldData$Week <- as.Date(cut(unitsSoldData$Week.Ending, breaks = "week", start.on.monday = FALSE))
unitsSoldData$Month <- as.Date(cut(unitsSoldData$Week.Ending, breaks = "month"))
unitsSoldData$Quarter <- as.Date(cut(unitsSoldData$Week.Ending, breaks = "quarter"))
unitsSoldData$Year <- as.Date(cut(unitsSoldData$Week.Ending, breaks = "year"))


######################################
######### Amazon Sales Rank ##########
######################################
salesRankData <- compileSalesRankIntoDataFrame(salesRankDirectory, hourly = hourly)
salesRankTitles <- names(salesRankData[2:length(salesRankData)])