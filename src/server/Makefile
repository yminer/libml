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

OCAMLFIND_OPTIONS = -I ../wrappers
PATH_TO_SRC = ..

all: mld-bytecode

bytecode:
	@echo " + making $@ in server ..."
	$(OCAMLFIND) ocamlc -c $(BFLAGS) libml-server.ml $(OCAMLFIND_OPTIONS)
	$(OCAMLFIND) ocamlc -c $(BFLAGS) SOAPCallbacks.ml $(OCAMLFIND_OPTIONS)

binary:
	@echo " + making $@ in server ..."
	$(OCAMLFIND) ocamlopt -c libml-server.ml $(OCAMLFIND_OPTIONS)
	$(OCAMLFIND) ocamlopt -c SOAPCallbacks.ml $(OCAMLFIND_OPTIONS)
	$(OCAMLFIND) ocamlopt stdsoap2.o soapServer.o soapC.o server-launch.o mld.o -o mld ../$(NAME).cmxa SOAPCallbacks.cmx $(NAME)-server.cmx -ccopt -L../ -ccopt -lml

# generate soapServer.c, soapC.c, 
soap_files: libml.h
	@echo " + generating daemon in server ..."
	soapcpp2 -c libml.h

mld-bytecode: bytecode soap_files mld.c
	@echo " + building C generated files in server ..."
	$(CC) -c stdsoap2.c soapServer.c soapC.c server-launch.c mld.c -I/usr/local/lib/ocaml/
	@echo " + linking mld in server ..."
	$(OCAMLFIND) ocamlc -custom -o mld $(OCAMLLIB)/unix.cma ../$(NAME).cma stdsoap2.o soapServer.o soapC.o server-launch.o mld.o SOAPCallbacks.cmo $(NAME)-server.cmo

clean: clean-basic
	@echo " + making $@ in server ..."
	$(RM) *.cm[i,x,o] *.o
	$(RM) $(NAME).*.xml ns.xsd $(NAME).nsmap \
	soapH.h soap$(NAME)Object.h soap$(NAME)Proxy.h soapStub.h \
	soapC.c soapClient.c soapClientLib.c soapServer.c soapServerLib.c

dist-clean distclean: clean
	@echo " + making $@ in server ..."
	$(RM) $(NAME).wsdl mld mld-byte

clean-cvs: clean-cvs-default

include ../commonrules.Makefile
