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

include ../variables.Makefile

DIRNAME = common
DIRPATH = common
OCAMLFIND_OPTIONS = -package unix
PATH_TO_SRC = ..
# .ml sources (without paths!)
# Note from Olivier: env.ml must be first unless it's a mess!!
ML = 	env.ml \
	common.ml \
	commonXml.ml \
	xmlizable.ml \
	speaking.ml \
	defaultVisitor.ml \
	visitable.ml \
	learningObject.ml \
	dummyLearningObject.ml \
	learning.ml \
	expFunction.ml \
	expDerivate.ml
# .ml sources (with paths!)
ML_PATH = $(DIRPATH)/env.ml \
	$(DIRPATH)/common.ml \
	$(DIRPATH)/commonXml.ml \
	$(DIRPATH)/xmlizable.ml \
	$(DIRPATH)/speaking.ml \
	$(DIRPATH)/defaultVisitor.ml \
	$(DIRPATH)/visitable.ml \
	$(DIRPATH)/learningObject.ml \
	$(DIRPATH)/dummyLearningObject.ml \
	$(DIRPATH)/learning.ml \
	$(DIRPATH)/expFunction.ml \
	$(DIRPATH)/expDerivate.ml
# .mli sources (without paths!)
MLI = 	env.mli \
	common.mli \
	commonXml.mli \
	xmlizable.mli \
	speaking.mli \
	defaultVisitor.mli \
	visitable.mli \
	learningObject.mli \
	dummyLearningObject.mli \
	learning.mli \
	expFunction.mli \
	expDerivate.mli
# .mli sources (with paths!)
MLI_PATH = $(DIRPATH)/env.mli \
	$(DIRPATH)/common.mli \
	$(DIRPATH)/commonXml.mli \
	$(DIRPATH)/xmlizable.mli \
	$(DIRPATH)/speaking.mli \
	$(DIRPATH)/defaultVisitor.mli \
	$(DIRPATH)/visitable.mli \
	$(DIRPATH)/learningObject.mli \
	$(DIRPATH)/dummyLearningObject.mli \
	$(DIRPATH)/learning.mli \
	$(DIRPATH)/expFunction.mli \
	$(DIRPATH)/expDerivate.mli

include ../compilationUnit.Makefile

check:

clean-check:

include ../commonrules.Makefile
