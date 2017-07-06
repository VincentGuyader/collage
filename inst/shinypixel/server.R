library(shiny)
library(purrple)
library(tipixel)
library(plyr)
library(magick)
library(magrittr)

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
    temp_image(show_grid( source_image(), size = input$size) )
  })

  pixel_image <- reactive({
    temp_image(pixelize( source_image(), size = input$size, base = base() ))
  })

  mask_image <- reactive({
    temp_image(show_base_quality( source_image(), size = input$size, base = base() ))
  })

  base <- reactive({
    switch (input$db,
      "kittens" = kittens, "samples" = base_samples
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
  output$nbImages <- renderText(baseSummary())

  output$base_images <- renderUI({
    base <- base()
    read <- base$read

    page <- input$page
    if( is.null(page) ) page <- 1
    if( (page-1)*200 > length(read) ) page <- 1

    start <- 1 + 200*(page-1)
    end   <- min( start + 200, length(read) )

    imgs <- llply( start:end , function(i){
      tf <- tempfile()
      image_read( read[[i]] ) %>% image_write(tf)
      data <- session$fileUrl( i, file = tf, contentType = "image/jpeg")
      r <- as.integer( base$base$R[i])
      g <- as.integer( base$base$G[i])
      b <- as.integer( base$base$B[i])
      col <- sprintf( "rgb(%d, %d, %d)", r, g, b )

      div(
        div( "&nbsp;",  height = 50 , style = sprintf( "background-color: %s; color: %s", col, col ) ),
        img( src = data, width = 50, style = "float: left" ),
        style = "padding: 4px; float: left; "
      )

    }, .progress =  progress_shiny(session, message = "rendering base" ))
    imgs <- append( imgs, list(style = "float: left") )

    do.call( div, imgs )

  })

  output$npages <- renderText({
    pages <- ceiling( length( base()$read ) / 200 )
    sprintf( "%d pages", pages )
  })

  output$pages <- renderUI({
    pages <- round( length( base()$read ) / 200 )

    links <- llply( seq_len(pages), function(i){
      tags$button( i, onclick = sprintf( 'Shiny.onInputChange( "page", %d ) ', i ), style = "margin: 2px; width: 40px" )
    })
    do.call( div, links )
  })
  
  
})
