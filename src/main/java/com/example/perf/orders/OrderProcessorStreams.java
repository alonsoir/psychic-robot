package com.example.perf.orders;

import java.util.*;
import java.util.stream.*;

public class OrderProcessorStreams {
    public List<Integer> process(List<Integer> items) {
        return items.stream()
            .filter(i -> i % 2 == 0)
            .map(i -> i * 2)
            .collect(Collectors.toList());
    }
}
