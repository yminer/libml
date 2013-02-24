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

AXIS_PATH = /usr/local/share/java
LIBML_STUBS = ../../../stubs/java/libml-stubs-java-0.1-alpha.jar

JAVA_SRC = ExampleLibmlDriver.java \
	Main.java

all:
	gcj -C --extdirs=$(AXIS_PATH) \
	--classpath $(LIBML_STUBS):. \
	$(JAVA_SRC)

AXIS = $(AXIS_PATH)/axis.jar
JAXRPC = $(AXIS_PATH)/jaxrpc.jar
COMMONS_LOGGING = $(AXIS_PATH)/commons-logging.jar
COMMONS_DISCOVERY = $(AXIS_PATH)/commons-discovery.jar
SAAJ = $(AXIS_PATH)/saaj.jar
WSDL4J = $(AXIS_PATH)/wsdl4j.jar

run:
	kaffe \
	-classpath $(LIBML_STUBS):$(AXIS):$(JAXRPC):$(COMMONS_LOGGING):$(COMMONS_DISCOVERY):$(SAAJ):$(WSDL4J):. Main

doc:
	javadoc -d doc -sourcepath .

clean:
	rm -f *.class *~
