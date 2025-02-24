import 'dart:io';

import 'package:Eco/add_post.dart';
import 'package:Eco/appSizes.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPostPage extends StatefulWidget {
  final Function(int) togglePage;

  EditPostPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _EditPostPageState();
  }
}

class _EditPostPageState extends State<EditPostPage> {
  bool _isExpanded = true;
  bool isLoading = true;
  String? imageUrl;

  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, String>> posts = [];

  Future<void> loadPosts() async {
    List<Map<String, String>> fetchedPosts =
        await _databaseService.fetchPosts();
    if (mounted) {
      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF131010),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: AppSizes.width * 0.05, right: AppSizes.width * 0.05),
            child: Column(
              children: [
                SizedBox(
                  height: AppSizes.height * 0.07,
                ),
                Text(
                  'Управление постами',
                  style: TextStyle(
                      color: Colors.white, fontSize: AppSizes.width * 0.08),
                ),
                SizedBox(
                  height: AppSizes.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: AppSizes.height * 0.14,
                      width: AppSizes.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xFF393535),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.togglePage(0);
                          });
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.topLeft,
                          // Поднимаем содержимое вверх и влево
                          padding: EdgeInsets
                              .zero, // Убираем внутренние отступы, если нужно
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
                                // Используем Expanded, чтобы текст занял оставшееся пространство
                                child: Text(
                                  'Добавить пост',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.045,
                                  ),
                                  softWrap:
                                      true, // Включаем softWrap для переноса текста
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: AppSizes.height * 0.14,
                      width: AppSizes.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xFF393535),
                        border: Border.all(
                          color: Color(0xFF68E30B), // Цвет границы
                          width: 2, // Толщина границы
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          alignment: Alignment.topLeft,
                          // Поднимаем содержимое вверх и влево
                          padding: EdgeInsets
                              .zero, // Убираем внутренние отступы, если нужно
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
                                // Используем Expanded, чтобы текст занял оставшееся пространство
                                child: Text(
                                  'Редактировать пост',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.043,
                                  ),
                                  softWrap:
                                      true, // Включаем softWrap для переноса текста
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Color(0xFF676DE5),
                        ),
                        SizedBox(
                          width: AppSizes.width * 0.01,
                        ),
                        Text(
                          'Редактировать пост',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.05,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _toggleExpand,
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _isExpanded ? AppSizes.height * 0.6 : 0,
                  curve: Curves.easeInOut,
                  child: isLoading
                      ? SizedBox(
                          height: AppSizes.height * 0.8,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Container(
                          height: AppSizes.height * 0.6, // Высота GridView
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.width * 0.02),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Две колонки
                              mainAxisSpacing: 8, // Отступ между рядами
                              crossAxisSpacing: 8, // Отступ между колонками
                              childAspectRatio:
                                  3 / 4, // Соотношение сторон карточки
                            ),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return GestureDetector(
                                onTap: () {
                                  int id = int.tryParse(post['id'].toString()) ?? 0;
                                  sourceController.text = post['source'] ?? '';
                                  headingController.text = post['title'] ?? '';
                                  imageUrl = post['image'];
                                  print(imageUrl);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Color(0xFF393535),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        content: SizedBox(
                                          width: AppSizes.width * 0.75,
                                          height: AppSizes.height * 0.55,
                                          // 60% от высоты экрана
                                          child: SingleChildScrollView(
                                            // Прокрутка, если контент выходит за границы
                                            child: Form(
                                              key: _formKey,
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    AppSizes.width * 0.04),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ImagePickerFormField(
                                                      initialValue: _selectedImage,
                                                      imageUrl: imageUrl, // Ссылка на изображение
                                                      onPickImage: _pickImage,
                                                      validator: (value) {
                                                        if (value == null && (imageUrl == null || imageUrl!.isEmpty)) {
                                                          return 'Пожалуйста, выберите изображение.';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            AppSizes.height *
                                                                0.02),
                                                    Text(
                                                      'Введите заголовок:',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            AppSizes.width *
                                                                0.04,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            AppSizes.height *
                                                                0.01),
                                                    TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      controller:
                                                          headingController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Ввести текст...",
                                                        hintStyle: TextStyle(
                                                            color: Color(
                                                                0xFF909090)),
                                                        filled: true,
                                                        fillColor:
                                                            Color(0xFF393535),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF565656)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF565656)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                      ),
                                                      validator:
                                                          headingValidator,
                                                      maxLines: 6,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            AppSizes.height *
                                                                0.02),
                                                    Text(
                                                      'Источник:',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            AppSizes.width *
                                                                0.04,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            AppSizes.height *
                                                                0.01),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            controller:
                                                                sourceController,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "https://example.com...",
                                                              hintStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFF909090)),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFF393535),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF565656)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF565656)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color: Colors
                                                                            .red),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color: Colors
                                                                            .red),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                            ),
                                                            validator:
                                                                sourceValidator,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                AppSizes.width *
                                                                    0.03),
                                                        Container(
                                                          height:
                                                              AppSizes.height *
                                                                  0.06,
                                                          width:
                                                              AppSizes.width *
                                                                  0.2,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            color: Color(
                                                                0xFF292626),
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () async {
                                                              if (_formKey.currentState!.validate()) {
                                                                try {
                                                                  await DatabaseService().updatePost(
                                                                    postId: id,
                                                                    newHeading: headingController.text,
                                                                    newSource: sourceController.text,
                                                                    newImage: _selectedImage,
                                                                  );

                                                                  // Закрываем диалог
                                                                  Navigator.of(context).pop();

                                                                  // Обновляем экран
                                                                  setState(() {
                                                                    _selectedImage = null;
                                                                    loadPosts();
                                                                  });
                                                                } catch (e) {
                                                                  print("Ошибка при обновлении поста: $e");
                                                                }
                                                              }
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                'Сохранить',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF909090),
                                                                  fontSize:
                                                                      AppSizes.width *
                                                                          0.033,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).then((_) {
                                    setState(() {
                                      _selectedImage = null;// Обнуляем после закрытия диалога
                                    });
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black, // Черный фон карточки
                                    borderRadius: BorderRadius.circular(
                                        12), // Закругленные углы
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            // Закругленные углы внизу
                                            bottomRight: Radius.circular(12),
                                          ),
                                          child: SizedBox(
                                            width: AppSizes.width * 0.45,
                                            // Ширина изображения
                                            child: Image.network(
                                              post['image']!,
                                              fit: BoxFit
                                                  .cover, // Заполняет контейнер, обрезая края
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppSizes.height * 0.005,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: AppSizes.width * 0.02,
                                            right: AppSizes.width * 0.02),
                                        child: Text(
                                          post['title']!,
                                          style: TextStyle(
                                            fontSize: AppSizes.width * 0.05,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppSizes.height * 0.005,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: AppSizes.width * 0.02),
                                        child: Text(
                                          post['source']!,
                                          style: TextStyle(
                                            fontSize: AppSizes.width * 0.035,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
