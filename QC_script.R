################################################################################################
# ANALYSES FOR QUALITY CONTROL                                                                 #
#                                                                                              #
# Author: Melanie PETERA                                                                       #
# User: Galaxy                                                                                 #
# Starting date: 04-09-2014                                                                    #
# V-1.0: Restriction of old filter script to CV filter                                         #
#                                                                                              #
#                                                                                              #
# Input files: dataMatrix ; sampleMetadata ; variableMetadata                                  #
# Output files: dataMatrix ; sampleMetadata ; variableMetadata                                 #
#                                                                                              #
################################################################################################

# Parameters (for dev)
if(FALSE){
  
  ion.file.in <- "test/ressources/inputs/ex_data_IONS.txt"  #tab file
  meta.samp.file.in <- "test/ressources/inputs/ex_data_PROTOCOLE1.txt"  #tab file
  meta.ion.file.in <- "test/ressources/inputs/ex_data_METAION.txt"  #tab file
  
  ion.file.out <- "test/ressources/outputs/ex_data_IONS_fl.txt"  #tab file
  meta.samp.file.out <- "test/ressources/outputs/ex_data_PROTOCOLE1_fl.txt"  #tab file
  meta.ion.file.out <- "test/ressources/outputs/ex_data_METAION_fl.txt"  #tab file
  
  CV <- TRUE ; if(CV){Compa<-TRUE;seuil<-1.25}else{Compa<-NULL;seuil<-NULL}

}

QualityControl <- function(ion.file.in, meta.samp.file.in, meta.ion.file.in,
                   CV, Compa, seuil,
                   ion.file.out, meta.samp.file.out, meta.ion.file.out){
  # This function allows to analyse data to check its quality 
  # It needs 3 datasets: the data matrix, the variables' metadata, the samples' metadata. 
  # It generates 3 new datasets corresponding to the 3 inputs with additional columns. 
  #
  # Parameters:
  # - xxx.in: input files' names
  # - xxx.out: output files' names
  # - CV: CV filter yes/no
  # | > Compa: filter comparing pool and sample CVs (TRUE) or according to pool CV (FALSE)
  # | > seuil: maximum ratio tolerated between pool and sample CVs or maximum pool CV
  
  
# Input --------------------------------------------

ion.data <- read.table(ion.file.in,sep="\t",header=TRUE)
meta.samp.data <- read.table(meta.samp.file.in,sep="\t",header=TRUE)
meta.ion.data <- read.table(meta.ion.file.in,sep="\t",header=TRUE)

# Error vector
err.stock <- "\n"


# Function 1: CV filter ---------------------------
# Allows to filter ions according to the Coefficient of Variation (CV):
# Compa=TRUE:
# 	CV of pools and CV of samples are compared ; if the ration between pools' one
# 	and samples' one is higher than a given ration, corresponding ion is deleted. 
# Compa=FALSE:
# 	only CV of pools are considered ; when the CV is higher than a given threshold,
# 	corresponding ion is deleted. 
if(CV){
  
  # Checking the sampleType variable
  if(is.null(meta.samp.data$sampleType)){
    err.stock <- c(err.stock,"\n-------",
                   "\nWarning : no 'sampleType' variable detected in sample meta-data !",
                   "\nCV will not be tested.\n-------\n")
  }else{
    if(!("pool"%in%levels(factor(meta.samp.data$sampleType)))){
      err.stock <- c(err.stock,"\n-------",
                     "\nWarning : no 'pool' detected in 'sampleType' variable (sample meta-data) !",
                     "\nCV will not be tested.\n-------\n")
    }else{
      if((!("sample"%in%levels(factor(meta.samp.data$sampleType))))&(Compa)){
        err.stock <- c(err.stock,"\n-------",
                       "\nWarning : no 'sample' detected in 'sampleType' variable (sample meta-data) !",
                       "\nCV will not be tested.\n-------\n")
      }else{
  
  # Statement
  tmp.ion <- data.frame(CV.ind=rep(NA,nrow(ion.data)),CV.samp=rep(NA,nrow(ion.data)),
                        CV.pool=rep(NA,nrow(ion.data)),ion.data,stringsAsFactors=FALSE)
  # CV samples
  tmp.samp <- which(colnames(tmp.ion)%in%meta.samp.data[which(meta.samp.data$sampleType=="sample"),1])
  tmp.ion$CV.samp <- apply(tmp.ion[,tmp.samp],1,sd) / rowMeans(tmp.ion[,tmp.samp])
  # CV pools
  tmp.samp <- which(colnames(tmp.ion)%in%meta.samp.data[which(meta.samp.data$sampleType=="pool"),1])
  tmp.ion$CV.pool <- apply(tmp.ion[,tmp.samp],1,sd) / rowMeans(tmp.ion[,tmp.samp])
  # CV indicator
  if(Compa){tmp.ion$CV.ind <- ifelse((tmp.ion$CV.pool)/(tmp.ion$CV.samp)>seuil,0,1)
  }else{tmp.ion$CV.ind <- ifelse((tmp.ion$CV.pool)>seuil,0,1)}
  # filter and storage ion.data
  tmp.ion <- tmp.ion[which(tmp.ion$CV.ind==1),]
  ion.data <- tmp.ion[,-c(1:3)]
  rownames(ion.data) <- NULL
  # filter and storage meta.ion.data
  meta.ion.data <- meta.ion.data[which(meta.ion.data[,1]%in%ion.data[,1]),]
  rownames(meta.ion.data) <- NULL
  
  rm(tmp.ion,tmp.samp)
  
      }}}
  
} # end if(CV)




# Output -------------------------------------------

# Error checking
if(length(err.stock)>1){
  stop(err.stock)
}else{

write.table(ion.data, ion.file.out, sep="\t", row.names=FALSE, quote=FALSE)
write.table(meta.samp.data, meta.samp.file.out, sep="\t", row.names=FALSE, quote=FALSE)
write.table(meta.ion.data, meta.ion.file.out, sep="\t", row.names=FALSE, quote=FALSE)

}


} # end of QualityControl function


# Typical function call
# QualityControl(ion.file.in, meta.samp.file.in, meta.ion.file.in,
#       CV, Compa, seuil,
#       ion.file.out, meta.samp.file.out, meta.ion.file.out)

