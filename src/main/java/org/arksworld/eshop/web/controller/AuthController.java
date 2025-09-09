package org.arksworld.eshop.web.controller;

import org.arksworld.eshop.dto.AuthResponse;
import org.arksworld.eshop.dto.LoginRequest;
import org.arksworld.eshop.dto.RegisterRequest;
import org.arksworld.eshop.web.security.AuthService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public AuthResponse register(@RequestBody RegisterRequest request) {
        String token = authService.register(request);
        return AuthResponse.builder().token(token).build();
    }

    @PostMapping("/login")
    public AuthResponse login(@RequestBody LoginRequest request) {
        String token = authService.login(request);
        return AuthResponse.builder().token(token).build();
    }
}
