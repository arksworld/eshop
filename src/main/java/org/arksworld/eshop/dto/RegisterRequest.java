package org.arksworld.eshop.dto;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegisterRequest {
    private String username;
    private String email;
    private String password;
    private String phone;
    private String role; // e.g. USER, MERCHANT
}




