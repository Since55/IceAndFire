import 'package:flutter/material.dart';
import 'package:ice_and_fire/api-service.dart';
import 'package:ice_and_fire/character.dart';

class CharacterList extends StatefulWidget {
  final Character character;

  const CharacterList({Key key, this.character}) : super(key: key);

  @override
  createState() => CharactersListState();
}


class CharactersListState extends State<CharacterList> {

  List<Character> _characters = List<Character>();

  List<Character> _toDisplayCharacters = List<Character>();

  bool reversed = false;

  TextEditingController _textController = TextEditingController();

  onItemChanged(String value) {
    print(value);
    setState(() {
      _toDisplayCharacters = _characters
          .where((string) => string.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  onSortPressed() {
    setState(() {
      reversed = !reversed;
      _toDisplayCharacters.sort( (a, b) {
        return a.name.compareTo(b.name);
      });
      if(reversed) {
        _toDisplayCharacters = _toDisplayCharacters.reversed.toList();
      }

    });
  }

  @override
  void initState() {
    super.initState();
    _populateCharacters();
  }

  void _populateCharacters() {

    Webservice().load(Character.all).then((character) => {
      setState(() => {
        _characters = character,
        _toDisplayCharacters = _characters
      })
    });

  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      title: Text('${_toDisplayCharacters[index].name == '' ? "No Name" : _toDisplayCharacters[index].name }'),
      subtitle: Text('${_toDisplayCharacters[index].gender}, '
          '${_toDisplayCharacters[index].culture == ''? "No culture" : _toDisplayCharacters[index].culture }', style: TextStyle(fontSize: 14)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ice And Fire'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                ),
                onChanged: onItemChanged,
              ),
            ),
            RaisedButton(
                child: Text(
                  'Sort',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: onSortPressed,

            ),
            Expanded(child:
            ListView.builder(
              itemCount: _toDisplayCharacters.length,
              itemBuilder: _buildItemsForListView,
            ))
          ],
        )
    );
  }
}



void main() => runApp(App());


class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Ice and Fire",
        home: CharacterList()
    );
  }

}