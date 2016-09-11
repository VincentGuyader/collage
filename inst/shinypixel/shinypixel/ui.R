require(shiny)
if( !require(shinyFiles, quietly = TRUE) ){
  install.packages( "shinyFiles")
  require(shinyFiles)
}

shinyUI(pageWithSidebar(
  headerPanel(
    'Tipixel GUI'
  ),
  sidebarPanel(
    tabsetPanel(
      tabPanel("Choisir les images",
               tags$br(),

               shinyFiles::shinyFilesButton('file', 'Choix de l\'image en entrée', 'Please select a file', FALSE),
               shinyFiles::shinySaveButton('save', 'Choix de l\'image en sortie', 'Save file as...', filetype=list(picture=c('jpeg', 'jpg'))),

               htmlOutput("selectUI_a"),


               numericInput("n_col",
                            label = h3("nombre de colonnes"),
                            value = 42,min=0)   ,
               numericInput("n_row",
                            label = h3("nombre de lignes"),
                            value = 42,min=0),

               # ici on met le nombre total d tuiles

               h3(textOutput("nb_tuiles")),
               checkboxGroupInput("options",
                                  label = h3("options"),
                                  choices = list("ouvre le fichier de sortie" = "open",
                                                 "autoriser les doublons" = "doublon",
                                                 "verbose" = "verbose",
                                                 "parallel"  = "parallel"


                                                 ),
                                  selected = c("open","doublon","verbose")),
               numericInput("thread",
                            label = h3("nombre de thread"),
                            value = 2,min=1)



               ),
      tabPanel("Gestion des bases",

               tags$h3("Construire une base"),
               textInput("nom_creation_base", "Nom de la base crée:", make.names(paste("NEW_base",Sys.time(),sep="_"))),

               shinyDirButton('base', 'creer une nouvelle base', 'Please select a folder'),
               actionButton("demo","JE VEUX DES CHATONS"),
                              numericInput("redim1",
                            label = h3("hauteur des tuiles en px"),
                            value = 25,min=1)   ,
               numericInput("redim2",
                            label = h3("largeur des tuiles en px"),
                            value = 25,min=1),
               checkboxGroupInput("options_base",
                                  label = h3("options"),
                                  choices = list("parcourir les sous dossiers" = "recursive",
                                                 "précharge les images" = "preload",
                                                 "verbose" = "verbose"),
                                  selected = c("recursive","preload")),


               tags$p(),
               htmlOutput("selectUI_b"),
               shinySaveButton('export_base', 'exporter la base', 'Save file as...', filetype=list(RDS=c('RDS'))),

               shinyFilesButton('import_base', 'Importer une base', 'Please select a file', FALSE),
               textInput("nom_import_base", "Nom de la base importée:", make.names(paste("base",Sys.time(),sep="_")))




               )
    ),

       actionButton("go","Lancer")



    ),
  mainPanel(
    verbatimTextOutput('filepaths'),
    verbatimTextOutput('savefile'),
    verbatimTextOutput('directorypath'),
    verbatimTextOutput('export_base'),
    verbatimTextOutput('import_base'),
        # uiOutput('jpeg'),
    # htmlOutput("picture"),
    imageOutput("myImage")
      # ,
    # imageOutput("myImage",height = 500)
    )
  ))
