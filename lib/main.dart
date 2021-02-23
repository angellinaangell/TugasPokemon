import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokemon/pokemon.dart';
import 'package:pokemon/pokemondetail.dart';

void main() {
  runApp(new MaterialApp(
    title: "Pokemon",
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;
  PokeHub angelHub;
  bool searchingPoke = false;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);

    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
    angelHub = PokeHub.fromJson(decodedJson);
    print(angelHub.toJson());
  }

  void filterPoke(value){
    setState(() {
      var angelData = pokeHub.pokemon.where((pokemon) => pokemon.name.toLowerCase().contains(value.toLowerCase())).toList();
    if (angelData.length > 0) {
      angelHub.pokemon = angelData;
    }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(

         title: !searchingPoke
            ? new Text("Pokemon App")
            : TextField(
                onChanged: (value) {
                  filterPoke(value);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Your Pokemon Here",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        backgroundColor: Colors.pink[300],
        centerTitle: true,
        actions: <Widget>[
          searchingPoke
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.searchingPoke = false;
                      angelHub = pokeHub;
                    });
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.searchingPoke = true;
                    });
                  },
                )
        ],
      ),
      body: angelHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: angelHub.pokemon
                  .map((poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PokeDetail(
                              pokemon: poke, 
                            )));
                          },
                          child: Hero(
                            tag: poke.img,
                              child: Card(
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    height: 100.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(poke.img))),
                                  ),
                                  Text(
                                    poke.name,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink[700]
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            backgroundColor: Colors.pink[200],
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[

            new UserAccountsDrawerHeader(
              accountName: new Text("Angellina",style: TextStyle(color: Colors.black)), 
              accountEmail: new Text("angellina09092001@gmail.com",style: TextStyle(color: Colors.black)),
              currentAccountPicture:
              new CircleAvatar(
                backgroundImage: new NetworkImage("https://i1.wp.com/blackpinkupdate.com/wp-content/uploads/2019/06/1-BLACKPINK-Rose-Instagram-Update-7-June-2019.jpg?fit=1080%2C1349&ssl=1"),
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new NetworkImage("https://tse1.mm.bing.net/th?id=OIP.eI5oqNkpbgw8XcQ6UgwligHaEK&pid=Api&P=0&w=291&h=164"),
                fit: BoxFit.cover
                )
              ),
            ),
            new ListTile(
              title: new Text("Setting"),
              trailing: new Icon(Icons.settings),
            ),
             new ListTile(
              title: new Text("Close"),
              trailing: new Icon(Icons.close),
            ),
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan[200],
        child: Icon(Icons.refresh),


      ),
    );
  }
}
