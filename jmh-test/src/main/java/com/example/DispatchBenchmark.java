package com.example;

import org.openjdk.jmh.annotations.*;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.NANOSECONDS)
@Warmup(iterations = 5)
@Measurement(iterations = 10)
@Fork(1)
@State(Scope.Thread)

public class DispatchBenchmark {

    interface Service {
        int work(int x);
    }

    static class ImplA implements Service {
        public int work(int x) { return x + 1; }
    }

    static class ImplB implements Service {
        public int work(int x) { return x + 2; }
    }

    static class ImplC implements Service {
        public int work(int x) { return x + 3; }
    }

    Service mono = new ImplA();

    Service[] bi = new Service[]{
            new ImplA(),
            new ImplB()
    };

    Service[] mega = new Service[]{
            new ImplA(),
            new ImplB(),
            new ImplC()
    };

    Random r = new Random();

    int x = 42;

    @Benchmark
    public int monomorphic() {
        return mono.work(x);
    }

    @Benchmark
    public int bimorphic() {
        Service s = bi[x & 1];
        return s.work(x);
    }

    @Benchmark
    public int megamorphic() {
        Service s = mega[r.nextInt(mega.length)];
        return s.work(x);
    }

}