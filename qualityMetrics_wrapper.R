#!/usr/bin/Rscript --vanilla --slave --no-site-file


library(batch) ## parseCommandArgs

source_local <- function(fname){
    argv <- commandArgs(trailingOnly = FALSE)
    base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
    source(paste(base_dir, fname, sep="/"))
}

source_local("qualityMetrics_script.R")


rssVsGalL <- FALSE

if(rssVsGalL) { ## for running with R outside the Galaxy environment during development of the script

    ## 'example' input dir
    exaDirInpC <- "example/input"

    argLs <- list(dataMatrix_in = file.path(exaDirInpC, "dataMatrix.tsv"),
                  sampleMetadata_in = file.path(exaDirInpC, "sampleMetadata.tsv"),
                  variableMetadata_in = file.path(exaDirInpC, "variableMetadata.tsv"))

    ## 'example' output dir
    exaDirOutC <- gsub("input", "output", exaDirInpC)

    argLs <- c(argLs,
               list(dataMatrix_out = file.path(exaDirOutC, "dataMatrix.tsv"),
                    sampleMetadata_out = file.path(exaDirOutC, "sampleMetadata.tsv"),
                    variableMetadata_out = file.path(exaDirOutC, "variableMetadata.tsv"),
                    figure = file.path(exaDirOutC, "figure.pdf"),
                    information = file.path(exaDirOutC, "information.txt")))

    stopifnot(file.exists(exaDirOutC))

} else
    argLs <- parseCommandArgs(evaluate=FALSE)


##------------------------------
## Initializing
##------------------------------

## options
##--------

strAsFacL <- options()$stringsAsFactors
options(stringsAsFactors = FALSE)

## libraries
##----------

library(ropls)

## constants
##----------

modNamC <- "Quality Metrics" ## module name

## log file
##---------

sink(argLs[["information"]])

cat("\nStart of the '", modNamC, "' Galaxy module call: ",
    format(Sys.time(), "%a %d %b %Y %X"), "\n", sep="")

## loading
##--------

datMN <- t(as.matrix(read.table(argLs[["dataMatrix_in"]],
                                check.names = FALSE,
                                header = TRUE,
                                row.names = 1,
                                sep = "\t")))

samDF <- read.table(argLs[["sampleMetadata_in"]],
                    check.names = FALSE,
                    header = TRUE,
                    row.names = 1,
                    sep = "\t")

varDF <- read.table(argLs[["variableMetadata_in"]],
                    check.names = FALSE,
                    header = TRUE,
                    row.names = 1,
                    sep = "\t")

## checking
##---------

if(packageVersion("ropls") < "0.10.16")
    cat("\nWarning: new version of the 'ropls' package is available\n", sep="")


##------------------------------
## Computation
##------------------------------


resLs <- qualityMetricsF(datMN = datMN,
                         samDF = samDF,
                         varDF = varDF,
                         fig.pdfC = argLs[["figure"]])
samDF <- resLs[["samDF"]]
varDF <- resLs[["varDF"]]


##------------------------------
## Ending
##------------------------------


## saving
##-------

datDF <- cbind.data.frame(dataMatrix = colnames(datMN),
                          as.data.frame(t(datMN)))
write.table(datDF,
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

## closing
##--------

cat("\nEnd of '", modNamC, "' Galaxy module call: ",
    as.character(Sys.time()), "\n", sep = "")

sink()

options(stringsAsFactors = strAsFacL)

rm(list = ls())
