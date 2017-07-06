library(shiny)
library(purrple)
library(htmltools)

thinkr_link <- function(){
  absolutePanel( # class = "panel panel-default panel-side",
    style = "z-index: 1000",
    fixed = TRUE, draggable = TRUE,
    top  = 10, left = "auto", right = 20,

    width = "250px",
    div(
      tags$a( href = "http://www.thinkr.fr", tags$img(src="thinkR1.png", height = "30px", id = "logo") ),
      tags$a( href = "https://github.com/ThinkRstat/collage", tags$img(src="https://cdn0.iconfinder.com/data/icons/octicons/1024/mark-github-256.png", height = "30px") ),
      tags$a( href = "https://twitter.com/thinkR_fr", tags$img(src="https://cdn3.iconfinder.com/data/icons/social-icons-5/128/Twitter.png", height = "30px") ),
      tags$a( href = "https://www.facebook.com/ThinkR-1776997009278055/", tags$img(src="https://cdn4.iconfinder.com/data/icons/social-messaging-ui-color-shapes-2-free/128/social-facebook-circle-128.png", height = "30px") )
    )

  )
}

shinyUI(
  fluidPage( theme = "style.css",

    tags$script( '$( function(){ $("#logo").hover( function(){ sound  = new Audio("purr.mp3")  ; sound.play() ; }) ; }) ;' ),

    thinkr_link(),

    sidebarLayout(
      sidebarPanel(

        splitLayout(
          fileInput("file1", "Choose an image : ", accept = "image/*" ),
          sliderInput("lines", "number of lines", min = 10, max = 200, value = 20)
        ),

        splitLayout(
          selectInput("db", label = "Tiles", choices = c("kittens", "puppies", "useR"), selected = "kittens"),
          actionButton("go", label = "Update" )
        ),

        fluidRow(
          column(6, fluidImageOutput("grid_image", height = 200 )),
          column(6, fluidImageOutput("mask_image", height = 200 ))
        ),
        tags$br(),
        JcropImagePreviewOutput("preview", width = "100%" )
      ),
      mainPanel(
        br(), br(), br(),
        JcropImageOutput("image", height = "600px")
      )
    )

  )
)
