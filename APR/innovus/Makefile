#####################################
# By BriMonzZY APR script           #
#####################################

help:
	@echo "make clean_all"
	@echo "make pnr_gui : open innovus gui"

.PHONY: clean_all

clean_all:
	rm -rf data/*
	rm -rf reports/*
	rm -rf work/*
	rm -rf logs/*

pnr_help:
	make -f ./scripts/Makefile.pnr help

# open innovus gui
pnr_gui:
	cd work && innovus |& tee -i ../logs/$@.log

# init and floorplan
pnr_init:
	rm -rf work/make/init
	rm -rf reports/init/*
	cd work && make -f ../scripts/Makefile.pnr init

# pnr_floorplan:
# 	rm -rf reports/floorplan/*
# 	cd work && innovus -64 -init ../scripts/floorplan_atomic.tcl -log ../logs/$@.log

pnr_place:
	rm -rf work/make/place
	rm -rf reports/place/*
	cd work && make -f ../scripts/Makefile.pnr place

pnr_cts:
	rm -rf work/make/cts
	rm -rf reports/cts/*
	cd work  &&   make -f ../scripts/Makefile.pnr cts

pnr_postcts_hold:
	rm -rf work/make/postcts_hold
	rm -rf reports/postcts_hold/*
	cd work  &&   make -f ../scripts/Makefile.pnr postcts_hold

pnr_route:
	rm -rf work/make/route
	rm -rf reports/route/*
	cd work  &&   make -f ../scripts/Makefile.pnr route
