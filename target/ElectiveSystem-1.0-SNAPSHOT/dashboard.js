/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// Make function global
// Make function global
// Make function global
//window.showSection = function(id) {
//    let sections = document.querySelectorAll(".section");
//
//    sections.forEach(function(s) {
//        s.classList.remove("active");
//    });
//
//    document.getElementById(id).classList.add("active");
//};
//
//// FIX FOR 3 DOT MENU
//window.toggleMenu = function() {
//    let menu = document.getElementById("dropdown");
//
//    if (menu.style.display === "block") {
//        menu.style.display = "none";
//    } else {
//        menu.style.display = "block";
//    }
//};

//
//window.showSection = function(id) {
//    let sections = document.querySelectorAll(".section");
//    sections.forEach(s => s.classList.remove("active"));
//    document.getElementById(id).classList.add("active");
//};
//
//window.toggleMenu = function() {
//    let menu = document.getElementById("dropdown");
//    menu.style.display = (menu.style.display === "block") ? "none" : "block";
//};

window.showSection = function(id) {
    let sections = document.querySelectorAll(".section");
    sections.forEach(s => s.classList.remove("active"));

    document.getElementById(id).classList.add("active");
};

window.toggleMenu = function() {
    let menu = document.getElementById("dropdown");

    if (menu.style.display === "block") {
        menu.style.display = "none";
    } else {
        menu.style.display = "block";
    }
};