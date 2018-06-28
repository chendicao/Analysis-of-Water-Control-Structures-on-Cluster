#!/bin/bash 

singularity exec /opt/beocat/containers/openfoam-v1712.img /bin/bash <<EOF
.  /opt/OpenFOAM/setImage_v1712.sh


foamCleanTutorials
rm -rf constant/triSurface/*.eMesh
rm -rf 0 log* constant/extend* processor*

EOF

