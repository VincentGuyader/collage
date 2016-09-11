require(shiny)
require(shinyFiles)
require(tipixel)
# source("tools.R")
shinyServer(function(input, output,session) {
  volumes <- c('home'="/mnt/docs/big/Vincent/")
  volumes <- c('wd'='.')
  volumes <- c('wd'='/mnt/docs/big/chaton/')
  shinyFileChoose(input, 'file', roots=volumes)
  output$filepaths <- renderPrint({parseFilePaths(volumes, input$file)})

  shinyFileChoose(input, 'import_base', roots=volumes)
  output$import_base <- renderPrint({parseFilePaths(volumes, input$import_base)})

  shinyFileSave(input, 'save', roots=volumes)
  output$savefile <- renderPrint({parseSavePath(volumes, input$save)})


  shinyFileSave(input, 'export_base', roots=volumes)
  output$export_base <- renderPrint({parseSavePath(volumes, input$export_base)})


  shinyDirChoose(input, 'base', roots=volumes)
  output$directorypath <- renderPrint({parseDirPath(volumes, input$base)})

    output$myImage <- renderImage({
# TODO tropompliqué pour ce que c est
      print("le renderImage principal")
      outfile <- tempfile(fileext='.png')
      png(outfile)
      normalizePath(as.character(parseFilePaths(volumes, input$file)$datapath))->chemin
      cat("chemin",chemin,"\n")
      if (length(chemin)!=0){
       plotraster(aperm(jpeg::readJPEG(chemin),c(2,1,3))) # on affiche cette image
      }
      dev.off()
      # Return a list containing the filename
      list(src = outfile,
           contentType = 'image/png',
           width = 400,
           height = 300,
           alt = "choisissez une image d'entrée")
    }, deleteFile = FALSE)


    print("VOILA LA ON LANCE LE TRUC")


  YOP = reactive({


        print("actioncar changment col")

liste_unebase()
  })




    output$selectUI_a <- renderUI({
      selectInput("nom_base_a", "Selectionner la base", YOP())
    })
    output$selectUI_b <- renderUI({
      selectInput("nom_base", "Selectionner la base", YOP())
    })
    cur_val <- ""

    observe({
      print("modif de nom_base_a")
      print(input$nom_base_a)
      if (!is.null(input$nom_base_a)){
      if (cur_val != input$nom_base_a){
        # updateSelectInput(session, "nom_base", NULL, input$nom_base_a)
        updateSelectInput(session, "nom_base",
                          choices = NULL,
                          selected = input$nom_base_a)


        cur_val <<- input$nom_base_a
      }}
    })

    observe({
      print("modif de nom_base")
      if (!is.null(input$nom_base)){
      if (cur_val != input$nom_base){
        # updateSelectInput(session, "nom_base_a", NULL, input$nom_base)
        updateSelectInput(session, "nom_base_a",
                          # label = "plop",
                          choices = NULL,
                          selected = input$nom_base
        )
        cur_val <<- input$nom_base
      }}
    })




    output$nb_tuiles <-      renderText({
      print("mise a jour nombre tuiles")

      print(str(input$nom_base_a))
      print(str(input$nom_base))
      # des fois "" des fois null
      if (is.null(input$nom_base_a)){
        paste("Nombre de pixel :",input$n_col*input$n_row)
      }else if (is.null(input$file) | input$nom_base_a==""){
      paste("Nombre de pixel :",input$n_col*input$n_row)
      }else{
        cat("input$nom_base",input$nom_base,"\n")

        cat("input$nom_base_a",input$nom_base_a,"\n")

        paste("Nombre de pixel :",calc_dim(col=input$n_col,
                                         lig=input$n_row,
                                         redim=eval(parse(text=paste0(input$nom_base_a,"$redim"))),
                                         dim= dim(jpeg::readJPEG(normalizePath(as.character(parseFilePaths(volumes, input$file)$datapath))))
        ))

      }
      })


    observeEvent(input$base, {
      print("mode base activé")
      print(input$base)
      print(parseDirPath(volumes, input$base))
      print(as.character(parseDirPath(volumes, input$base)))
      a<-genere_base(
        chemin=as.character(parseDirPath(volumes, input$base)),
        redim=c(input$redim1,input$redim2),
        preload = is.element("preload",input$options_base),
        recursive = is.element("recursive",input$options_base),
        verbose = is.element("verbose",input$options_base)
        )
      ll<-liste_unebase()
      cat("avant",ll,"\n")
       NOM <- input$nom_creation_base
        assign(NOM,a,envir = .GlobalEnv)
      ll<-liste_unebase()
      cat("apres",ll,"\n")
      print(ll)
      updateSelectInput(session, "nom_base",choices = ll)
      updateSelectInput(session, "nom_base_a",choices = ll)

      # obigé de bouriner le update du dessus n 'est pas stage et selectUI_a oit etre modifie en dur
      output$selectUI_a <- renderUI({
        selectInput("nom_base_a", "Selectionner la base",ll)
      })
      output$selectUI_b <- renderUI({
        selectInput("nom_base", "Selectionner la base", ll)
      })
    })


    observeEvent(input$export_base, {
      print("on exporte la base FUCK YEAH")
      print(str(input$nom_base))
print(as.character(parseSavePath(volumes, input$export_base)$datapath))


if(exists(input$nom_base)){

  print(
    todo<-paste0("saveRDS(",input$nom_base,",file='"
                 ,as.character(parseSavePath(volumes, input$export_base)$datapath),"')")
  )
do(todo)
}


})


    observeEvent(input$import_base, {
      print("on importe une base")
      print(input$nom_import_base)
      # print(as.character(parseSavePath(volumes, input$imp)$datapath))
      as.character(parseFilePaths(volumes, input$import_base)$datapath)
      print(
        todo<-paste0(input$nom_import_base," <<- readRDS(file='"
                     ,as.character(parseFilePaths(volumes, input$import_base)$datapath),"')")
      )
      do(todo)

      ll<-liste_unebase()
      updateSelectInput(session, "nom_base",choices = ll)
      updateSelectInput(session, "nom_base_a",choices = ll)
      # obigé de bouriner le update du dessus n 'est pas stage et selectUI_a oit etre modifie en dur
      output$selectUI_a <- renderUI({
        selectInput("nom_base_a", "Selectionner la base",ll)
      })
      output$selectUI_b <- renderUI({
        selectInput("nom_base", "Selectionner la base", ll)
      })

    })



    observeEvent(input$go, {
      print("GOOOOO")
      print(input$nom_base)
      print(input$nom_base_a)
      LABASE <-input$nom_base
      if (is.null(LABASE)){
        LABASE <-input$nom_base_a
      }


      print(input$n_col)
      print(input$n_row)

      fichier <- as.character(parseFilePaths(volumes, input$file)$datapath)
      print(fichier)
      target <- as.character(parseSavePath(volumes, input$save)$datapath)
      print(target)
      if (length(target)==0){
        target <- tempfile(fileext = ".jpg")

      }

      if (length(fichier)!=0){

        # PROGRESS BAR
        progress <- shiny::Progress$new(session, min=1, max=15)
        on.exit(progress$close())

            progress$set(message = 'Calculation in progress',
                         detail = 'This may take a while...')



          pixel(
        # file=chemin,
        file=fichier,
            lig=as.numeric(input$n_row),
            col=as.numeric(input$n_col),
            base=eval(parse(text=LABASE)),
        open = is.element("open",input$options),
        affich = is.element("open",input$options),
        doublon = is.element("doublon",input$options),
        verbose = is.element("verbose",input$options),
        target=target,
        paralell = is.element("paralell",input$options),
        thread=as.numeric(input$thread))
          for (i in 1:3) {
            progress$set(value = i)
            Sys.sleep(0.1)
          }

      }else{
        message("veuillez selectionner une image")
      }


      })



    observeEvent(input$demo, {
      print("on charge la demo")
print(liste_unebase())
      # base <- file.path(find.package('tipixel'),'base')
      # img <- sample(list.files(base,full.names = TRUE),1)
      # plotraster(aperm(jpeg::readJPEG(img),c(2,1,3)))
      # les_tuiles <<- genere_base(base,redim=c(25,25))
      #
      #
      # ll<-liste_unebase()
      # print(ll)
      # updateSelectInput(session, "nom_base",choices = ll,selected = "les_tuiles")
      # updateSelectInput(session, "nom_base_a",choices = ll,selected = "les_tuiles")
      # shiny::updateNumericInput(session,"n_col",value = 50)
      # shiny::updateNumericInput(session,"n_row",value = 50)


base <- paste0(file.path(find.package('tipixel'),'base'),"/basechaton.RDS")
chatons <<- readRDS(base)

ll<-liste_unebase()
print(ll)
updateSelectInput(session, "nom_base",choices = ll,selected = "chatons")
updateSelectInput(session, "nom_base_a",choices = ll,selected = "chatons")

    })


  })
