import 'package:flutter/material.dart';

class Url {
  final String shortUrl;
  final String hash;

  Url({
    @required this.shortUrl,
    @required this.hash,
  });

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      shortUrl: json['shortUrl'] as String,
      hash: json['hash'] as String,
    );
  }
}