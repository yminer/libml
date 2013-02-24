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

CURRENT_VERSION = 0.1-alpha

# stubs generation

all: c perl python csharp java

c: ../src/server/$(NAME).wsdl
	@echo " + generating C/C++ stubs in stubs ..."
	@if [ ! -d C-C++ ]; then mkdir C-C++; fi

perl: ../src/server/$(NAME).wsdl
	@echo " + generating perl stubs in stubs ..."
	@if [ ! -d perl ]; then mkdir perl; fi
	(cd perl && stubmaker.pl file://`pwd`/../../src/server/$(NAME).wsdl)

python: ../src/server/$(NAME).wsdl
	@echo " + generating python stubs in stubs ..."
	@if [ ! -d python ]; then mkdir python; fi
	(cd python && wsdl2py -f ../../src/server/$(NAME).wsdl)

csharp: ../src/server/$(NAME).wsdl
	@echo " + generating C# stubs in stubs ..."
	@if [ ! -d Csharp ]; then mkdir Csharp; fi
	(cd Csharp && wsdl ../../src/server/$(NAME).wsdl)

# path where the .jar for axis are available.
# they are available on http://ws.apache.org/axis/
# this is supposed to work with axis 1.1
AXIS_PATH = /usr/local/share/java

# path where the .jar for junit is available.
JUNIT_PATH = /usr/share/java

JAVA_SRC = org/libml/axis/LibmlPortType.java \
	org/libml/axis/Libml.java \
	org/libml/axis/LibmlStub.java \
	org/libml/axis/LibmlLocator.java \
	org/libml/axis/LibmlTestCase.java \
	org/libml/driver/LibmlDriver.java \
	org/libml/test/LibmlTestMain.java

GCJ = gcj

GJDOC_PATH = /usr/share/java
GNUJAXP_PATH = /usr/share/java
SAXON_PATH = /usr/share/java

java: java-jar

../src/server/$(NAME).wsdl:
	@$(MAKE) -C ../src/server all

java-wsdl2java: ../src/server/$(NAME).wsdl
	@echo " + generating java stubs in stubs ..."
	@if [ ! -d java ]; then mkdir java; fi
	( cd java && \
	java -classpath $(AXIS_PATH)/axis.jar:$(AXIS_PATH)/commons-logging.jar:$(AXIS_PATH)/commons-discovery.jar:$(AXIS_PATH)/wsdl4j.jar:$(AXIS_PATH)/saaj.jar:$(AXIS_PATH)/jaxrpc.jar \
	org.apache.axis.wsdl.WSDL2Java --package org.libml.axis \
	-t ../../src/server/$(NAME).wsdl )

java-build: java-wsdl2java
	@echo " + building java stubs in stubs ..."
	( cd java && \
	$(GCJ) -C --extdirs=$(AXIS_PATH) \
	-classpath $(JUNIT_PATH)/junit.jar:. \
	$(JAVA_SRC) )

JAVA_DOC_PATH = ../doc/java-stubs-api

java-doc: java-wsdl2java
	@echo " + generating java API documentation in stubs ..."
	mkdir -p java/doc
	( cd java && \
	gjdoc -protected -title "LibML java stubs API documentation" \
	-protected -sourcepath . -d doc/ \
	org.libml.axis org.libml.driver org.libml.test )
	$(RM) -R $(JAVA_DOC_PATH)
	mv java/doc $(JAVA_DOC_PATH)

TMPDIR = $(TMP)/$(NAME)-stubs-java_tmp
JARNAME = $(NAME)-stubs-java-$(CURRENT_VERSION).jar

java-jar: java-build java-doc
	@echo " + generating java API jar archive in stubs ..."
	mkdir -p $(TMP)
	$(RM) -R $(TMPDIR)
	cp -r java $(TMPDIR)
	cp -r $(JAVA_DOC_PATH) $(TMPDIR)/doc
	$(RM) -R $(TMPDIR)/CVS $(TMPDIR)/*/CVS $(TMPDIR)/*/*/CVS \
	$(TMPDIR)/*/*/*/CVS
	( cd $(TMPDIR) && \
	fastjar cf ./$(JARNAME) org doc )
	mv $(TMPDIR)/$(JARNAME) ./java
	$(RM) -R $(TMP)

doc: java-doc

# clean

clean: clean-basic
	@echo " + making $@ in stubs ..."
	$(RM) -R C-C++ perl python Csharp \
	java/org/libml/axis \
	java/org/libml/driver/*.class \
	java/org/libml/test/*.class \
	java/$(JARNAME)


clean-doc:
	$(RM) -R  $(JAVA_DOC_PATH)

clean-cvs: clean-cvs-default

distclean dist-clean: clean

.PHONY: java

include ../src/commonrules.Makefile
