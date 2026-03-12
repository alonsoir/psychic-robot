package com.example.perf.orders;

import java.util.ArrayList;
import java.util.List;

public class OrderProcessorLargeMethods {
    public List<Integer> process(List<Integer> orders) {
        List<Integer> result = new ArrayList<>();
        for (Integer x : orders) {
            if (x % 2 == 0) result.add(x * 2);
        }
        return result;
    }
}
