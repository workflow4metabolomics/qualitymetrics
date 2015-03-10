#!/usr/bin/Rscript --vanilla --slave --no-site-file

################################################################################################
# WRAPPER FOR QC_script.R (ANALYSES FOR QUALITY CONTROL)                                       #
#                                                                                              #
# Author: Melanie PETERA based on Marion LANDI's filters' wrapper                              #
# User: Galaxy                                                                                 #
# Original data: used with QC_script.R                                                         #
# Starting date: 04-09-2014                                                                    #
# V-1: Restriction of old filter wrapper to quality control (CV)                               #
#                                                                                              #
#                                                                                              #
# Input files: dataMatrix.txt ; sampleMetadata.txt ; variableMetadata.txt                      #
# Output files: dataMatrix.txt ; sampleMetadata.txt ; variableMetadata.txt                     #
#                                                                                              #
################################################################################################


library(batch) #necessary for parseCommandArgs function
args = parseCommandArgs(evaluate=FALSE) #interpretation of arguments given in command line as an R list of objects

source_local <- function(fname){
	argv <- commandArgs(trailingOnly = FALSE)
	base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
	source(paste(base_dir, fname, sep="/"))
}
#Import the different functions
source_local("QC_script.R")
#source("/usr/local/share/R/QC_script.R")


if(length(args) < 9){ stop("NOT enough arguments !!!") }


args$Compa <- as.logical(args$Compa)


QualityControl(args$dataMatrix_in, args$sampleMetadata_in, args$variableMetadata_in,
       args$CV, args$Compa, args$seuil,
       args$dataMatrix_out, args$sampleMetadata_out, args$variableMetadata_out)

#QualityControl(ion.file.in, meta.samp.file.in, meta.ion.file.in,
#       CV, Compa, seuil,
#       ion.file.out, meta.samp.file.out, meta.ion.file.out)

#delete the parameters to avoid the passage to the next tool in .RData image
rm(args)





## Etienne Thevenot
## March 10, 2015

