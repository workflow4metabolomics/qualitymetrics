Tool: Quality Metrics

I. Date: 2015-03-18

II. Authors and maintainer:

	Authors: Etienne Thevenot (1), Marion Landi (2), and Melanie Petera (2)
	
	(1) MetaboHUB Paris, CEA
	(2) MetaboHUB Clermont-Ferrand, INRA
	
	Maintainer: Etienne Thevenot (etienne.thevenot@cea.fr)

III. Funding

	Developed within MetaboHUB, The French Infrastructure in Metabolomics and Fluxomics (www.metabohub.fr/en)

IV. Usage restrictions

	Use of this tool is restricted to the service conditions of the MetaboHUB-IFB infrastructures.
	For any question regarding the use of these services, please contact: etienne.thevenot@cea.fr
	
V. Requirements

	The 'ropls' R package is required

VI. Installation

	7 files are required for installation:

	1) 'README.txt'
		Instructions for installation
   
	2) 'qualityMetrics_config.xml'
		Configuration file; to be put into the './galaxy-dist/tools' directory ('Quality Control' session)
		 
	3) 'qualityMetrics_wrapper.R'
		Wrapper code written in R aimed at launching the qualityMetrics_script.R given the arguments entered by the user through the Galaxy interface

	4) 'qualityMetrics_script.R'
		R code containing the computational functions
		
	5) 'ropls_0.10.16.tar.gz'
         Source code of the ropls package; to be installed with the 'install.packages' R command
		 This package is for installation of the Galaxy module on the Workflow4metabolomics.org and must not be distributed without the author agreement
		
	6) and 7) 'qualityMetrics_workflowPositionImage.png' and 'qualityMetrics_workingExampleImage.png'
		Images for the help section of the tool main page (as indicated in the 'qualityMetrics_config.xml' file); to be put into the './galaxy-dist/static/images/' directory		 

VII. License

	CeCILL
