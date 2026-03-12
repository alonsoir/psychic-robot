package com.example.perf.orders;

import java.util.ArrayList;
import java.util.List;

public class OrderProcessorSmallMethods {
    public List<Integer> process(List<Integer> orders) {
        List<Integer> result = new ArrayList<>();
        for (Integer o : orders) {
            if (validate(o)) {
                result.add(transform(o));
            }
        }
        return result;
    }

    private boolean validate(Integer x) { return x % 2 == 0; }
    private int transform(Integer x) { return x * 2; }
}
