package com.example.perf.user;

public class UserServiceConcrete {
    public User getUserById(String id) {
        return new User(id);
    }
}
