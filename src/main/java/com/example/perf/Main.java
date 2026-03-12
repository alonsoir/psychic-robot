package com.example.perf;

import com.example.perf.user.*;
import com.example.perf.orders.*;
import java.util.*;

public class Main {
    public static void main(String[] args) {
        // Benchmark interfaces vs concrete
        UserService userInterface = new UserServiceImpl();
        UserServiceConcrete userConcrete = new UserServiceConcrete();

        int iterations = 1_000_000;
        long start = System.currentTimeMillis();
        for (int i = 0; i < iterations; i++) {
            userInterface.getUserById("x");
        }
        long ifaceTime = System.currentTimeMillis() - start;

        start = System.currentTimeMillis();
        for (int i = 0; i < iterations; i++) {
            userConcrete.getUserById("x");
        }
        long concreteTime = System.currentTimeMillis() - start;

        System.out.println("=== Interfaces vs Concrete ===");
        System.out.println("Interface: " + ifaceTime + " ms");
        System.out.println("Concrete:  " + concreteTime + " ms");

        // Benchmark Streams vs Inline Loops
        OrderProcessorStreams streams = new OrderProcessorStreams();
        OrderProcessorInline inline = new OrderProcessorInline();
        List<Integer> items = new ArrayList<>();
        for (int i = 0; i < 1_000_000; i++) items.add(i);

        start = System.currentTimeMillis();
        streams.process(items);
        long streamTime = System.currentTimeMillis() - start;

        start = System.currentTimeMillis();
        inline.process(items);
        long inlineTime = System.currentTimeMillis() - start;

        System.out.println("\n=== Streams vs Inline Loops ===");
        System.out.println("Streams: " + streamTime + " ms");
        System.out.println("Inline:  " + inlineTime + " ms");

        // Benchmark Small Methods vs Long Methods
        start = System.currentTimeMillis();
        for (int i = 0; i < iterations; i++) {
            tinyMethod1(); tinyMethod2(); tinyMethod3();
        }
        long smallMethodTime = System.currentTimeMillis() - start;

        start = System.currentTimeMillis();
        for (int i = 0; i < iterations; i++) {
            longMethod();
        }
        long longMethodTime = System.currentTimeMillis() - start;

        System.out.println("\n=== Small Methods vs Long Method ===");
        System.out.println("Small Methods: " + smallMethodTime + " ms");
        System.out.println("Long Method:    " + longMethodTime + " ms");
    }

    // Small methods
    static void tinyMethod1() { int x = 1; x++; }
    static void tinyMethod2() { int y = 2; y++; }
    static void tinyMethod3() { int z = 3; z++; }

    // Long method equivalent
    static void longMethod() { int x = 1; x++; int y = 2; y++; int z = 3; z++; }
}
