---

# Java Hot Path Benchmark

Este repositorio contiene benchmarks de micro-rendimiento en Java para analizar el impacto real de ciertas "buenas prácticas" en el *hot path* de la aplicación, basándose en experimentos de rendimiento real.

## 🎯 Objetivos del Estudio

* **Llamadas a interfaces vs clases concretas**: Impacto del *overhead* de abstracción.
* **Streams vs bucles inline**: Coste de la programación funcional en Java frente a imperativa clásica.
* **Small Methods vs Long Methods**: Influencia del tamaño del método en el *inlining* de la JIT.
* **Monomorphic, Bimorphic y Megamorphic dispatch**: Cómo penaliza el polimorfismo según el número de implementaciones.

---

## 📂 Estructura del Proyecto

```text
.
├── jmh-test           # Configuración y microbenchmarks JMH
├── out                # Clases compiladas para los benchmarks manuales
├── run_benchmark.sh   # Benchmark rápido (baseline)
├── run_benchmark_jit.sh # Benchmark con warmup + JIT
├── run_jmh_numbers.sh # Script de automatización JMH con exportación CSV
└── src                # Código fuente principal

```

### Clases Relevantes

* **`com.example.perf.Main.java`**: Punto de entrada para tests rápidos de interfaces, streams y tamaño de métodos.
* **`com.example.perf.user`**: Contiene `User`, `UserService`, y sus implementaciones para comparar polimorfismo vs. llamadas directas.
* **`com.example.perf.orders`**: Procesadores de órdenes (`Inline`, `Streams`, `SmallMethods`, `LargeMethods`) para comparar lógica de bucles y profundidad de stack.
* **`com.example.DispatchBenchmark.java`**: Microbenchmark JMH específico para medir el *dispatch* polimórfico.

---

## 🚀 Ejecución

### 1. Benchmarks Manuales (Sin JMH)

Para una visión rápida del impacto del JIT:

```bash
chmod +x run_benchmark.sh run_benchmark_jit.sh
./run_benchmark.sh      # Ejecución normal
./run_benchmark_jit.sh  # Ejecución con fase de warmup

```

### 2. Benchmarks de Alta Precisión (JMH)

Para obtener resultados estadísticamente significativos y exportar a CSV:

```bash
cd jmh-test
mvn clean install -P jmh
chmod +x ../run_jmh_numbers.sh
../run_jmh_numbers.sh

```

> **Nota:** El script `run_jmh_numbers.sh` generará un archivo `jmh-results.csv` con los datos crudos para facilitar su análisis en Excel o Python.

---

## 📊 Interpretación de Resultados

* **Interfaces vs Concrete**: Observa el coste de las llamadas virtuales.
* **Streams vs Inline Loops**: Verás que, aunque los Streams son elegantes, los loops suelen ganar en el *hot path* puro.
* **Small Methods vs Long Method**: Analiza cómo el tamaño afecta a la decisión de la JVM de "aplanar" el código.
* **Monomorphic / Bimorphic / Megamorphic**: El salto a *Megamorphic* suele ser el punto de ruptura donde la optimización de la JVM cae drásticamente.

> [!IMPORTANT]
> La "sobre-abstracción" en partes críticas del código (hot paths) puede degradar el rendimiento instantáneamente al impedir que la JIT aplique optimizaciones agresivas.

---

## 📚 Referencias

* [JMH – Java Microbenchmark Harness](https://openjdk.org/projects/code-tools/jmh/)
* [Medium: I Removed 3 "Best Practices" From My Java App...](https://medium.com/javarevisited/i-removed-3-best-practices-from-my-java-app-performance-improved-instantly-bda04c642a5f)
* Conceptos clave: *Monomorphic, Bimorphic y Megamorphic call sites*.

---

