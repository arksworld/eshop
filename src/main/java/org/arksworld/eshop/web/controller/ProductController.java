package org.arksworld.eshop.web.controller;

import org.arksworld.eshop.dto.ProductDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class ProductController {

    @GetMapping("/products")
    public ResponseEntity<List<ProductDTO>> getProducts() {
        List<ProductDTO> products = new ArrayList<>();
        products.add(ProductDTO.builder().id(101).name("Samsung").description("Samsung phone").build());
        products.add(ProductDTO.builder().id(102).name("Apple").description("Apple phone").build());
        products.add(ProductDTO.builder().id(103).name("Honor").description("Honor phone").build());
        return ResponseEntity.ok(products);
    }
}
