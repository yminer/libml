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

include ../src/variables.Makefile

USER_MANUAL_DIR = user_manual

EXAMPLES_DIR = examples

all: doc

doc:
	@$(MAKE) -C $(USER_MANUAL_DIR) $@
	@$(MAKE) _clean-default
	@$(MAKE) _doc-tarball

INSTALL = install -o root -g root

INSTALL_D = $(INSTALL) -m 755
INSTALL_F = $(INSTALL) -m 644

install:
	@echo " + creating directories ..."
	$(INSTALL_D) -d $(DOC_INSTALL_PATH)/{examples/helloworld,html/,user_manual/html}
	@echo " + installing files ..."
	@$(MAKE) _install-examples
	$(INSTALL_F) html/*.html $(DOC_INSTALL_PATH)/html
	$(INSTALL_F) $(NAME)_code_documentation.{pdf,ps} $(DOC_INSTALL_PATH)
	$(INSTALL_F) $(USER_MANUAL_DIR)/html/* \
	$(DOC_INSTALL_PATH)/$(USER_MANUAL_DIR)/html
	$(INSTALL_F) $(USER_MANUAL_DIR)/$(NAME)_user_manual.{pdf,ps} \
	$(DOC_INSTALL_PATH)/$(USER_MANUAL_DIR)
	$(INSTALL_F) index.html style.css $(DOC_INSTALL_PATH)

_install-examples:
	$(INSTALL_F) examples/helloworld/{helloworld.ml,Makefile} \
	$(DOC_INSTALL_PATH)/examples/helloworld

uninstall:
	@echo " + remoning installed documentation ..."
	rm -Rf $(DOC_INSTALL_PATH)

_doc-tarball:
	@$(MAKE) -C .. version-dist
	@echo " + creating $(NAME)_documentation-`cat ../version`.tar.bz2 ..."
	@$(RM) -R $(TMP)
	@mkdir -p $(TMP)
	@cp -r ../../$(NAME) $(TMP)
	@$(MAKE) -C $(TMP)/$(NAME)/doc clean-cvs
	@cp -R $(TMP)/$(NAME)/doc/ \
	$(TMP)/$(NAME)_documentation-`cat ../version`
	@tar -C$(TMP) -cjf ../$(NAME)_documentation-`cat ../version`.tar.bz2 \
	$(NAME)_documentation-`cat ../version`
	@$(RM) -R $(TMP)
	@$(MAKE) -C .. clean-version

html:
	@$(MAKE) -C $(USER_MANUAL_DIR) $@

dvi:
	@$(MAKE) -C $(USER_MANUAL_DIR) $@

pdf:
	@$(MAKE) -C $(USER_MANUAL_DIR) $@

ps:
	@$(MAKE) -C $(USER_MANUAL_DIR) $@

doc-view:
	mozilla file://`pwd`/index.html

clean:  _clean-default
	@$(MAKE) -C $(USER_MANUAL_DIR) $@
	@$(MAKE) -C $(EXAMPLES_DIR) $@

_clean-default: clean-basic
	@$(RM) -R dvi latex

clean-doc: _clean-default
	@$(MAKE) -C $(USER_MANUAL_DIR) $@
	$(RM) -R ./{dvi,html,latex,man,texi,pdf,ps,texi2html} \
	../$(NAME)_documentation.tar.bz2

dist-clean distclean: _clean-default 
	@$(MAKE) -C $(USER_MANUAL_DIR) $@
	@$(MAKE) -C $(EXAMPLES_DIR) $@

clean-cvs: clean-cvs-default
	@$(MAKE) -C $(USER_MANUAL_DIR) $@
	@$(MAKE) -C $(EXAMPLES_DIR) $@

check:
	@$(MAKE) -C $(EXAMPLES_DIR) $@

.PHONY: doc

include ../src/commonrules.Makefile
