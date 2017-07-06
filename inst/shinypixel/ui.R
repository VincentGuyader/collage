library(shiny)
library(purrple)

page <- purrple::purrplePage(navbarPage)
shinyUI( 
  page( div(img(src="purrple.png", width=30), "Shiny Pixel") , selected = "Pixelize", theme = "style.css", 
             
  tabPanel("Pixelize",
    sidebarLayout(
      sidebarPanel(
        fileInput("file1", "Choose a jpg file : ", accept = "image/*" ),
        sliderInput("size", "size (width and height) of pixels", min = 2, max = 100, value = 10),
        fluidRow(
          column(6, fluidImageOutput("grid_image", height = 200 )),
          column(6, fluidImageOutput("mask_image", height = 200 ))
        ), 
        tags$br(), 
        JcropImagePreviewOutput("preview", width = "100%" )
      ),
      mainPanel(
        JcropImageOutput("image", height = "600px")
      )
    )
  ),
  
  tabPanel("Change database",
    sidebarLayout(
      sidebarPanel(
        selectInput("db", "Choose database : ", c("samples", "kittens" )),
        tags$strong("Number of images :"),
        textOutput("nbImages"), 
        br(), 
        textOutput("npages"), 
        htmlOutput("pages")
        
      ),
      mainPanel(
        htmlOutput( "base_images" )
      )
    )
  )
)
)

