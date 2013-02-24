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


NAME = libml

CURRENT_VERSION = 0.1-alpha

SRC = src
DOC = doc
STUBS = stubs

TMP = /tmp/$(NAME)-build
MKDIR = mkdir -p
RM = rm -f
MAKE = make -s
TEE = tee -a -i

all: _stats-dir
	@echo > stats/$(NAME)-$(CURRENT_VERSION)-build.log
	@$(MAKE) _all-real | \
	$(TEE) stats/$(NAME)-$(CURRENT_VERSION)-build.log 2>&1

_all-real: _minimum
	@echo " + making all ..."
	@$(MAKE) -C $(SRC) all
	@echo " "
	@echo " (* $(NAME) build successful! *)"
	@echo " "

re: _minimum
	@echo " + making $@ ..."
	@$(MAKE) -C $(SRC) $@
	@$(MAKE) -C $(DOC) clean

stubs:
	@$(MAKE) -C $(STUBS) all

interface: _minimum
	@echo " + making $@ ..."
	@$(MAKE) -C $(SRC) $@

byte: _minimum
	@echo " + making $@ ..."
	@$(MAKE) -C $(SRC) $@

opt: _minimum
	@echo " + making $@ ..."
	@$(MAKE) -C $(SRC) $@

doc: _stats-dir
	@echo > stats/$(NAME)-$(CURRENT_VERSION)-doc.log
	@$(MAKE) _doc-real | \
	$(TEE) stats/$(NAME)-$(CURRENT_VERSION)-doc.log 2>&1

_doc-real: _minimum
	@echo " + making doc ..."
	@$(MAKE) -C $(SRC) doc
	@$(MAKE) -C $(STUBS) doc
	@$(MAKE) -C $(DOC) doc

doc-view:
	@echo " + making $@ ..."
	mozilla file://`pwd`/doc/index.html



clean: _stats-dir
	@echo > stats/$(NAME)-$(CURRENT_VERSION)-clean.log
	@$(MAKE) _clean-real | \
	$(TEE) stats/$(NAME)-$(CURRENT_VERSION)-clean.log 2>&1

_clean-real: _minimum _clean-default
	@echo " + making clean ..."
	@$(MAKE) -C $(SRC) clean
	@$(MAKE) -C $(DOC) clean
	@$(MAKE) -C $(STUBS) clean

_clean-default:
	@$(RM) *~ \#* .*~ .\#* $(SRC)/META ./version

clean-doc: _minimum _clean-default
	@echo " + making $@ ..."
	@$(MAKE) -C $(SRC) $@
	@$(MAKE) -C $(STUBS) $@
	@$(MAKE) -C $(DOC) $@

clean-version:
	@$(RM) ./version

check: _minimum
	@echo " + making $@ ..."
	@$(MAKE) -C $(SRC) $@
	@$(MAKE) -C $(DOC) $@

distclean dist-clean: _minimum _clean-default
	@echo " + making $@ ..."
	@$(MAKE) -C $(DOC) $@
	@$(MAKE) -C $(STUBS) $@
	@$(MAKE) -C $(SRC) $@
	@$(RM) $(NAME)-$(CURRENT_VERSION)-stats.log

dist: _minimum
	@echo " + making $@ ..."
	@$(MAKE) version-dist
	@$(MAKE) _tarball-begin
	@$(MAKE) version-dist
	@$(MAKE) _tarball-end
	@$(MAKE) clean-version

nightbuild: _minimum
	@echo " + making $@ ..."
	@$(MAKE) _version-nightbuild
	@$(MAKE) _tarball-begin
	@$(MAKE) _version-nightbuild
	@$(MAKE) _tarball-end
	@$(MAKE) clean-version

_tarball-begin:
	@$(RM) -R $(TMP)/$(NAME)-`cat ./version`
	@$(MAKE) distclean
	@$(MAKE) doc
	@$(MAKE) version-dist
	@tar -xjf ./$(NAME)_documentation-`cat ./version`.tar.bz2
	@mv ./$(NAME)_documentation-`cat ./version` ./$(NAME)_documentation
	@$(RM) ./$(NAME)_documentation-`cat ./version`.tar.bz2
	@mkdir -p $(TMP)
	@tar -cjf $(TMP)/$(NAME)_documentation.tar.bz2 ./$(NAME)_documentation
	@$(RM) -R ./$(NAME)_documentation
	@$(MAKE) clean-version

