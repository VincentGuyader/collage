library(shiny)
library(purrple)
library(tipixel)
library(magick)

progress_shiny <- function (session, message){
  p <- NULL
  list(
    init = function(n){
      p <<- Progress$new( session, min = 0, max = n )
      p$set(0, message = message)
    },
    step = function() {
      p$set( p$getValue() + 1 )
    },
    term = function(){
      p$close()
    }
  )
}

temp_image <- function(img){
  tf <- tempfile( fileext = ".png")
  image_write(img, tf)
  tf
}

shinyServer(function(input, output, session) {

  source_image <- reactive( {
    req(input$file1)
    image_read(input$file1$datapath)
  })


  grid_image   <- reactive( {
    temp_image( pixel_grid( source_image(), size = input$size) )
  })

  pixel_image <- reactive({
    temp_image(pixel_replace( source_image(), size = input$size, tiles = base() ))
  })

  mask_image <- reactive({
    temp_image(pixel_quality( source_image(), size = input$size, tiles = base() ))
  })

  base <- reactive({
    switch( input$db, 
      puppies = puppies, 
      kittens = kittens, 
      useR    = useR2017
    )
  })

  baseSummary <-  reactive({
    nrow(base()$base)
  })
  output$image <- renderJcropImage( pixel_image() , opacity = .3, aspect_ratio = 1  )
  output$preview <- renderJcropImagePreview( JcropImagePreview("image", input$image_change) )

  output$grid_image <- renderFluidImage(grid_image())
  output$mask_image <- renderFluidImage(mask_image())

  output$pixel_image <- renderFluidImage(pixel_image())
  
})
