library(shiny)
source("~/Dropbox/Data Science Stuff/rfunctions/assembleUnitsSoldData.R")
source("~/Dropbox/Data Science Stuff/rfunctions/assembleSalesRankData.R")


## HOURLY SALES DATA?? ##
method <- "daily"

dataDirectory <- "~/Dropbox/Data Science Stuff/apps/data/"

######################################
########## Units Sold Stuff ##########
######################################
unitsSoldData <- assembleUnitsSoldData(paste(dataDirectory, "unitsSold", sep = ""))
unitsSoldData <- join_all(unitsSoldData, by = "timestamp", type = "full")
unitsSoldData$Sum <- rowSums(unitsSoldData[2:length(unitsSoldData)], na.rm = TRUE)
unitsSoldTitles <- names(unitsSoldData[2:length(unitsSoldData)])
unitsSoldData$Week <- as.Date(cut(unitsSoldData$timestamp, breaks = "week", start.on.monday = FALSE)) + 6
unitsSoldData$Month <- as.Date(cut(unitsSoldData$timestamp, breaks = "month"))
unitsSoldData$Quarter <- as.Date(cut(unitsSoldData$timestamp, breaks = "quarter"))
unitsSoldData$Year <- as.Date(cut(unitsSoldData$timestamp, breaks = "year"))


######################################
######### Amazon Sales Rank ##########
######################################
salesRankData <- assembleSalesRankData(paste(dataDirectory, "salesRank", sep = ""), method = method)
salesRankData <- lapply(salesRankData, function(x) {
  x <- x[complete.cases(x), ]
  return(x)
})
salesRankData <- join_all(salesRankData, by = "timestamp", type = "full")
salesRankTitles <- names(salesRankData[2:length(salesRankData)])