source("global.R")
library(shiny)
library(ggplot2)
library(scales)

shinyUI(
  fluidPage(
    
    # Application title
    titlePanel("Lauren Layne"),
    
    tabsetPanel(type = "tabs", 
                tabPanel("Units Sold", plotOutput("unitsSoldPlot",
                                                  click = clickOpts(id = "unitsSold_click"),
                                                  hover = hoverOpts(id = "unitsSold_hover"),
                                                  brush = brushOpts(id = "unitsSold_brush", fill = "#ccc", direction = "x")
                                                  ),
                         fluidRow(
                           column(4,
                                  #selectInput("selectedBook", "Books:", unitsSoldTitles)
                                  ##########
                                  ## TEMP ##
                                  ##########
                                  uiOutput("unitsSoldGroupBoxInput")
                                  ##########
                                  ## TEMP ##
                                  ##########
                           ),
                           column(4,
                                  dateRangeInput("dateRange", "Date Range:",
                                                 start = min(unitsSoldData$Week.Ending))
                           ),
                           column(4, 
                                  selectInput("timeDivision", "Time Division:",
                                              c("Weekly" = "Week",
                                                "Monthly" = "Month",
                                                "Quarterly" = "Quarter",
                                                "Yearly" = "Year")
                                  )
                           )
                         ),
                         fluidRow(
                           verbatimTextOutput("unitsSoldSelectedRows")
                         )
                ), 
                
                
                
                tabPanel("Amazon Sales Rank", plotOutput("salesRankPlot"),
                         fluidRow(
                           column(3,
                                  dateRangeInput("salesRankDateRange", "Date Range:", 
                                                 start = min(salesRankData$timestamp))
                           ),
                           column(3,
                                  uiOutput("salesRankGroupBoxInput")
                           )
                         )
                ),
                
                
                
                tabPanel("Cross Correlations", plotOutput("correlationsPlots"),
                         fluidRow(
                           column(3,
                                  uiOutput("")
                           )
                         )
                )
    )
  )
)