library(shiny)
library(purrple)
library(collage)
library(magick)

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
    temp_image( collage_grid( source_image(), size = input$size) )
  })

  collage_image <- reactive({
    temp_image(collage( source_image(), size = input$size, tiles = base() ))
  })

  mask_image <- reactive({
    temp_image(collage_quality( source_image(), size = input$size, tiles = base() ))
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
  output$image <- renderJcropImage( collage_image() , opacity = .3, aspect_ratio = 1  )
  output$preview <- renderJcropImagePreview( JcropImagePreview("image", input$image_change) )

  output$grid_image <- renderFluidImage(grid_image())
  output$mask_image <- renderFluidImage(mask_image())

  output$collage_image <- renderFluidImage(collage_image())

})
