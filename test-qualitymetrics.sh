#!/bin/bash

# Set paths
scriptdir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

Rscript $scriptdir/qualitymetrics_wrapper.R dataMatrix_in "$scriptdir/test-data/input-dataMatrix.tsv" sampleMetadata_in "$scriptdir/test-data/input-sampleMetadata.tsv" variableMetadata_in "$scriptdir/test-data/input-variableMetadata.tsv" CV "FALSE" Compa "TRUE" seuil "1" poolAsPool1L "TRUE" sampleMetadata_out "$scriptdir/output-sampleMetadata.tsv" variableMetadata_out "$scriptdir/output-variableMetadata.tsv" || exit 1

diff $scriptdir/output-sampleMetadata.tsv $scriptdir/test-data/output-sampleMetadata.tsv || exit 2
diff $scriptdir/output-variableMetadata.tsv $scriptdir/test-data/output-variableMetadata.tsv || exit 2