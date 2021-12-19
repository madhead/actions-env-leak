#!/usr/bin/env sh

echo "Environment:"
printenv

printf "\n"
echo "JAVA_HOME:"
printenv JAVA_HOME

printf "\n"
echo "Java location:"
command -v java

printf "\n"
echo "Java version:"
java --version
