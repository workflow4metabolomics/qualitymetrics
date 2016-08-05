## Metrics and graphics to assess the quality of the data 
#### A Galaxy module from the [Workflow4metabolomics](http://workflow4metabolomics.org) project

Status: [![Build Status](https://travis-ci.org/workflow4metabolomics/qualitymetrics.svg?branch=master)](https://travis-ci.org/workflow4metabolomics/qualitymetrics).

### Description

**Version:** 2.2.4  
**Date:** 2016-08-04  
**Author:** Marion Landi (INRA, PFEM), Mélanie Pétéra (INRA, PFEM), and Etienne A. Thévenot (CEA, LIST)  
**Email:** [melanie.petera(at)clermont.inra.fr](mailto:melanie.petera@clermont.inra.fr), [etienne.thevenot(at)cea.fr](mailto:etienne.thevenot@cea.fr)  
**Citation:**  
**Licence:** CeCILL  
**Reference history:** [W4M00001b_sacurine-complete](http://galaxy.workflow4metabolomics.org/history/list_published)   
**Funding:** Agence Nationale de la Recherche ([MetaboHUB](http://www.metabohub.fr/index.php?lang=en&Itemid=473) national infrastructure for metabolomics and fluxomics, ANR-11-INBS-0010 grant)  

### Installation

* Configuration file:
    + **qualitymetrics_config.xml**  
* Image files: 
    + **static/images/QualityControl.png**    
    + **static/images/qualitymetrics_workingExampleImage.png**      
* Wrapper file:
    + **qualitymetrics_wrapper.R**  
* Script file:
    + **qualitymetrics_script.R**  
* R packages  
    + **batch** from CRAN      
> install.packages("batch", dep=TRUE)    
    + **ropls** from Bioconductor  
> source("http://www.bioconductor.org/biocLite.R")  
> biocLite("ropls")      

### Tests

The code in the wrapper can be tested by running the **runit/qualitymetrics_runtests.R** R file 

### News

##### CHANGES IN VERSION 2.2.4  

INTERNAL MODIFICATION    

    o Additional running and installation tests added with planemo, conda, and travis  

##### CHANGES IN VERSION 2.2.3  

INTERNAL MODIFICATION    

    o Modifications of the 'qualitymetrics_script.R' file to handle the recent 'ropls' package versions (i.e. 1.3.15 and above) which use S4 classes  

    o Creating tests for the R code  
    
##### CHANGES IN VERSION 2.2.2

INTERNAL MODIFICATION  

    o Minor internal modification
    
***