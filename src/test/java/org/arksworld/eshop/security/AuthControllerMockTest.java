package org.arksworld.eshop.security;


import org.arksworld.eshop.web.controller.AuthController;
import org.arksworld.eshop.web.security.AuthService;
import org.arksworld.eshop.repository.UserRepository;
import org.arksworld.eshop.web.security.JwtUtil;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.server.ResponseStatusException;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AuthController.class)
@AutoConfigureMockMvc(addFilters = false)
class AuthControllerMockTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private AuthService authService;

    @MockitoBean
    private UserRepository userRepository;

    @MockitoBean
    private AuthenticationManager authManager;

    @MockitoBean
    private JwtUtil jwtUtil;

    @MockitoBean
    private PasswordEncoder passwordEncoder;

    @Test
    void testLoginSuccess() throws Exception {
        String token = "mock-jwt-token";
        /*Mockito.when(jwtUtil.generateToken("john")).thenReturn(token);

        Authentication auth = new UsernamePasswordAuthenticationToken("john", "password123");
        Mockito.when(authManager.authenticate(any())).thenReturn(auth);
*/
        Mockito.when(authService.login(Mockito.any())).thenReturn(token);


        String loginJson = """
            { "username": "john", "password": "password123" }
            """;

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(loginJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").value(token));
    }

    @Test
    void testLoginFailure() throws Exception {
        /*Mockito.when(authManager.authenticate(any()))
                .thenThrow(new org.springframework.security.core.AuthenticationException("Bad creds") {});
*/
        Mockito.when(authService.login(Mockito.any()))
                .thenThrow(new ResponseStatusException(org.springframework.http.HttpStatus.UNAUTHORIZED, "Bad credentials"));

        String loginJson = """
            { "username": "john", "password": "wrongpass" }
            """;

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(loginJson))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void testLogout() throws Exception {
        mockMvc.perform(post("/api/auth/logout"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Logout successful")));
    }
}

