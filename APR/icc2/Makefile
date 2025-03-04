
help:
	echo "make pre"

## make ndm => gen the ndm
pre: ndm nlib dlib

ndm:
	icc2_lm_shell -f scripts/run_icc2_initial.tcl

## make lib => gen the lib 
nlib:
	icc2_shell -f scripts/run_icc2_savelib.tcl

## make lib => gen the dlib 
dlib:
	icc2_shell -f scripts/run_icc2_genlib.tcl



