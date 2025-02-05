import 'dart:io';
import 'package:ecoalmaty/AppSizes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPostPage extends StatefulWidget {
  final VoidCallback togglePage;

  AddPostPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _AddPostPageState();
  }
}

class _AddPostPageState extends State<AddPostPage> {
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

  Future<void> savePost(File image, String heading, String source) async {
    try {
      // Шаг 1: Загрузка изображения в Supabase Storage
      final fileName =
          'post_images/${DateTime.now().millisecondsSinceEpoch}.png'; // Уникальное имя файла
      await Supabase.instance.client.storage
          .from('posts') // Папка "posts" в Storage
          .upload(fileName, image);

      // Шаг 2: Получение URL изображения
      final imageUrl = await Supabase.instance.client.storage
          .from('posts')
          .getPublicUrl(fileName); // Получаем публичный URL изображения
      print(imageUrl);
      // Шаг 3: Добавление данных о посте в таблицу 'posts'
      await Supabase.instance.client.from('posts').insert({
        'image': imageUrl, // UUID пользователя из auth
        'heading': headingController.text,
        'source': sourceController.text,
      });
      // Сообщение об успешном добавлении
      print('Пост успешно добавлен в Realtime Database!');
      if (mounted) {
        widget.togglePage();
      }
    } catch (error) {
      // Обработка ошибок
      print('Ошибка: $error');
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
                  'Управление постами',
                  style: TextStyle(
                      color: Colors.white, fontSize: AppSizes.width * 0.08),
                ),
                SizedBox(height: AppSizes.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: AppSizes.height * 0.14,
                      width: AppSizes.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: Color(0xFF68E30B), // Цвет границы
                          width: 2, // Толщина границы
                        ),
                        color: Color(0xFF393535),
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
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.togglePage();
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
                SizedBox(height: AppSizes.height * 0.03),
                Container(
                  width: AppSizes.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xFF393535),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.width * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImagePickerFormField(
                            initialValue: _selectedImage,
                            onPickImage: _pickImage,
                            validator: (value) {
                              if (value == null) {
                                return 'Пожалуйста, выберите изображение.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSizes.height * 0.02),
                          Text(
                            'Введите заголовок:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.04,
                            ),
                          ),
                          SizedBox(height: AppSizes.height * 0.01),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: headingController,
                            decoration: InputDecoration(
                              hintText: "Ввести текст...",
                              hintStyle: TextStyle(color: Color(0xFF909090)),
                              filled: true,
                              fillColor: Color(0xFF393535),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF565656)),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF565656)),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            validator: headingValidator,
                            maxLines: 6,
                            keyboardType: TextInputType.multiline,
                          ),
                          SizedBox(height: AppSizes.height * 0.02),
                          Text(
                            'Источник:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.04,
                            ),
                          ),
                          SizedBox(height: AppSizes.height * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: sourceController,
                                  decoration: InputDecoration(
                                    hintText: "https://example.com...",
                                    hintStyle:
                                        TextStyle(color: Color(0xFF909090)),
                                    filled: true,
                                    fillColor: Color(0xFF393535),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF565656)),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF565656)),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  validator: sourceValidator,
                                ),
                              ),
                              SizedBox(width: AppSizes.width * 0.03),
                              Container(
                                height: AppSizes.height * 0.06,
                                width: AppSizes.width * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Color(0xFF292626),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      savePost(
                                          _selectedImage!,
                                          headingController.text,
                                          sourceController.text);
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Сохранить',
                                      style: TextStyle(
                                        color: Color(0xFF909090),
                                        fontSize: AppSizes.width * 0.033,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePickerFormField extends FormField<File?> {
  ImagePickerFormField({
    Key? key,
    File? initialValue,
    required Future<void> Function(FormFieldState<File?> fieldState)
        onPickImage,
    FormFieldValidator<File?>? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: validator,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => onPickImage(state),
                  child: Container(
                    height: AppSizes.height * 0.17,
                    width: AppSizes.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xFF292626),
                    ),
                    child: state.value == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/add_image.png',
                                width: AppSizes.width * 0.07,
                                height: AppSizes.height * 0.03,
                              ),
                              SizedBox(
                                height: AppSizes.height * 0.007,
                              ),
                              Text(
                                'Добавить изображение',
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: AppSizes.width * 0.04,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.file(
                              state.value!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ),
              ],
            );
          },
        );
}
