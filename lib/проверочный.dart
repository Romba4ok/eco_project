import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  bool _selection = true; // Управляющая переменная

  void toggleSelection() {
    setState(() {
      _selection = !_selection; // Меняем значение
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Управление постами"),
      ),
      body: Center(
        child: _selection
            ? AddPostView(onToggle: toggleSelection)
            : EditPostView(onToggle: toggleSelection),
      ),
    );
  }
}

// Виджет для добавления поста
class AddPostView extends StatelessWidget {
  final VoidCallback onToggle;

  const AddPostView({Key? key, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Добавить пост",
          style: TextStyle(fontSize: 24),
        ),
        ElevatedButton(
          onPressed: onToggle,
          child: Text("Переключиться на редактирование"),
        ),
      ],
    );
  }
}

// Виджет для редактирования поста
class EditPostView extends StatelessWidget {
  final VoidCallback onToggle;

  const EditPostView({Key? key, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Редактировать пост",
          style: TextStyle(fontSize: 24),
        ),
        ElevatedButton(
          onPressed: onToggle,
          child: Text("Переключиться на добавление"),
        ),
      ],
    );
  }
}
