# Build
echo ====== Building ANTLR code for immediate testing....
java -jar antlr-4.13.2-complete.jar -o code -Xexact-output-dir lolcode.g4

javac -d code -classpath .:antlr-4.13.2-complete.jar code/lolcode*.java
