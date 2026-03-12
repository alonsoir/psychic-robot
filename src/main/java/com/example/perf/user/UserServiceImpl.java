package com.example.perf.user;

public class UserServiceImpl implements UserService {
    @Override
    public User getUserById(String id) {
        return new User(id);
    }
}
