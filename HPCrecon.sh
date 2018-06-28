#!/bin/bash 

singularity exec /opt/beocat/containers/openfoam-v1712.img /bin/bash <<EOF
.  /opt/OpenFOAM/setImage_v1712.sh
start_time=`date +%s`
echo -e "   - Reconstruct partition\n\n"
reconstructPar >> logSolver
end_time=`date +%s`
echo Total execution time was `expr $end_time - $start_time` s.
EOF

