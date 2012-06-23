#!/bin/sh -x
make \
    JAVAC='"/cygdrive/c/Program Files/Java/jdk1.6.0_22/bin/javac"' \
    JAVA='"/cygdrive/c/Program Files/Java/jre6/bin/java"' \
    PATHSEP=';' \
    $*
