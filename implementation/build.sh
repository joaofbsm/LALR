#!/bin/sh

java -jar implementation/jflex-1.6.1.jar Lexer.flex
java -jar implementation/java-cup-11b.jar -interface -parser Parser Parser.cup
javac -cp java-cup-11b-runtime.jar:. *.java
#java -cp java-cup-11b-runtime.jar:. Parser ../tests/test1.txt ../outputs/out1.xml