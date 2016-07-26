## Metrics and graphics to assess the quality of the data 
#### A Galaxy module from the [Workflow4metabolomics](http://workflow4metabolomics.org) project

### Description

**Version:** 2.2.2  
**Date:** 2016-03-04  
**Author:** Marion Landi (INRA, PFEM), Mélanie Pétéra (INRA, PFEM), and Etienne A. Thévenot (CEA, LIST)  
**Email:** [melanie.petera(at)clermont.inra.fr](mailto:melanie.petera@clermont.inra.fr), [etienne.thevenot(at)cea.fr](mailto:etienne.thevenot@cea.fr)  
**Citation:**  
**Licence:** CeCILL  
**Reference history:** [W4M00001b_sacurine-complete](http://galaxy.workflow4metabolomics.org/history/list_published)   
**Funding:** Agence Nationale de la Recherche ([MetaboHUB](http://www.metabohub.fr/index.php?lang=en&Itemid=473) national infrastructure for metabolomics and fluxomics, ANR-11-INBS-0010 grant)  

### Installation

* Configuration file:
    + **QualityMetrics_config.xml**  
* Image files: 
    + **static/images/QualityControl.png**    
    + **static/images/QualityMetrics_workingExampleImage.png**      
* Wrapper file:
    + **QualityMetrics_wrapper.R**  
* Script file:
    + **QualityMetrics_script.R**  
* R packages  
    + **batch** from CRAN      
> install.packages("batch", dep=TRUE)    
    + **ropls** from Bioconductor  
> source("http://www.bioconductor.org/biocLite.R")  
> biocLite("ropls")      

### Tests

The code in the wrapper can be tested by running the **tests/qualityMetrics_tests.R** in R  

### News

##### CHANGES IN VERSION 2.2.2

INTERNAL MODIFICATION  

    o Minor internal modification
    
***