library(shiny)
library(purrple)

shinyUI( 
  navbarPage( 
    div(img(src="thinkR1.png", height=30)) , selected = "Pixelize", theme = "style.css", 
             
    sidebarLayout(
      sidebarPanel(
        
        splitLayout(
          fileInput("file1", "Choose an image : ", accept = "image/*" ),
          sliderInput("size", "size (width and height) of pixels", min = 2, max = 100, value = 20)
        ),
        
        selectInput("db", label = "Tiles", choices = c("kittens", "puppies", "useR"), selected = "kittens"),
        
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
  
  )
)

