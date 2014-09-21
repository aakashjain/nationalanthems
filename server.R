require(shiny)
require(httr)
require(rCharts)
require(rjson)

shinyServer(function(input, output) {
  output$text <- renderText({
    paste('Top artists for', input$country)
  })
  plotdata <- reactive({
    request <- POST('http://ws.audioscrobbler.com/2.0/',
                    body=list(method='geo.getTopArtists', api_key='4d1e099188a7028fad88d7bd0ac7353d',
                              country=input$country, limit=as.character(input$limit), format='json'),
                    encode='form')
    stop_for_status(request)
    data <- content(request, 'parsed', 'application/json')
    temp <- matrix(nrow=0, ncol=2)
    for(i in 1:input$limit) {
      a <- data$topartists$artist[[i]]$name
      l <- data$topartists$artist[[i]]$listeners
      temp <- rbind(temp, c(a, l))
    }
    data <- as.data.frame(temp, stringsAsFactors=FALSE)
    colnames(data) <- c('Artist', 'Listeners')
    data
  })
  output$plot <- renderChart2({
    plot <- dPlot(y='Artist', x='Listeners', groups='Artist', data=plotdata(), type='bar')
    plot$xAxis(type='addMeasureAxis', outputFormat='#,')
    plot$yAxis(type='addCategoryAxis')
    plot
  })
})