if(FALSE) {

    runExampleL <- FALSE

    if(runExampleL) {

        ##------------------------------
        ## Example of arguments
        ##------------------------------

        ## prefix file in
        pfxFilInpC <- "input/sacuri_"
        ## pfxFilInpC <- gsub("sacuri", "suvimax", pfxFilInpC) ## 'suvimax' dataset
        ## pfxFilInpC <- gsub("sacuri", "bisphenol", pfxFilInpC) ## 'bisphenol' dataset

        argLs <- list(dataMatrix_in = paste0(pfxFilInpC, "dataMatrix.tsv"),
                      sampleMetadata_in = paste0(pfxFilInpC, "sampleMetadata.tsv"),
                      variableMetadata_in = paste0(pfxFilInpC, "variableMetadata.tsv"))

        ## prefix file out
        pfxFilOutC <- gsub("input", "output",
                           gsub("dataMatrix.tsv", "", argLs[["dataMatrix_in"]]))
        ## "output/sacuri_"

        argLs <- c(argLs,
                   list(dataMatrix_out = paste0(pfxFilOutC, "dataMatrix.tsv"),
                        sampleMetadata_out = paste0(pfxFilOutC, "sampleMetadata.tsv"),
                        variableMetadata_out = paste0(pfxFilOutC, "variableMetadata.tsv"),
                        figure = paste0(pfxFilOutC, "figure.pdf"),
                        information = paste0(pfxFilOutC, "information.txt")))

        stopifnot(file.exists("output"))

    }

    ##------------------------------
    ## Options
    ##------------------------------


    strAsFacL <- options()$stringsAsFactors
    options(stringsAsFactors = FALSE)


    ##------------------------------
    ## Libraries
    ##------------------------------


    library(batch) ## parseCommandArgs
    source_local <- function(fname){
        argv <- commandArgs(trailingOnly = FALSE)
        base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
        source(paste(base_dir, fname, sep="/"))
    }
    source_local("QC_script.R")

    library(ropls)


    ##------------------------------
    ## Functions
    ##------------------------------


    flagF <- function(tesC,
                      typC = c("stp", "wrn"),
                      funC = NA,
                      envC = topEnvC,
                      txtC = NA) { ## management of warning and error messages

        tesL <- eval(parse(text = tesC), envir = envC)

        if(typC == "stp" && !tesL) {

            if(!is.null(argLs[["information"]]))
                sink(NULL)

            stop(paste(tesC, " is FALSE", ifelse(!is.na(txtC), paste(": ", txtC, sep = ""), ""), sep = ""),
                 call. = FALSE)

        } else if(typC == "wrn"){

            flagC <- paste(flagC,
                           paste("Warning: ", txtC, sep = ""),
                           "\n",
                           sep = "")

            assign("flagC", flagC, envir = topEnvC)

        }

    } ## flagF


    ##------------------------------
    ## Constants
    ##------------------------------


    topEnvC <- environment()
    flagC <- "\n"


    ##------------------------------
    ## Script
    ##------------------------------

    if(!runExampleL)
        argLs <- parseCommandArgs(evaluate=FALSE)

    sink(argLs[["information"]])


    ## Loading
    ##---------------------

    datDF <- read.table(argLs[["dataMatrix_in"]],
                        check.names = FALSE,
                        header = TRUE,
                        sep = "\t")
    datVarNamC <- colnames(datDF)[1]
    rownames(datDF) <- datDF[, 1]
    datMN <- t(as.matrix(datDF[, -1]))

    samDF <- read.table(argLs[["sampleMetadata_in"]],
                        check.names = FALSE,
                        header = TRUE,
                        sep = "\t")
    samNamC <- colnames(samDF)[1]
    rownames(samDF) <- samDF[, 1]
    samDF <- samDF[, -1, drop = FALSE]

    varDF <- read.table(argLs[["variableMetadata_in"]],
                        check.names = FALSE,
                        header = TRUE,
                        sep = "\t")
    varNamC <- colnames(varDF)[1]
    rownames(varDF) <- varDF[, 1]
    varDF <- varDF[, -1, drop = FALSE]

    ## Checking arguments
    ##---------------------

    flagF("identical(rownames(datMN), rownames(samDF))", "stp", txtC = "Sample names (or number) in the data matrix (first row) and sample metadata (first column) are not identical")
    flagF("identical(colnames(datMN), rownames(varDF))", "stp", txtC = "Variable names (or number) in the data matrix (first column) and sample metadata (first column) are not identical")


    ## Computation
    ##-------------


    sink(NULL)

    varDF <- qualityControlF(datMN = datMN,
                             samDF = samDF,
                             varDF = varDF,
                             fig.pdfC = argLs[["figure"]],
                             log.txtC = argLs[["information"]])

    sink(argLs[["information"]], append = TRUE)


    ## Saving
    ##---------------------


    datMN <- cbind.data.frame(dataMatrix = colnames(datMN),
                              as.data.frame(t(datMN)))
    write.table(datMN,
                file = argLs[["dataMatrix_out"]],
                row.names = FALSE,
                sep = "\t")

    samDF <- cbind.data.frame(sampleMetadata = rownames(samDF),
                              samDF)
    write.table(samDF,
                file = argLs[["sampleMetadata_out"]],
                quote = FALSE,
                row.names = FALSE,
                sep = "\t")

    varDF <- cbind.data.frame(variableMetadata = rownames(varDF),
                              varDF)
    write.table(varDF,
                file = argLs[["variableMetadata_out"]],
                quote = FALSE,
                row.names = FALSE,
                sep = "\t")


    ## Ending
    ##---------------------

    cat("\nEnd of 'univariate' Galaxy module call: ", as.character(Sys.time()), "\n", sep = "")

    sink(NULL)

    options(stringsAsFactors = strAsFacL)

    rm(list = ls())

}
