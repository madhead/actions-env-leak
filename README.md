# Environment "leaks" into Docker container actions

Imagine a simple Docker container action, depending on the `JAVA_HOME` environment variable.
It may be a simple Java app assembled with [Gradle Application Plugin](https://docs.gradle.org/current/userguide/application_plugin.html), which uses a script searching for Java VM in a `JAVA_HOME`.

But for the sake of simplicity in this repo we just print the environment, highlighting the `JAVA_HOME`, Java location (`whereis java`) and Java version:

```bash
#!/usr/bin/env sh

echo "Environment:"
printenv

printf "\n"
echo "JAVA_HOME:"
printenv JAVA_HOME

printf "\n"
echo "Java location:"
command -v java # openjdk images do not have `whereis`

printf "\n"
echo "Java version:"
java --version
```

Now, if one [bundles](./Dockerfile) this script into a Docker image and use it as an action, it will print something like this:

```shell
JAVA_HOME:
/usr/java/openjdk-17

Java location:
/usr/java/openjdk-17/bin/java
```

To reproduce the issue, run the `actions/setup-java@v2` before this Docker container action:


```yml
- uses: actions/setup-java@v2
  with:
    distribution: 'adopt'
    java-version: '11'

- uses: madhead/actions-env-leak@main
```

The action will now print:

```shell
JAVA_HOME:
/opt/hostedtoolcache/Java_Adopt_jdk/11.0.11-9/x64

Java location:
/usr/java/openjdk-17/bin/java
```

Note that the `JAVA_HOME` environment variable now points to an invalid (inside the container) location.
The action is broken!
