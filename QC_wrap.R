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
source_local("RcheckLibrary.R")


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
