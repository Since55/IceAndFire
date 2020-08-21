import 'dart:convert';

import 'package:ice_and_fire/api-service.dart';

class Character {
  final String url;
  final String name;
  final String gender;
  final String culture;

  Character({this.url, this.name, this.gender, this.culture});

  factory Character.fromJson(Map<String,dynamic> json) {

    return Character(
        url: json['url'],
        name: json['name'] == '' ? json['name'] = 'No Name' : json['name'],
        gender: json['gender'],
        culture: json['culture']
    );
  }


  static Resource<List<Character>> get all {

    return Resource(
        url: 'https://anapioficeandfire.com/api/characters?page=1&pageSize=100',
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Character.fromJson(model)).toList();
        }
    );

  }
}