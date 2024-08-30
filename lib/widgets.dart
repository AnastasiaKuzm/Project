import 'package:flutter/material.dart'; 
import 'package:dio/dio.dart'; 
import 'package:cached_network_image/cached_network_image.dart';


class CharacterNames extends StatefulWidget {
  final String statusFilter; 
  const CharacterNames({super.key, required this.statusFilter});

  @override
  CharacterNamesState createState() => CharacterNamesState();
}

class CharacterNamesState extends State<CharacterNames> {
  List<Character> names = [];

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchCharacterNames();
   
  }

  Future<void> fetchCharacterNames() async {
    String baseUrl = 'https://rickandmortyapi.com/api/character';
    String? nextUrl = baseUrl;
    while (nextUrl != null) {
      final response = await dio.get(nextUrl);
      final data = response.data;
      final results = data['results'];

      setState(() {
        names.addAll(results.map<Character>((item) {
          return Character(
            id: item['id'],
            name: item['name'],
            image: item['image'],
            status: item['status'],
            
          );
        }).toList());
      });

      nextUrl = data['info']['next'];
    }
  }

 

  @override
  Widget build(BuildContext context)  {
    final filteredNames = names.where((character) {
      return widget.statusFilter == 'All' || character.status == widget.statusFilter;
    }).toList();

    return Containers(names: filteredNames);
  }
}



class Rickandmorty extends StatefulWidget {
  const Rickandmorty({super.key});

  @override
  State<Rickandmorty> createState() => RickandmortyState();
}

class RickandmortyState extends State<Rickandmorty> {
  String selectedStatus = 'Dead';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 70, left: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rick and Morty',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Characters',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  Row(
                    children: [
                      Buttons(
                          onPressed: () {
                            setState(() {
                              selectedStatus = 'Dead';
                            });
                          },
                          text: 'Dead',isActive: selectedStatus == 'Dead'),
                      const SizedBox(width: 10),
                      Buttons(
                          onPressed: () {
                            setState(() {
                              selectedStatus = 'Alive';
                            });
                          },
                          text: 'Alive',isActive: selectedStatus == 'Alive'),
                      const SizedBox(width: 10),
                      Buttons(
                          onPressed: () {
                            setState(() {
                              selectedStatus = 'unknown';
                            });
                          },
                          text: 'Unknown', isActive: selectedStatus == 'unknown' ),
                    ],
                  ),
                   Expanded(
                    child: CharacterNames(statusFilter: selectedStatus), 
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


class Containers extends StatelessWidget {
  final List<Character> names;

  const Containers({super.key, required this.names});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (names.length / 2).ceil(),  
      itemBuilder: (context, index) {
        final int firstIndex = index * 2;
        final int secondIndex = firstIndex + 1;

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  
                  child: buildCharacterContainer(names[firstIndex]),
                ),
              ),
              if (secondIndex < names.length)
                Expanded(
                  child: Container(
                   
                    child: buildCharacterContainer(names[secondIndex]),
                  ),
                ),
              if (secondIndex >= names.length) Expanded(child: Container()),
            ],
          
        );
      },
    );
  }

  Widget buildCharacterContainer(Character character) {
    return 
        Align(
          alignment: Alignment.centerLeft,
         child: Padding(
           padding: const EdgeInsets.only(bottom: 14),
           child: Container(

            width: 164,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: CachedNetworkImage(
                    imageUrl: character.image,
                    fit: BoxFit.cover,
                    width: 164,
                    height: 145,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color.fromRGBO(30, 41, 59, 1),
                    ),
                  ),
                  const Text(
                    'Last location:',
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(30, 41, 59, 1),
                    ),
                  ),
                ],
              ),
            ),
                   ],
                 ),
               ),
         ),
  );
}
}   

    
  



 class Buttons extends StatelessWidget { 
   final VoidCallback onPressed; 
   final String text; 
   final bool isActive;
 const Buttons({
   super.key,
   required this.onPressed, 
   required this.text, 
   required this.isActive}); 

   
  @override 
  Widget build(BuildContext context) { 

    final ButtonStyle style = 
        ElevatedButton.styleFrom( 
          minimumSize: const Size(47, 35), 
          padding: const EdgeInsets.symmetric(horizontal: 17), 
          textStyle: const TextStyle( 
          letterSpacing: 1.0, 
          fontWeight: FontWeight.bold, 
          fontSize: 16),  
          backgroundColor:  isActive? const Color.fromRGBO(255, 79, 79, 1): const Color.fromRGBO(222, 222, 222, 1),  
          foregroundColor: isActive ? Colors.white : const Color.fromRGBO(30, 41, 59, 1),); 
    return Row( 
             children: [ 
              ElevatedButton( 
               style:style, 
               onPressed:onPressed, 
               child:  Text(text)), 
             ], 
    ); 
  } 

} 

class Character {
  final int id;
  final String name;
  final String image;
  final String status;
  

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      status: json['status'] as String,
     
    );
  }
  

 @override
  String toString() {
    return 'Character {id: $id, name: $name,  image: $image, image: $status}';
  }
}
class CharacterResponse {
  final List<Character> results;

  CharacterResponse({required this.results});

  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Character> characters = list.map((e) => Character.fromJson(e)).toList();
    return CharacterResponse(results: characters);
  }
}

 