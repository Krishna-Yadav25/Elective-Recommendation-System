/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.elective.electivesystem;

/**
 *
 * @author krish
 */


import java.security.MessageDigest;

public class TestHash {

    public static void main(String[] args) throws Exception {

        String password = "admin123"; // 👈 yaha apna password likh

        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());

        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            hex.append(String.format("%02x", b));
        }

        System.out.println("HASH = " + hex.toString());
    }
}
