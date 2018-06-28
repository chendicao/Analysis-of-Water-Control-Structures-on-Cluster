#!/bin/bash 
#SBATCH --job-name=opfile1_8C32G_auto_e1

#SBATCH --mem-per-cpu=32G   # Memory per core, use --mem= for memory per node
#SBATCH --time=02:00:00   # Use the form DD-HH:MM:SS
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8

#SBATCH --mail-user=caocd@ksu.edu
#SBATCH --mail-type=ALL   # same as =BEGIN,FAIL,END

#need to change following line to load module in your cluster
singularity exec /opt/beocat/containers/openfoam-v1712.img /bin/bash <<EOF
.  /opt/OpenFOAM/setImage_v1712.sh

#OpenFOAM code begain here 
#------------------------------------------------------------------------------
foamVersion="OpenFOAM-5.x"


#------------------------------------------------------------------------------
foamCleanTutorials
rm -rf constant/triSurface/*.eMesh
rm -rf 0 log* constant/extend* processor*

#------------------------------------------------------------------------------
echo -e "\n Start meshing "
#-------------------------------------------------------------------------------
start_time=`date +%s`
#start_time=`date +%s`

#------------------------------------------------------------------------------
echo -e "   - Create background mesh"
ideasUnvToFoam cad/backgroundMeshBig.unv  > logFile


#------------------------------------------------------------------------------
echo -e "   - Change one boundary name (from old versions, depreciated)"
sed 's/outletGroovy/outlet/' constant/polyMesh/boundary -i


#------------------------------------------------------------------------------
echo -e "   - Meshing with snappyHexMesh"
snappyHexMesh -overwrite >> logFile


#------------------------------------------------------------------------------
echo -e "   - Extrude one patch to make a 2D mesh"
extrudeMesh  >> logFile


#------------------------------------------------------------------------------
echo -e "   - Change patch type in the boundary file" 
changeDictionary  >> logFile


#------------------------------------------------------------------------------
echo -e "\n - End Meshing\n "
#-------------------------------------------------------------------------------



#------------------------------------------------------------------------------
echo -e "   - Copy 0.orig to 0"
rm -r 0
cp -r 0.orig 0


#------------------------------------------------------------------------------
echo -e "   - Set field"
setFields > logSolver


#------------------------------------------------------------------------------
echo -e "   - Decompose the mesh"
decomposePar >> logSolver


#------------------------------------------------------------------------------
echo -e "   - Start simulation (approximately 10 - 30 minutes)"
mpirun -np 8 interFoam -parallel >> logSolver


#------------------------------------------------------------------------------
echo -e "   - Simulation ended\n\n"
end_time=`date +%s`
echo Total execution time was `expr $end_time - $start_time` s.


#------------------------------------------------------------------------------
#echo -e "   - Reconstruct partition\n\n"
#mpirun -np 2 reconstructPar -parallel >> logSolver

#end_time=`date +%s`
#echo Total execution time was `expr $end_time - $start_time` s.
#OpenFOAM code end here 
EOF