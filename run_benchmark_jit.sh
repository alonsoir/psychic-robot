#!/bin/bash
set -e

# -----------------------------
# Detectar Java automáticamente
# -----------------------------
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
    JAVA_BIN="$JAVA_HOME/bin/java"
elif [ -x "$HOME/.sdkman/candidates/java/current/bin/java" ]; then
    JAVA_BIN="$HOME/.sdkman/candidates/java/current/bin/java"
else
    echo "No se encontró Java. Instala un JDK o configura JAVA_HOME."
    exit 1
fi

JAVAC_BIN="$(dirname "$JAVA_BIN")/javac"

echo "Usando JVM:"
$JAVA_BIN -version
echo ""

# -----------------------------
# Compilar
# -----------------------------
echo "Compilando..."
rm -rf out
mkdir -p out

$JAVAC_BIN -d out $(find src -name "*.java")

# -----------------------------
# Ejecutar benchmark
# -----------------------------
echo ""
echo "Ejecutando benchmark (warmup + JIT)..."
echo ""

$JAVA_BIN \
-server \
-cp out \
com.example.perf.Main