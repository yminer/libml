################################################################
# [LibML - Machine Learning Library]
# http://libml.org
# Copyright (C) 2002 - 2003  LAGACHERIE Matthieu RICORDEAU Olivier
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. This
# program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details. You should have
# received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
# USA.

# SPECIAL NOTE (the beerware clause):
# This software is free software. However, it also falls under the beerware
# special category. That is, if you find this software useful, or use it
# every day, or want to grant us for our modest contribution to the
# free software community, feel free to send us a beer from one of
# your local brewery. Our preference goes to Belgium abbey beers and
# irish stout (Guiness for strength!), but we like to try new stuffs.

# Authors:
# Matthieu LAGACHERIE
# E-mail : matthieu@libml.org

# Olivier RICORDEAU
# E-mail : olivier@libml.org

################################################################

# name of the compiled bytecode .cma lib (without path)
CMA = lib$(DIRNAME).cma
# name of the compiled bytecode .cma lib (with path)
CMA_PATH = $(DIRPATH)/lib$(DIRNAME).cma
# compiled native code .cmx files (without path)
CMX = $(ML:.ml=.cmx)
# compiled native code .cmx files (with path)
CMX_PATH = $(ML_PATH:.ml=.cmx)
# compiled interfaces .cmi files (without path)
CMI = $(MLI:.mli=.cmi)
# compiled interfaces .cmi files (with path)
CMI_PATH = $(MLI_PATH:.mli=.cmi)
# compiled bytecode .cmo files (without path)
CMO = $(ML:.ml=.cmo)

# main target
#############

_all_real: $(BYTE) $(OPT)

all:
	@echo " + making $(BYTE) $(OPT) in $(DIRNAME) ..."
	$(MAKE) _all_real
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

re:
	@echo " + making $@ in $(DIRNAME) ..."
	$(MAKE) clean all
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

$(CMI): $(MLI)
$(CMO): $(ML)

# bytecode and native-code compilation
######################################

$(BYTE): interface
	@echo " + making byte in $(DIRNAME) ..."
	$(MAKE) lib$(DIRNAME).cma
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

$(OPT): interface
	@echo " + making opt in $(DIRNAME) ..."
	$(MAKE) $(CMX)
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

interface:
	@echo " + making $@ in $(DIRNAME) ..."
	$(MAKE) interface_real
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

interface_real: $(CMI)

lib$(DIRNAME).cma: $(CMO)
	@echo " + building $@ (bytecode library) in $(DIRNAME) ..."
	$(OCAMLFIND) $(OCAMLC) $(CMO) $(BFLAGS) $(BLFLAGS) -o $@

# clean
#######

clean:
	@echo " + making $@ in $(DIRNAME) ..."
	$(RM) *.cm[iox] *.o lib$(DIRNAME).cma
	@$(MAKE) clean-check clean-basic
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

dist-clean distclean:
	echo " + making $@ in $(DIRNAME) ..."
	$(MAKE) clean
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

clean-cvs: clean-cvs-default
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

sources-dump:
	@echo -n " $(ML_PATH)" >> $(PATH_TO_SRC)/.all_ml
	@echo -n " $(MLI_PATH)" >> $(PATH_TO_SRC)/.all_mli
	@echo -n " $(CMA_PATH)" >> $(PATH_TO_SRC)/.all_cma
	@echo -n " $(CMX_PATH)" >> $(PATH_TO_SRC)/.all_cmx
	@echo -n " $(CMI_PATH)" >> $(PATH_TO_SRC)/.all_cmi
	@echo -n " -I $(DIRPATH)" >> $(PATH_TO_SRC)/.ocamldoc_includes
	@if [ "$(SUBDIRS)" != "" ]; then \
	for i in $(SUBDIRS); \
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done;\
	fi;

# if preprocessing files have been removed, rebuild them remotely
preprocessing: $(PATH_TO_SRC)/preprocessing/.timestamp
	$(MAKE) -C $(DIRPATH) all


# Variable dependent generic rules.
###################################

.SUFFIXES: .mli .ml .cmi .cmo .cmx .mll .mly .tex .dvi .ps .html

.mli.cmi:
	@echo "   building $@ ..."
	$(OCAMLFIND) $(OCAMLC) \
	-c $(BFLAGS) $< $(OCAMLFIND_OPTIONS)
#	$(OCAMLFIND) $(OCAMLC) -pp "camlp4o $(PATH_TO_SRC)/preprocessing.cmo" \


# note: preprocessing is currently disabled because it generates a stack
# overflow during its execution. Investigation in progress.
.ml.cmo:
	@echo "   building $@ ..."
	$(OCAMLFIND) $(OCAMLC) \
	-c $(BFLAGS) $< $(OCAMLFIND_OPTIONS)
#	 -pp "camlp4o $(PATH_TO_SRC)/preprocessing.cmo"

.ml.cmx:
	@echo "   building $@ ..."
	$(OCAMLFIND) $(OCAMLOPT) -ffast-math -inline 100 \
	-c $(OFLAGS) $< $(OCAMLFIND_OPTIONS)
#	-pp "camlp4o $(PATH_TO_SRC)/preprocessing.cmo"
