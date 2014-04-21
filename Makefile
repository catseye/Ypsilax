# Makefile for Ypsilax (yoob version).
# $Id$

JAVAC?=javac
JAVA?=java
ifeq ($(OS),Windows_NT)
  PATHSEP=;
else
  PATHSEP=:
endif

JFLAGS?=-Xlint:deprecation -Xlint:unchecked
CDIR=bin/tc/catseye/ypsilax
CLASSES=$(CDIR)/YpsilaxState.class

YOOBDIR?=../yoob
CP?=bin$(PATHSEP)$(YOOBDIR)/bin

all:
	@echo "Java classes are not built by default.  Run 'make java' to build them."

java: $(CLASSES)

$(CDIR)/YpsilaxState.class: src/YpsilaxState.java
	$(JAVAC) $(JFLAGS) -cp "$(CP)" -d bin src/YpsilaxState.java

clean:
	rm -rf $(CDIR)/*.class

test: $(CLASSES)
	$(JAVA) -cp "$(CP)" tc.catseye.yoob.GUI -c "tc.catseye.ypsilax.YpsilaxState/Ypsilax" -s Ypsilax
