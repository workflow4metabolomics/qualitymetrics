library(RUnit)

wrapperF <- function(argVc) {

    source("../QualityMetrics_script.R")
    source("../RcheckLibrary.R")
    source("../miniTools.R")

    args <- as.list(argVc)

#### Start_of_testing_code <- function() {}

    suppressMessages(library(ropls)) ## to be used in qualityMetricsF

    if(packageVersion("ropls") < "1.4.0")
        stop("Please use 'ropls' versions of 1.4.0 and above")

    if(length(args) < 9){ stop("NOT enough arguments !!!") }

    args$Compa <- as.logical(args$Compa)

    if("poolAsPool1L" %in% names(args)) {
        args$poolAsPool1L <- as.logical(args$poolAsPool1L)
    } else
        args$poolAsPool1L <- TRUE


    QualityControl(args$dataMatrix_in, args$sampleMetadata_in, args$variableMetadata_in,
                   args$CV, args$Compa, args$seuil, args$poolAsPool1L,
                   args$dataMatrix_out, args$sampleMetadata_out, args$variableMetadata_out, args$figure, args$information)

    rm(args)

#### End_of_testing_code <- function() {}

}

exaDirOutC <- "output"
stopifnot(file.exists(exaDirOutC))

tesArgLs <- list(input_default = c(CV = "FALSE",
                     Compa = "TRUE",
                     seuil = 1))

for(tesC in names(tesArgLs))
    tesArgLs[[tesC]] <- c(tesArgLs[[tesC]],
                          dataMatrix_in = file.path(unlist(strsplit(tesC, "_"))[1], "dataMatrix.tsv"),
                          sampleMetadata_in = file.path(unlist(strsplit(tesC, "_"))[1], "sampleMetadata.tsv"),
                          variableMetadata_in = file.path(unlist(strsplit(tesC, "_"))[1], "variableMetadata.tsv"),
                          dataMatrix_out = file.path(exaDirOutC, "dataMatrix.tsv"),
                          sampleMetadata_out = file.path(exaDirOutC, "sampleMetadata.tsv"),
                          variableMetadata_out = file.path(exaDirOutC, "variableMetadata.tsv"),
                          figure = file.path(exaDirOutC, "figure.pdf"),
                          information = file.path(exaDirOutC, "information.txt"))

for(tesC in names(tesArgLs)) {
    print(tesC)
    wrapperF(tesArgLs[[tesC]])
    if(tesC == "input_default") {
        samDF <- read.table(file.path(exaDirOutC, "sampleMetadata.tsv"),
                            header = TRUE,
                            row.names = 1,
                            sep = "\t",
                            stringsAsFactors = FALSE)
        stopifnot(checkEqualsNumeric(samDF["sam_44", "hotelling_pval"], 0.4655357, tolerance = 1e-6))
        varDF <- read.table(file.path(exaDirOutC, "variableMetadata.tsv"),
                            header = TRUE,
                            row.names = 1,
                            sep = "\t",
                            stringsAsFactors = FALSE)
        stopifnot(checkEqualsNumeric(varDF["met_033", "blankMean_over_sampleMean"], 0.004417387, tolerance = 1e-6))
    }
}

message("Checks successfully completed")
