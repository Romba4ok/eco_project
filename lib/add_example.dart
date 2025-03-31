import 'dart:io';

import 'package:Eco/appSizes.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddExamplePage extends StatefulWidget {
  final Function(int) togglePage;

  AddExamplePage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _AddExamplePageState();
  }
}

class _AddExamplePageState extends State<AddExamplePage> {
  File? _selectedImage; // Хранит выбранное изображение

  Future<void> _pickImage(FormFieldState<File?> fieldState) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // Можно заменить на ImageSource.camera
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage =
            File(pickedFile.path); // Сохраняем выбранное изображение
      });
      fieldState.didChange(_selectedImage); // Уведомляем форму об изменении
    }
  }

  String? headingValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите заголовок';
    }
    return null;
  }

  String? sourceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите источник';
    }
    return null;
  }

  final TextEditingController headingController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _savePost() async {
    if (_selectedImage != null &&
        headingController.text.isNotEmpty &&
        sourceController.text.isNotEmpty) {
      // Вызываем метод сервиса для сохранения поста
      await _databaseService.savePost(
          _selectedImage!, headingController.text, sourceController.text, "");
    } else {
      // Показываем сообщение, если что-то не заполнено
      print('Пожалуйста, заполните все поля и выберите изображение.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131010),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
            child: Column(
              children: [
                SizedBox(height: AppSizes.height * 0.07),
                Text(
                  'Управление заданиями',
                  style: TextStyle(
                      color: Colors.white, fontSize: AppSizes.width * 0.08),
                ),
                SizedBox(height: AppSizes.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: AppSizes.height * 0.14,
                        width: AppSizes.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Color(0xFF68E30B), // Цвет границы
                            width: 2, // Толщина границы
                          ),
                          color: Color(0xFF393535),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.width * 0.02),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.add,
                                color: Color(0xFFA3E567),
                              ),
                              SizedBox(
                                width: AppSizes.width * 0.01,
                              ),
                              Expanded(
                                child: Text(
                                  'Добавить задания',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.045,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.togglePage(1);
                        });
                      },
                      child: Container(
                        height: AppSizes.height * 0.14,
                        width: AppSizes.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xFF393535),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.width * 0.02),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Color(0xFF676DE5),
                              ),
                              SizedBox(
                                width: AppSizes.width * 0.01,
                              ),
                              Expanded(
                                child: Text(
                                  'Редактировать задания',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.043,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                          widget.togglePage(2);
                      },
                      child: Container(
                        height: AppSizes.height * 0.1,
                        width: AppSizes.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xFF393535),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.width * 0.02),
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.width * 0.02),
                            child: Center(
                              child: Row(
                                children: [
                                  Container(
                                    width: AppSizes.width * 0.1,
                                    height: AppSizes.width * 0.1,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage('assets/images/ads.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  // Добавляем небольшой отступ
                                  Expanded(
                                    // Расширяем текст, чтобы он мог переноситься
                                    child: Text(
                                      'Спонсор',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.039,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.togglePage(3);
                        });
                      },
                      child: Container(
                        height: AppSizes.height * 0.1,
                        width: AppSizes.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xFF393535),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.width * 0.02),
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.width * 0.02),
                            child: Center(
                              child: Row(
                                children: [
                                  Container(
                                    width: AppSizes.width * 0.1,
                                    height: AppSizes.width * 0.1,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage('assets/images/ads.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  // Добавляем небольшой отступ
                                  Expanded(
                                    // Расширяем текст, чтобы он мог переноситься
                                    child: Text(
                                      'Редактировать',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.039,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.add,
                          color: Color(0xFFA3E567),
                        ),
                        SizedBox(
                          width: AppSizes.width * 0.01,
                        ),
                        Text(
                          'Добавить задания',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.05,
                          ),
                          softWrap:
                              true, // Включаем softWrap для переноса текста
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height * 0.01),
                Container(
                  width: 300, // Ширина контейнера
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E), // Тёмный фон
                    borderRadius:
                        BorderRadius.circular(20.0), // Закруглённые углы
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок и кнопка закрытия
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Заголовок",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.close, color: Colors.white),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Поле ввода заголовка
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF2A2A2A),
                          hintText: "Ввести заголовок задания...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      // Подзаголовок
                      Text(
                        "Краткое описание и награда",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Поле ввода описания
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF2A2A2A),
                          hintText: "Введите краткое описание...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      // Переключатель и награда
                      Row(
                        children: [
                          Text(
                            "Особое \nзадание",
                            style: TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Switch(
                            value: false,
                            onChanged: (bool value) {},
                            activeColor: Color(0xFF68E30B),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Награда:",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                "ecooin...",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Кнопка "Сохранить"
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: null, // Отключенная кнопка
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2A2A2A),
                            disabledBackgroundColor: Color(0xFF2A2A2A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            "Сохранить",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}