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

# Prog. constants
argv <- commandArgs(trailingOnly = FALSE)
script.path <- sub("--file=","",argv[grep("--file=", argv)])
prog.name <- basename(script.path)

# Test Help
if (length(grep('-h', argv)) > 0) {
  cat("Usage: Rscript ", 
    prog.name,
    "{args} \n",
    "parameters: \n",
    "\t-h: display this help message and exit (optional) \n",
    "\tdataMatrix_in {file}: set the input data matrix file (mandatory) \n",
    "\tsampleMetadata_in {file}: set the input sample metadata file (mandatory) \n",
    "\tvariableMetadata_in {file}: set the input variable metadata_in file (mandatory) \n",
    "\tCV {bool}: set the \"Coefficient of Variation\" option (mandatory) \n",
    "\tCompa {val}: set the Compa option (mandatory) \n",
    "\tseuil {val}: set the seuil option (mandatory) \n",
    "\tpoolAsPool1L {val}: set the poolAsPool1L option (optional) \n",
    "\tsampleMetadata_out {file}: set the output sample metadata file (mandatory) \n",
    "\tvariableMetadata_out {file}: set the outputvariable metadata file (mandatory) \n",
    "\tfigure {file}: set the output figure file (mandatory) \n",
    "\tinformation {file}: set the output information file (mandatory) \n",
    "\n")
  quit(status = 0)
}

# Normal parameters reading
args = parseCommandArgs(evaluate=FALSE) #interpretation of arguments given in command line as an R list of objects

source_local <- function(...){
	argv <- commandArgs(trailingOnly = FALSE)
	base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
	for(i in 1:length(list(...))){source(paste(base_dir, list(...)[[i]], sep="/"))}
}
#Import the different functions
source_local("qualitymetrics_script.R", "easyrlibrary-lib/RcheckLibrary.R", "easyrlibrary-lib/miniTools.R")


suppressMessages(library(ropls)) ## to be used in qualityMetricsF

if(packageVersion("ropls") < "1.4.0")
    stop("Please use 'ropls' versions of 1.4.0 and above")

if(length(args) < 9){ stop("NOT enough arguments !!!") }

args$Compa <- as.logical(args$Compa)
args$poolAsPool1L <- as.logical(args$poolAsPool1L)

QualityControl(args$dataMatrix_in, args$sampleMetadata_in, args$variableMetadata_in,
               args$CV, args$Compa, args$seuil, args$poolAsPool1L,
               args$dataMatrix_out, args$sampleMetadata_out, args$variableMetadata_out, args$figure, args$information)

#QualityControl(ion.file.in, meta.samp.file.in, meta.ion.file.in,
#       CV, Compa, seuil,
#       ion.file.out, meta.samp.file.out, meta.ion.file.out)

#delete the parameters to avoid the passage to the next tool in .RData image
rm(args)

