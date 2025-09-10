package org.arksworld.eshop.web.controller;

import lombok.Getter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        System.out.println("Page controller: Login");
        return "login";
    }

    @GetMapping("/logoutPage")
    public String logout() {
        System.out.println("Page controller: Logout");
        return "logout";
    }
}
