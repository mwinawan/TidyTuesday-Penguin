#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(tidyverse)


penguins <- read_csv("penguins.csv")
glimpse(penguins)


selectInput01 <- function(id, sel) {
    selectInput(id, 
                label = id, 
                choices = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm",
                            "body_mass_g"),
                selected = sel)
}

selectInput02 <- function(id, sel) {
    selectInput(id, 
                label = id, 
                choices = unique(penguins$species),
                selected = sel,
                multiple = TRUE)
}


selectInput03 <- function(id, sel) {
    selectInput(id, 
                label = id, 
                choices = unique(penguins$sex),
                selected = sel,
                multiple = TRUE)
}


selectInput04 <- function(id, sel) {
    selectInput(id, 
                label = id, 
                choices = unique(penguins$year),
                selected = sel,
                multiple = TRUE)
}


selectInput05 <- function(id, sel) {
    selectInput(id, 
                label = id, 
                choices = unique(penguins$island),
                selected = sel,
                multiple = TRUE)
}



library(shiny)
library(shinydashboard)


ui <- dashboardPage(
    dashboardHeader(title = "EDA - Penguins"),
    dashboardSidebar(
        width = 250,
        selectInput01("X", "bill_length_mm"),
        selectInput01("Y", "bill_depth_mm"),
        selectInput02("Species", "Adelie"),
        selectInput03("Sex", "female"),
        selectInput04("Year", 2007),
        selectInput05("Island", "Torgersen")    
    ),
    dashboardBody(
        fluidRow(
            "EDA Plot",
            plotOutput("plot_eda")
        )
    )
)




server <- function(input, output) {

    data1 <- reactive({
        req(input$Species)
    })
    
    data2 <- reactive({
        req(input$Sex)
    })
    
    data3 <- reactive({
        req(input$Year)
    })
    
    data4 <- reactive({
        req(input$Island)
    })
    
    # make plots
    output$plot_eda <- renderPlot({
        ggplot(data = penguins %>% filter(species %in% data1(),
                                          sex %in% data2(),
                                          year %in% data3(),
                                          island %in% data4()), 
               aes_string(x = input$X, y = input$Y)) +
            geom_point()}, 
        res = 96) 
    }

# Run the application 
shinyApp(ui = ui, server = server)
