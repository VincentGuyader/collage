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
    file1 <- input$file1
    path <- if(is.null( file1 )) {
      system.file( "tigrou", "tigrou.jpg", package = "collage" )
    } else {
      file1$datapath
    }
    withProgress(min = 0, max = 1, message = "reading image", value = .3, {
      image_read(path)
    })

  })

  size <- reactive({
    lines_cut( source_image(), n = input$lines )
  })

  grid_image   <- reactive( {
    withProgress(min = 0, max = 1, message = "grid", value = .3, {
      temp_image( collage_grid( source_image(), size = size() ) )
    })
  })

  collage_image <- reactive({
    withProgress(min = 0, max = 1, message = "collage", value = .3, {
      temp_image( collage( source_image(), size = size(), tiles = base() ))
    })
  })

  mask_image <- reactive({
    withProgress(min = 0, max = 1, message = "mask", value = .3, {
      temp_image(collage_quality( source_image(), size = size(), tiles = base() ))
    })
  })

  base <- reactive({
    switch( input$db,
      puppies = puppies,
      kittens = kittens,
      useR    = useR2017,
      emojis  = emojis
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

  output$dl <- downloadHandler(
    filename = function() {
      collage_image()
    },
    content = function(con) {
      file.copy(collage_image(), con)
    },
    contentType = "image/png"
  )


})
