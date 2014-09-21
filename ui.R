require(shiny)
require(httr)
require(rCharts)
require(rjson)

codes <- as.character(read.csv('countrycodes.csv')$country)

shinyUI(fluidPage(
  titlePanel("Music Artist Popularity"),
  sidebarLayout(
    sidebarPanel(width=3,
                 p('This webapp shows you the most popular artists during the last week 
                    in each country, as evidenced by records of users on the music-centric 
                    social network', a('Last.FM.', href='http://www.last.fm/')),
                 p('Data is requested live from the Last.FM API. ISO3166-1 country names
                   taken from', a('https://github.com/pudo-attic/lobbytransparency')), br(),
                 helpText('Select a country from the list and the number of top artists
                           from the slider to see a popularity plot. You can hover over each
                          bar to see the exact number of listeners.'),
                 selectInput('country', 'Country', codes, selected='United States'),
                 sliderInput('limit', 'Number of Artists', min=10, max=50, value=20)),
    mainPanel(h3(textOutput('text')), showOutput('plot', 'dimple'))
    )
  )
)