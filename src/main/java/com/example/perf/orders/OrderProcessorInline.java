package com.example.perf.orders;

import java.util.*;

public class OrderProcessorInline {
    public List<Integer> process(List<Integer> items) {
        List<Integer> result = new ArrayList<>();
        for (Integer i : items) {
            if (i % 2 == 0) {
                result.add(i * 2);
            }
        }
        return result;
    }
}
