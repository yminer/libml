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

include ./variables.Makefile


# main target
#############

DIRNAME = src
DOCPATH = ../doc

OCAMLFIND_OPTIONS = -package unix

SUBDIRS = common \
	nn \
	expert-systems \
	wrappers

all: $(NAME).cma $(NAME).cmxa
	@$(MAKE) -C server all
	@$(MAKE) -C mlrc all

# recompiles everything from scratch
re: clean all

# bytecode and native-code compilation
######################################

_byte-recursive:
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i byte ) || exit 1 ;\
	done

_opt-recursive:
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i opt ) || exit 1 ;\
	done

_all-recursive:
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i all ) || exit 1 ;\
	done

$(NAME).cma: _byte-recursive sources-dump
	@echo " + building $@ in $(DIRNAME) ..."
	$(OCAMLFIND) $(OCAMLC) `cat .all_cma` $(BLFLAGS) -o $@ $(OCAMLFIND_OPTIONS)

$(NAME).cmxa: _opt-recursive sources-dump
	@echo " + building $@ in $(DIRNAME) ..."
	$(OCAMLMKLIB) `cat .all_cmx` -o $(NAME)

$(BYTE): $(NAME).cma

$(OPT): $(NAME).cmxa

interface:
	@echo " + making $@ in $(DIRNAME) ..."
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i $@ ) || exit 1;\
	done

# install / uninstall
#####################

install: 
	@echo " + installing LibML ..."
	@echo " + running ocamlfind library installation ..."
	files=$$( \
	    for f in `cat .all_cmi` `cat .all_mli` `cat .all_cmx` $(NAME).cma $(NAME).cmxa $(NAME).a ./META; do \
	        if [ -f "$$f" ]; then echo $$f; fi; \
	    done; \
        ) && \
	$(OCAMLFIND) install $(NAME) $$files
	@$(MAKE) -C $(DOCPATH) $@

uninstall:
	@echo " + uninstalling LibML ..."
	@echo " + running ocamlfind library uninstallation ..."
	$(OCAMLFIND) remove $(NAME)
	@$(MAKE) -C $(DOCPATH) $@

# documentation
###############

.PHONY: doc

# path from html output dir to style sheet
CSS_FILE = ../style.css

_doc-html: sources-dump
	@echo " + generating html code documentation ..."
	@mkdir -p $(DOCPATH)/html
	$(OCAMLDOC) -html `cat .all_ml` `cat .all_mli` \
	-css-style $(CSS_FILE) -all-params -d $(DOCPATH)/html \
	-t "$(NAME) code documentation" `cat .ocamldoc_includes`

_doc-ps-pdf: sources-dump
	@echo " + generating ps and pdf code documentation ..."
	@$(RM) -R $(TMP)
	@mkdir -p $(TMP)
	$(OCAMLDOC) -latex `cat .all_ml` `cat .all_mli` \
	-o $(TMP)/$(NAME)_code_documentation.tex \
	-t "$(NAME) code documentation" `cat .ocamldoc_includes`
	( cd $(TMP) && \
	latex $(NAME)_code_documentation.tex && \
	latex $(NAME)_code_documentation.tex && \
	$(DVIPS) $(NAME)_code_documentation.dvi -o $(NAME)_code_documentation.ps && \
	$(DVIPDF) $(NAME)_code_documentation.dvi $(NAME)_code_documentation.pdf )
	cp $(TMP)/$(NAME)_code_documentation.{ps,pdf} $(DOCPATH)
	@$(RM) -R $(TMP)

_doc-structure: sources-dump
	@echo " + generating ps and pdf library structure representation ..."
	@$(RM) -R $(TMP)
	@mkdir -p $(TMP)
	@$(OCAMLDOC) -dot `cat .all_ml` `cat .all_mli` -o $(TMP)/graph.dot \
	-dot-include-all -dot-reduce -t "$(NAME) structure" \
	`cat .ocamldoc_includes`
	@( export DOTFONTPATH=/usr/share/fonts/truetype/freefont/ && \
	dot -Tps -Gfontname=FreeSerif -Nfontname=FreeSerif \
	-Efontname=FreeSerif -o $(DOCPATH)/$(NAME)_structure.ps \
	$(TMP)/graph.dot )
	@$(RM) -R $(TMP)
	@ps2pdf $(DOCPATH)/$(NAME)_structure.ps \
	$(DOCPATH)/$(NAME)_structure.pdf

doc: all
	@echo " + making $@ in $(DIRNAME)"
	@$(MAKE) _doc-html
	@$(MAKE) _doc-ps-pdf
	@$(MAKE) _doc-structure

# clean	
#######

clean: clean-default
	@echo " + making $@ in $(DIRNAME) ..."
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done
	@$(MAKE) -C server $@
	@$(MAKE) -C mlrc $@
	@$(MAKE) -C preprocessing $@

clean-default: clean-basic
	@$(RM) *.cm[iox] *.o .all_{cma,cmi,cmx,ml,mli} .ocamldoc_includes

clean-doc:
	@echo " + making $@ in $(DIRNAME) ..."
	@$(RM) -R $(DOCPATH)/html
	@$(RM) $(DOCPATH)/$(NAME)_code_documentation.{ps,pdf} \
	$(DOCPATH)/$(NAME)_structure.{ps,pdf}

dist-clean distclean:
	@echo " + making $@ in $(DIRNAME) ..."
	@$(MAKE) clean-default
	@$(MAKE) clean-doc
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done
	@$(MAKE) -C server $@
	@$(MAKE) -C mlrc $@
	@$(MAKE) -C preprocessing $@
	@$(RM) config.cache config.log config.status .depend variables.Makefile \
	configure $(NAME).{cma,cmxa,a}

clean-cvs: clean-cvs-default
	@echo " + making $@ in $(DIRNAME) ..."
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done
	@$(MAKE) -C server $@
	@$(MAKE) -C mlrc $@
	@$(MAKE) -C preprocessing $@

sources-dump:
	@echo " + making $@ in $(DIRNAME) ..."
	@echo -n > .all_cma
	@echo -n > .all_cmx
	@echo -n > .all_cmi
	@echo -n > .all_ml
	@echo -n > .all_mli
	@echo -n > .ocamldoc_includes
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done

# check
#######

check:
	@echo " /"
	@echo " | Running the LibML test suite ..."
	@echo " \\"
	@for i in $(SUBDIRS);\
	do\
	( $(MAKE) -C $$i $@ ) || exit 1 ;\
	done
	@echo " /"
	@echo " | LibML test suite sucessfully finished."
	@echo " \\"


include ./commonrules.Makefile
