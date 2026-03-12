#!/bin/bash
# Script para ejecutar JMH y extraer solo los números de los benchmarks
# Usa el fat JAR generado con Maven + shade plugin

JMH_JAR="jmh-test/target/perf-jmh-1.0-shaded.jar"

if [ ! -f "$JMH_JAR" ]; then
    echo "ERROR: No se encontró el fat JAR $JMH_JAR"
    exit 1
fi

echo "Ejecutando benchmarks JMH (solo números)..."
java -jar "$JMH_JAR" -wi 5 -i 5 -f 1 -rf csv -rff jmh-results.csv -q

echo "Resultados exportados a jmh-results.csv"
echo "Contenido CSV:"
cat jmh-results.csv | awk -F, '{print $1","$2","$3","$4}'