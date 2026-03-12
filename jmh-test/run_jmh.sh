#!/bin/bash
set -e

# Ubicación del JDK
JAVA_CMD="${JAVA_HOME:-$HOME/.sdkman/candidates/java/current}/bin/java"

# Verifica que exista el JAR
JAR_FILE="target/perf-jmh-1.0.jar"
if [ ! -f "$JAR_FILE" ]; then
    echo "ERROR: No se encontró el fat JAR $JAR_FILE"
    exit 1
fi

echo "Usando Java en: $($JAVA_CMD -version 2>&1 | head -n 1)"
echo
echo "Ejecutando benchmarks JMH..."

# Opciones JMH
WARMUP_ITER=5
MEASUREMENT_ITER=5
FORKS=1
THREADS=1
MODE="AverageTime"
TIME_UNIT="ns"

$JAVA_CMD -jar "$JAR_FILE" \
    -wi $WARMUP_ITER \
    -i $MEASUREMENT_ITER \
    -f $FORKS \
    -t $THREADS \
    -bm $MODE \
    -tu $TIME_UNIT