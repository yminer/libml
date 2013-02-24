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

include ../../variables.Makefile

DIRNAME = init
DIRPATH = nn/init
OCAMLFIND_OPTIONS = -I ../../common -I ../networks
PATH_TO_SRC = ../..
# .ml sources (without paths!)
ML = initVisitor.ml \
	initMlpnnVisitor.ml \
	initMlpnnConstVisitor.ml \
	initTdnnVisitor.ml
# .ml sources (with paths!)
ML_PATH = $(DIRPATH)/initVisitor.ml \
	$(DIRPATH)/initMlpnnVisitor.ml \
	$(DIRPATH)/initMlpnnConstVisitor.ml \
	$(DIRPATH)/initTdnnVisitor.ml
# .mli sources (without paths!)
MLI = initVisitor.mli
# .mli sources (with paths!)
MLI_PATH = $(DIRPATH)/initVisitor.mli

include ../../compilationUnit.Makefile

check:
	@echo " + making $@, testing the networks initialization visitors ..."
	@$(MAKE) byte
	@echo " + Compiling the check program ..."
	@$(MAKE) check.cmo
	$(OCAMLFIND) ocamlc -o check_prgm ../libml.cma check.cmo
	@echo " Running the check program ..."
	@echo
	./check_prgm
	@echo
	@echo " Test successfull."

clean-check:
	@echo " + making $@ in xml ..."
	$(RM) ./check_prgm check.cm[i,o]

include ../../commonrules.Makefile
