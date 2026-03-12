Leyendo esta publicación en Medium, me llevé una gran sorpresa. 

https://medium.com/javarevisited/i-removed-3-best-practices-from-my-java-app-performance-improved-instantly-bda04c642a5f

Este repo trata de poner números para que cada uno saque sus conclusiones.

### 1️⃣ `run_jmh_numbers.sh` (nuevo script)

```bash
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
```

* Explicación:

  * `-rf csv -rff jmh-results.csv` → genera un CSV limpio.
  * `-q` → quita logging extra de JMH.
  * El `awk` imprime solo columnas esenciales: benchmark, modo, iteraciones, score.

---

### 2️⃣ `README.md`

```markdown
# Java Hot Path Benchmark

Este repositorio contiene benchmarks de micro rendimiento en Java para estudiar:

- Llamadas a interfaces vs clases concretas.
- Streams vs bucles inline.
- Small Methods vs Long Methods.
- Monomorphic, Bimorphic y Megamorphic dispatch.

## Estructura

```

.
├── jmh-test              # Benchmark JMH
├── out                   # Clases compiladas para los benchmarks de Main.java
├── run_benchmark.sh      # Benchmark rápido sin JMH
├── run_benchmark_jit.sh  # Benchmark rápido con warmup + JIT
├── run_jmh_numbers.sh    # Benchmark JMH con exportación CSV de números
└── src                   # Código fuente

````

### Clases relevantes

- **com.example.perf.Main.java** → benchmark simple de interfaces, streams y tamaño de métodos.  
- **com.example.perf.user**  
  - `User`, `UserService`, `UserServiceConcrete`, `UserServiceImpl` → usadas por Main.java para comparar polimorfismo y llamadas concretas.  
- **com.example.perf.orders**  
  - `OrderProcessorInline`, `OrderProcessorStreams`, `OrderProcessorSmallMethods`, `OrderProcessorLargeMethods` → comparativa de loops, streams y tamaño de métodos.

- **com.example.DispatchBenchmark.java** → JMH microbenchmark para monomorphic/bimorphic/megamorphic dispatch.

---

## Compilación

1. **Main.java + perf scripts** (sin JMH):
```bash
./run_benchmark.sh        # Ejecuta benchmark normal
./run_benchmark_jit.sh    # Benchmark con warmup y JIT
````

2. **JMH benchmarks**:

```bash
cd jmh-test
mvn clean install -P jmh
chmod +x ../run_jmh_numbers.sh
../run_jmh_numbers.sh
```

* Esto genera un CSV `jmh-results.csv` con los resultados de cada benchmark.

---

## Interpretación de resultados

* **Interfaces vs Concrete** → diferencia de llamadas polimórficas vs directas.
* **Streams vs Inline Loops** → comparativa de rendimiento de loops vs streams.
* **Small Methods vs Long Method** → muestra el coste de métodos cortos vs métodos largos.
* **Monomorphic/Bimorphic/Megamorphic** → cuánto penaliza el dispatch polimórfico según el número de implementaciones posibles.

> Notarás que el salto de monomorphic a megamorphic es el más crítico, esto muestra cómo la JVM optimiza las llamadas virtuales y cómo la “sobreabstracción” puede impactar en hot paths.

---

## Referencias

* [JMH – Java Microbenchmark Harness](https://openjdk.org/projects/code-tools/jmh/)
* Conceptos: monomorphic/bimorphic/megamorphic call sites.
``

