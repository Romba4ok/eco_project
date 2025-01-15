import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SearchableUserList(),));
}

class User {
  final String name;
  final String location;
  final String email;
  final String id;

  User({required this.name, required this.location, required this.email, required this.id});
}

class SearchableUserList extends StatefulWidget {
  @override
  _SearchableUserListState createState() => _SearchableUserListState();
}

class _SearchableUserListState extends State<SearchableUserList> {
  final List<User> users = [
    User(name: 'Сагир кет', location: 'Штрафастан, Almaty', email: 'mercale@gmail.com', id: 'id:0000001'),
    User(name: 'Рома Лев', location: 'Kazakhstan, Almaty', email: 'levroma@gmail.com', id: 'id:0000002'),
    User(name: 'Даниал Булдак', location: 'Buldakstan, Almaty', email: 'ilovebuldak@gmail.com', id: 'id:0000003'),
    User(name: 'Руфат нефр', location: 'Nefrstan, Almaty', email: 'ilovefemboys@gmail.com', id: 'id:0000004'),
    User(name: 'Бекжан чорни', location: 'Nachalkistan, Almaty', email: 'Realboss@gmail.com', id: 'id:0000005'),
    User(name: 'Гульзат Халима', location: 'Kazakhstan, Almaty', email: 'Halmi@gmail.com', id: 'id:0000006'),
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Фильтруем пользователей на основе строки поиска
    List<User> filteredUsers = users.where((user) {
      String lowerQuery = searchQuery.toLowerCase();
      return user.name.toLowerCase().contains(lowerQuery) ||
          user.location.toLowerCase().contains(lowerQuery) ||
          user.email.toLowerCase().contains(lowerQuery) ||
          user.id.toLowerCase().contains(lowerQuery);
    }).toList();

    // Сортируем по количеству совпадений
    filteredUsers.sort((a, b) {
      int aMatches = _countMatches(a, searchQuery);
      int bMatches = _countMatches(b, searchQuery);
      return bMatches.compareTo(aMatches); // Убывающая сортировка
    });

    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Row(
          children: [
            Icon(Icons.group, color: Color(0xFFA3E567)),
            SizedBox(width: 8.0),
            Text('Список пользователей', style: TextStyle(color: Colors.white)),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Color(0xFFA3E567)),
                hintText: 'Поиск',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF292626),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(user.name[0], style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(user.name, style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    '${user.location}\n${user.email}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Icon(Icons.settings, color: Color(0xFFA3E567)),
                  isThreeLine: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Подсчёт количества совпадений
  int _countMatches(User user, String query) {
    if (query.isEmpty) return 0;
    String lowerQuery = query.toLowerCase();
    int matches = 0;
    if (user.name.toLowerCase().contains(lowerQuery)) matches++;
    if (user.location.toLowerCase().contains(lowerQuery)) matches++;
    if (user.email.toLowerCase().contains(lowerQuery)) matches++;
    if (user.id.toLowerCase().contains(lowerQuery)) matches++;
    return matches;
  }
}
