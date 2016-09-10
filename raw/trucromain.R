library(shiny)
library(plyr)
progress_shiny <-function (progress, step = 1){
  list(
    init = function(n){},
    step = function() {
      progress$set( progress$getValue() + step )
    }, 
    term = function(){}
  )
}
function_I_cant_edit <- function(){plyr::llply(LETTERS ,.fun=function(x){Sys.sleep(0.2)},.progress = "text")}

server<-shinyServer(function(input, output,session) {
  
  observeEvent(input$go, {
    progress <- shiny::Progress$new(session, min=0, max=50)
    on.exit(progress$close())
    
    # use the main progress outside of llply 
    progress$set( value = 1,message = 'Calculation in progress')
    # progress$set(message = 'Calculation in progress')
    # Sys.sleep( 1 )
    # progress$set( value = 20 )
    
    # then pass it along so that llply steps 
    # contribute to the main progress
    llply(LETTERS ,.fun=function(x){
      Sys.sleep(0.2)
    }, .progress = progress_shiny(progress))
    })
  output$plot <- renderPlot({
    plot(cars)
  })
})

ui <- basicPage(
  actionButton("go","PUSH ME"),
  plotOutput("plot")
  
)
shinyApp(ui = ui, server = server)