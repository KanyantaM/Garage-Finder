import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(String title) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,),
        
      ),
      elevation: 2,
      centerTitle: true,
    );
  }