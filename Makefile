# Makefile for Ypsilax (yoob version).
# $Id$

JAVAC?=javac
JAVA?=java
PATHSEP?=:

JFLAGS?=-Xlint:deprecation -Xlint:unchecked
CDIR=bin/tc/catseye/ypsilax
CLASSES=$(CDIR)/YpsilaxState.class

YOOBDIR?=../../../lab/yoob
CLASSPATH?=bin$(PATHSEP)$(YOOBDIR)/bin

all: $(CLASSES)

$(CDIR)/YpsilaxState.class: src/YpsilaxState.java
	$(JAVAC) $(JFLAGS) -cp "$(CLASSPATH)" -d bin src/YpsilaxState.java

clean:
	rm -rf $(CDIR)/*.class

test: $(CLASSES)
	$(JAVA) -cp "$(CLASSPATH)" tc.catseye.yoob.GUI -c "tc.catseye.ypsilax.YpsilaxState/Ypsilax" -s Ypsilax
