source("global.R")
library(shiny)
library(ggplot2)
library(scales)
library(reshape2)


TEMP_TEST <- TRUE



shinyServer(
  function(input, output) {
    
    ########################
    ### Units Sold Stuff ###
    ########################
    
    
    ########################
    ###       TEMP       ###
    ########################
    
    if (TEMP_TEST) {
      print("TESTING!")
      
      unitsSoldDataset <- reactive({
        ## subset by date
        dataout <- subset(unitsSoldData, 
                          Week.Ending >= input$dateRange[1] & Week.Ending <= input$dateRange[2],
                          select = c("Week.Ending", input$unitsSoldGroupBoxInput, "Week", "Month", "Quarter", "Year"))
        
        
        ## summarize based on user input :: Weekly sales, Monthly, Quarterly, Yearly
        switch(input$timeDivision,
               "Week" = {
                 dataout <- ddply(dataout, .(Week), numcolwise(function(x) {sum(x, na.rm = TRUE)}))
               },
               "Month" = {
                 dataout <- ddply(dataout, .(Month), numcolwise(function(x) {sum(x, na.rm = TRUE)}))
               },
               "Quarter" = {
                 dataout <- ddply(dataout, .(Quarter), numcolwise(function(x) {sum(x, na.rm = TRUE)}))
               },
               "Year" = {
                 dataout <- ddply(dataout, .(Year), numcolwise(function(x) {sum(x, na.rm = TRUE)}))
               })
        dataout <- melt(dataout, id = input$timeDivision)
        names(dataout)[1] <- "timestamp"
        dataout
      })
      
      
      ## Create the checkboxes and select them all by default
      output$unitsSoldGroupBoxInput <- renderUI({
        checkboxGroupInput("unitsSoldGroupBoxInput", "Choose books", 
                           choices  = names(unitsSoldData[2:(length(unitsSoldData)-5)]),
                           selected = NULL)
      })
      

      
      output$unitsSoldPlot <- renderPlot({
        p <- ggplot(unitsSoldDataset(), aes(x=as.Date(timestamp), y = value, fill = variable, group = variable))
        p <- p + geom_bar(stat = "identity")
        p <- p + scale_x_date(limits = c(input$dateRange[1], input$dateRange[2]))
        p
      })
    }
    
    output$unitsSoldSelectedRows <- renderPrint({
      if (is.null(input$unitsSold_brush$xmin)) return()
      
      selectedRows <- subset(unitsSoldDataset(),
                             timestamp >= as.Date(input$unitsSold_brush$xmin, 
                                                  origin = "1970-01-01") & timestamp <= as.Date(input$unitsSold_brush$xmax,
                                                                                                origin = "1970-01-01"))
      #sum(selectedRows[3], na.rm = TRUE)
      output <- ddply(selectedRows[2:3], .(variable), numcolwise(function(x) {sum(x, na.rm = TRUE)}))
      names(output) <- c("Book", "Units Sold")
      output <- data.frame(rbind(output, c("", sum(output[2]))))
      output
    })
    
    ########################
    ###     END TEMP     ###
    ########################
    
    
    if(!TEMP_TEST) {
      print("NOT TESTING")
      unitsSoldDataset <- reactive({
        ## subset by date
        dataout <- subset(unitsSoldData, 
                          Week.Ending >= input$dateRange[1] & Week.Ending <= input$dateRange[2],
                          select = c("Week.Ending", input$selectedBook, "Week", "Month", "Quarter", "Year"))
        
        
        ## summarize based on user input :: Weekly sales, Monthly, Quarterly, Yearly
        switch(input$timeDivision,
               "Week" = {
                 dataout <- ddply(dataout, .(Week), numcolwise(sum))
               },
               "Month" = {
                 dataout <- ddply(dataout, .(Month), numcolwise(sum))
               },
               "Quarter" = {
                 dataout <- ddply(dataout, .(Quarter), numcolwise(sum))
               },
               "Year" = {
                 dataout <- ddply(dataout, .(Year), numcolwise(sum))
               })
        dataout
      })
      
      output$unitsSoldPlot <- renderPlot({
        p <- ggplot(unitsSoldDataset(), 
                    aes_string(x = input$timeDivision,
                               y = paste("`", input$selectedBook, "`", sep="")))
        p <- p + geom_bar(stat = "identity")
        p
      })
    }
    

    
    ########################
    ### Sales Rank Stuff ###
    ########################
    
    salesRankDataset <- reactive({
      dataout <- subset(salesRankData, timestamp >= input$salesRankDateRange[1] & timestamp <= input$salesRankDateRange[2], 
                        select = c("timestamp", input$salesRankGroupBoxInput))
      melt(dataout, id = "timestamp")
    })
    
    output$salesRankPlot <- renderPlot({
      p <- ggplot(salesRankDataset(), aes(x=as.Date(timestamp), y = value, colour = variable, group = variable))
      p <- p + geom_line()
      p <- p + scale_x_date(limits = c(input$salesRankDateRange[1], input$salesRankDateRange[2]))
      p
    })
    
    ## Create the checkboxes and select them all by default
    output$salesRankGroupBoxInput <- renderUI({
      checkboxGroupInput("salesRankGroupBoxInput", "Choose books", 
                         choices  = names(salesRankData[2:length(salesRankData)]),
                         selected = NULL)
    })
  })