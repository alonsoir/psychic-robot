#!/bin/bash
set -e

# Detectar Java
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
    JAVA_BIN="$JAVA_HOME/bin/java"
elif [ -x "$HOME/.sdkman/candidates/java/current/bin/java" ]; then
    JAVA_BIN="$HOME/.sdkman/candidates/java/current/bin/java"
else
    echo "No se encontró Java. Instala un JDK o configura JAVA_HOME."
    exit 1
fi

export PATH="$(dirname "$JAVA_BIN"):$PATH"
echo "Usando Java en: $JAVA_BIN"
$JAVA_BIN -version

# Directorios base
BASE_DIR="$(pwd)"
SRC_DIR="$BASE_DIR/src/main/java/com/example/perf"

echo "Creando estructura de carpetas..."
mkdir -p "$SRC_DIR/orders" "$SRC_DIR/user"

echo "Creando UserService y UserServiceConcrete..."
cat > "$SRC_DIR/user/User.java" <<'EOF'
package com.example.perf.user;

public class User {
    private final String id;
    public User(String id) { this.id = id; }
    public String getId() { return id; }
}
EOF

cat > "$SRC_DIR/user/UserService.java" <<'EOF'
package com.example.perf.user;

public interface UserService {
    User getUserById(String id);
}
EOF

cat > "$SRC_DIR/user/UserServiceImpl.java" <<'EOF'
package com.example.perf.user;

public class UserServiceImpl implements UserService {
    @Override
    public User getUserById(String id) {
        return new User(id);
    }
}
EOF

cat > "$SRC_DIR/user/UserServiceConcrete.java" <<'EOF'
package com.example.perf.user;

public class UserServiceConcrete {
    public User getUserById(String id) {
        return new User(id);
    }
}
EOF

echo "Creando OrderProcessorStreams e OrderProcessorInline..."
cat > "$SRC_DIR/orders/OrderProcessorStreams.java" <<'EOF'
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
EOF

cat > "$SRC_DIR/orders/OrderProcessorInline.java" <<'EOF'
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
EOF

echo "Creando Main.java..."
cat > "$SRC_DIR/Main.java" <<'EOF'
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
EOF

echo "Compilando..."
javac -d out $(find src -name "*.java")

echo "Ejecutando benchmark..."
$JAVA_BIN -cp out com.example.perf.Main