_tarball-end:
	@mkdir -p $(TMP)/$(NAME)-`cat ./version`
	@$(MAKE) _meta
	@cp -r * $(TMP)/$(NAME)-`cat ./version`
	@$(MAKE) -C $(TMP)/$(NAME)-`cat ./version` clean-cvs
	@$(MAKE) -C $(TMP)/$(NAME)-`cat ./version` distclean
	@$(MAKE) -C $(TMP)/$(NAME)-`cat ./version` configure
	@$(RM) -R $(TMP)/$(NAME)-`cat ./version`/doc
	@mv $(TMP)/$(NAME)_documentation.tar.bz2 $(TMP)/$(NAME)-`cat ./version`
	@tar -C$(TMP)/$(NAME)-`cat ./version` -xjf \
	$(TMP)/$(NAME)-`cat ./version`/$(NAME)_documentation.tar.bz2
	@$(RM) $(TMP)/$(NAME)-`cat ./version`/$(NAME)_documentation.tar.bz2
	@mv $(TMP)/$(NAME)-`cat ./version`/$(NAME)_documentation $(TMP)/$(NAME)-`cat ./version`/doc
	@echo " + creating ./$(NAME)-`cat ./version`_documentation.tar.bz2 ..."
	@mkdir -p $(TMP)/$(NAME)-`cat ./version`_documentation
	@cp -r $(TMP)/$(NAME)-`cat ./version`/doc/* $(TMP)/$(NAME)-`cat ./version`_documentation
	@tar -C$(TMP) -cjf ./$(NAME)-`cat ./version`_documentation.tar.bz2 \
	$(NAME)-`cat ./version`_documentation
	@echo " + creating ./$(NAME)-`cat ./version`.tar.bz2 ..."
	@tar -C$(TMP) -cjf ./$(NAME)-`cat ./version`.tar.bz2 \
	$(NAME)-`cat ./version`
	@$(RM) -R $(TMP)

dist-check: _minimum
	@echo " + making $@ ..."
	@$(MAKE) dist version-dist _check-tarball clean-version

nightbuild-check: _minimum
	@echo " + making $@ ..."
	@$(MAKE) nightbuild _version-nightbuild _check-tarball clean-version

_check-tarball:
	@echo " + checking ./$(NAME)-`cat ./version`.tar.bz2 ..."
	@tar xjf ./$(NAME)-`cat ./version`.tar.bz2
	@$(MAKE) -C $(NAME)-`cat ./version`
	@$(MAKE) -C $(NAME)-`cat ./version` check
	@$(MAKE) -C $(NAME)-`cat ./version` clean
	@$(RM) -R $(NAME)-`cat ./version`
	@echo " + ./$(NAME)-`cat ./version`.tar.bz2 sucessfully checked."
	@echo " + ./$(NAME)-`cat ./version`_documentation.tar.bz2 sucessfully checked."

# this rule removes the files used by cvs. It should not be used within a cvs
# repository,  but for a tarball creation only!
clean-cvs: _minimum
	@echo " + making $@ ..."
	@$(MAKE) -C $(DOC) $@
	@$(MAKE) -C $(SRC) $@
	@$(MAKE) -C $(STUBS) $@
	@$(RM) -R ./CVS ./.cvsignore

help:
	@echo " (*  LibML compilation  *)"
	@echo
	@echo " You must use GNU make in order to compile LibML."
	@echo " Here are the available targets:"
	@echo
	@echo " * all"
	@echo " Builds both the bytecode and the optimized code libraries."
	@echo " * install"
	@echo " Installs LibML on your system (includes findlib support)."
	@echo " * uninstall"
	@echo " Uninstalls LibML from your system."
	@echo " * byte"
	@echo " Builds the bytecode version of LibML."
	@echo " * opt"
	@echo " Builds the optimized version of LibML."
	@echo " * clean"
	@echo " Cleans the unwanted compiled files."
	@echo " * help"
	@echo " Displays this help message."
	@echo " * help-dev"
	@echo " Displays targets for LibML developers."

help-dev:
	@echo " (*  LibML developers targets  *)"
	@echo
	@echo " * stubs"
	@echo " Generates stubs for other languages in stubs/."
	@echo " * interface"
	@echo " Builds all .mli files."
	@echo " * re"
	@echo " Alias for clean all."
	@echo " * doc"
	@echo " Generates the documentation."
	@echo " * check"
	@echo " Runs the test suite."
	@echo " * dist"
	@echo " Makes a distribution tarball."
	@echo " * dist-check"
	@echo " Makes a distribution tarball and runs the check suite on it."
	@echo " * mld-run"
	@echo " Runs the mld daemon localy."
	@echo " * mld-kill"
	@echo " Kills mld."
	@echo " * stats"
	@echo " Generates stats about the sources in stats/."

install: _minimum
	@echo " + making $@ ..."
	@$(MAKE) -C $(SRC) $@

uninstall: _minimum
	@echo " + making $@ ..."
	@$(MAKE) -C $(SRC) $@

_minimum: $(SRC)/variables.Makefile

$(SRC)/variables.Makefile: $(SRC)/configure $(SRC)/variables.Makefile.in
	@echo " + generating $@ ..."
	@( cd $(SRC) && ./configure )

configure: $(SRC)/configure

$(SRC)/configure: $(SRC)/configure.in
	@echo " + generating $@ ..."
	@( cd $(SRC) && \
	autoconf )

_version-nightbuild:
	@echo " + generating ./version ..."
	@echo "cvs-`date +%m_%d_%y`" > ./version

version-dist:
	@echo " + generating ./version ..."
	@echo "$(CURRENT_VERSION)" > ./version

_meta: $(SRC)/META

$(SRC)/META:
	@echo " + generating META file ..."
	@echo "name = \"$(NAME)\"" > $(SRC)/META
	@echo "version = \"`cat ./version`\"" >> $(SRC)/META
	@echo "description = \"Machine Learning library\"" >> $(SRC)/META
	@echo "requires = \"\"" >> $(SRC)/META
	@echo "archive(byte) = \"$(NAME).cma\"" >> $(SRC)/META
	@echo "archive(native) = \"$(NAME).cmxa\"" >> $(SRC)/META

.PHONY: doc help $(SRC)/META version-dist _version-nightbuild _minimum stubs

# (* mld *)

mld-run:
	src/server/mld "127.0.0.1" 4242

mld-kill:
	killall mld

# (* Statistics *)

# number of lines of the header
HEADER_SIZE = 35
# output stats file
STATS_LOG = stats/$(NAME)-$(CURRENT_VERSION)-stats.log

_stats-dir:
	@$(MKDIR) stats

stats: _stats-dir
	@echo > stats/$(NAME)-$(CURRENT_VERSION)-stats.log
	@$(MAKE) _stats-real | \
	$(TEE) stats/$(NAME)-$(CURRENT_VERSION)-stats.log 2>&1
	@echo
	@echo " + log written in $(STATS_LOG)"
	@$(MAKE) clean-stats
	@echo " + saving traces in $(NAME)_stats-$(CURRENT_VERSION).tar.bz2 ..."
	@cp -r stats $(NAME)_stats-$(CURRENT_VERSION)
	@tar cjf $(NAME)_stats-$(CURRENT_VERSION).tar.bz2 \
	$(NAME)_stats-$(CURRENT_VERSION)
	@$(RM) -R $(NAME)_stats-$(CURRENT_VERSION)

# display log
	@cat $(STATS_LOG)

_stats-real:
	@echo " + making stats (it might take several minutes) ..."
	@$(MAKE) distclean > /dev/null 2>&1
# build, and save sources + objects size
	@$(MAKE) all > /dev/null 2>&1
	@echo `du -hs . |tr -d ' '|tr -d '.'` > stats/.$(NAME)-$(CURRENT_VERSION)-sources-objects-size
	@$(MAKE) distclean > /dev/null 2>&1
# build doc, and save sources + doc size
	@$(MAKE) doc > /dev/null 2>&1
	@$(RM) $(NAME)_documentation-*.tar.bz2
	@echo `du -hs . |tr -d ' '|tr -d '.'` > stats/.$(NAME)-$(CURRENT_VERSION)-sources-doc-size
	@$(MAKE) distclean > /dev/null 2>&1
# build all and doc and save sources + objects + doc size
	@$(MAKE) all > /dev/null 2>&1
	@$(MAKE) doc > /dev/null 2>&1
	@$(RM) $(NAME)_documentation-*.tar.bz2
	@echo `du -hs . |tr -d ' '|tr -d '.'` > stats/.$(NAME)-$(CURRENT_VERSION)-sources-objects-doc-size
# clean, and save sources size
	@$(MAKE) clean > /dev/null 2>&1
	@echo `du -hs . |tr -d ' '|tr -d '.'` > stats/.$(NAME)-$(CURRENT_VERSION)-sources-size
# compute ml files number
	@echo `find . -name "*.ml" |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-ml-files
# compute mli files number
	@echo `find . -name "*.mli" |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-mli-files
# compute c files number
	@echo `find . -name "*.c" |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-c-files
# compute h files number
	@echo `find . -name "*.h" |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-h-files
# compute tex files number
	@echo `find . -name "*.tex" |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-tex-files
# compute ml lines number without header using bc
	@echo -n `find . -name "*.ml" -exec cat '{}' ';' |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo -n " - ($(HEADER_SIZE) * " >> stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-ml-files` >> stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo ")" >> stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo "quit" >> stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo `bc -q stats/.$(NAME)-$(CURRENT_VERSION)-tmp` > stats/.$(NAME)-$(CURRENT_VERSION)-ml-lines
# compute mli lines number without header using bc
	@echo -n `find . -name "*.mli" -exec cat '{}' ';' |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo -n " - ($(HEADER_SIZE) * " >> stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-mli-files` >> stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo ")" >> stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo "quit" >> stats/.$(NAME)-$(CURRENT_VERSION)-tmp
	@echo `bc -q stats/.$(NAME)-$(CURRENT_VERSION)-tmp` > stats/.$(NAME)-$(CURRENT_VERSION)-mli-lines
# compute c lines number
	@echo -n `find . -name "*.c" -exec cat '{}' ';' |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-c-lines
# compute h lines number
	@echo -n `find . -name "*.h" -exec cat '{}' ';' |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-h-lines
# compute tex lines number
	@echo -n `find . -name "*.tex" -exec cat '{}' ';' |wc -l` > stats/.$(NAME)-$(CURRENT_VERSION)-tex-lines

	@echo > $(STATS_LOG)
	@echo " (* LibML statistics *)" >> $(STATS_LOG)
	@echo >> $(STATS_LOG)
# start writing log:
# write sizes stats
	@echo " sources size:" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@cat stats/.$(NAME)-$(CURRENT_VERSION)-sources-size >> $(STATS_LOG)
	@echo " sources + objects size:" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@cat stats/.$(NAME)-$(CURRENT_VERSION)-sources-objects-size >> $(STATS_LOG)
	@echo " sources + doc size:" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@cat stats/.$(NAME)-$(CURRENT_VERSION)-sources-doc-size >> $(STATS_LOG)
	@echo " sources + objects+doc size:" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@cat stats/.$(NAME)-$(CURRENT_VERSION)-sources-objects-doc-size >> $(STATS_LOG)
# write stats for ml files
	@echo " .ml files (implementations):" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-ml-files` >> $(STATS_LOG)
	@echo -n " files, " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-ml-lines` >> $(STATS_LOG)
	@echo " lines without headers." >> $(STATS_LOG)
# write stats for mli files
	@echo " .mli files (interfaces):" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-mli-files` >> $(STATS_LOG)
	@echo -n " files, " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-mli-lines` >> $(STATS_LOG)
	@echo " lines without headers." >> $(STATS_LOG)
# write stats for c files
	@echo " .c files (C sources):" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-c-files` >> $(STATS_LOG)
	@echo -n " files, " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-c-lines` >> $(STATS_LOG)
	@echo " lines." >> $(STATS_LOG)
# write stats for h files
	@echo " .h files (C headers):" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-h-files` >> $(STATS_LOG)
	@echo -n " files, " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-h-lines` >> $(STATS_LOG)
	@echo " lines." >> $(STATS_LOG)
# write stats for tex files
	@echo " .tex files (latex documentation):" >> $(STATS_LOG)
	@echo -n " " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-tex-files` >> $(STATS_LOG)
	@echo -n " files, " >> $(STATS_LOG)
	@echo -n `cat stats/.$(NAME)-$(CURRENT_VERSION)-tex-lines` >> $(STATS_LOG)
	@echo " lines." >> $(STATS_LOG)

clean-stats:
	@$(RM) stats/.$(NAME)-$(CURRENT_VERSION)-tmp \
	stats/.$(NAME)-$(CURRENT_VERSION)-ml-files \
	stats/.$(NAME)-$(CURRENT_VERSION)-ml-lines \
	stats/.$(NAME)-$(CURRENT_VERSION)-mli-files \
	stats/.$(NAME)-$(CURRENT_VERSION)-mli-lines \
	stats/.$(NAME)-$(CURRENT_VERSION)-c-files \
	stats/.$(NAME)-$(CURRENT_VERSION)-c-lines \
	stats/.$(NAME)-$(CURRENT_VERSION)-h-files \
	stats/.$(NAME)-$(CURRENT_VERSION)-h-lines \
	stats/.$(NAME)-$(CURRENT_VERSION)-tex-files \
	stats/.$(NAME)-$(CURRENT_VERSION)-tex-lines \
	stats/.$(NAME)-$(CURRENT_VERSION)-sources-size \
	stats/.$(NAME)-$(CURRENT_VERSION)-sources-objects-size \
	stats/.$(NAME)-$(CURRENT_VERSION)-sources-doc-size \
	stats/.$(NAME)-$(CURRENT_VERSION)-sources-objects-doc-size
