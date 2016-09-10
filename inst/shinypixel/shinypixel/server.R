require(shiny)
require(shinyFiles)
require(tipixel)
# source("tools.R")
shinyServer(function(input, output,session) {
  volumes <- c('home'="/mnt/docs/big/Vincent/")
  volumes <- c('wd'='.')
  volumes <- c('wd'='/')
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
  # output$jpeg <- renderImage(as.character(parseFilePaths(volumes, input$file)$datapath))


  # output$jpeg <- renderImage({
  #   # When input$n is 1, filename is ./images/image1.jpeg
  #   filename <- as.character(parseFilePaths(volumes, input$file)$datapath)
  #
  #   # Return a list containing the filename
  #   list(src = filename)
  # }, deleteFile = FALSE)


  #   output$jpeg <- renderUI({
  #   img(src = normalizePath(as.character(parseFilePaths(volumes, input$file)$datapath)), width = 100)
  # })
  #
  #   output$picture<-renderText({c('<img src="',normalizePath(as.character(parseFilePaths(volumes, input$file)$datapath)),'">')})
  #
  #
    output$myImage <- renderImage({
      # A temp file to save the output.
      # This file will be removed later by renderImage
      outfile <- tempfile(fileext='.png')

      # Generate the PNG
      png(outfile)
      normalizePath(as.character(parseFilePaths(volumes, input$file)$datapath))->chemin
       plotraster(aperm(jpeg::readJPEG(chemin),c(2,1,3))) # on affiche cette image



      # hist(rnorm(input$obs), main="Generated in renderImage()")
      dev.off()

      # Return a list containing the filename
      list(src = outfile,
           contentType = 'image/png',
           width = 400,
           height = 300,
           alt = "This is alternate text")
    }, deleteFile = FALSE)

    output$selectUI_a <- renderUI({
      selectInput("nom_base_a", "Selectionner la base", liste_unebase())
    })
    output$selectUI_b <- renderUI({
      selectInput("nom_base", "Selectionner la base", liste_unebase())
    })
    cur_val <- ""

    observe({
      print("tu m vois ?")
      print(input$nom_base_a)
      if (!is.null(input$nom_base_a)){
      if (cur_val != input$nom_base_a){
        # updateSelectInput(session, "nom_base", NULL, input$nom_base_a)
        updateSelectInput(session, "nom_base",selected = input$nom_base_a)


        cur_val <<- input$nom_base_a
      }}
    })

    observe({
      if (!is.null(input$nom_base)){
      if (cur_val != input$nom_base){
        # updateSelectInput(session, "nom_base_a", NULL, input$nom_base)
        updateSelectInput(session, "nom_base_a",
                          label = "plop",
                          # choices = s_options,
                          selected = input$nom_base
        )
        cur_val <<- input$nom_base
      }}
    })




    # output$nb_tuiles <-      renderText(paste("Nombre de pixel",input$n_col*input$n_row))
    #
    # output$nb_tuiles <-      renderText(paste("Nombre de pixel",calc_dim(col=input$n_col,
    #                                                                      lig=input$n_row,
    #                                                                      redim=eval(parse(text=paste0(input$nom_base,"$redim"))),
    #                                                                      dim= dim(jpeg::readJPEG(normalizePath(as.character(parseFilePaths(volumes, input$file)$datapath))))
    #                                                                      ))
    #                                     )


    output$nb_tuiles <-      renderText({
      if (is.null(input$file)){
      paste("Nombre de pixel",input$n_col*input$n_row)
      }else{
        cat("input$nom_base",input$nom_base,"\n")

        cat("input$nom_base_a",input$nom_base_a,"\n")

        paste("Nombre de pixel",calc_dim(col=input$n_col,
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
        # file=chemin,
        chemin=as.character(parseDirPath(volumes, input$base)),
        redim=c(input$redim1,input$redim2),
        # lig=as.numeric(input$n_row),
        # col=as.numeric(input$n_col),
        # base=eval(parse(text=input$nom_base)),
        preload = is.element("preload",input$options_base),
        recursive = is.element("recursive",input$options_base),
        # doublon = is.element("doublon",input$options),
        verbose = is.element("verbose",input$options_base)
        )
      ll<-liste_unebase()
      cat("avant",ll,"\n")
        # assign(make.names(paste("base",Sys.time(),sep="_")),a,envir = .GlobalEnv)
     # NOM<- make.names(paste("base",Sys.time(),sep="_"))
     NOM <- input$nom_creation_base
        assign(NOM,a,envir = .GlobalEnv)
      # output$selectUI_a <- renderUI({
      #   selectInput("nom_base_a", "Selectionner la base", )
      # }) # ou putot un update ICI sera BCP PLUS PROPRE TODO
      ll<-liste_unebase()
      cat("apres",ll,"\n")
      print(ll)
      updateSelectInput(session, "nom_base",choices = ll)
      updateSelectInput(session, "nom_base_a",choices = ll)

    })


    observeEvent(input$export_base, {
      print("on exporte la base FUCK YEAH")
      print(input$nom_base)
print(as.character(parseSavePath(volumes, input$export_base)$datapath))

print(
todo<-paste0("saveRDS(",input$nom_base,",file='"
      ,as.character(parseSavePath(volumes, input$export_base)$datapath),"')")
)
do(todo)



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

    })



    observeEvent(input$go, {
      #
      print(input$nom_base)
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
        target=target)
          for (i in 1:3) {
            progress$set(value = i)
            Sys.sleep(0.1)
          }

      }else{
        message("veuillez selectionner une image")
      }


      })

  })
