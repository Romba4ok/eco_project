import 'dart:io';
import 'package:Eco/appSizes.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPostPage extends StatefulWidget {
  final Function(int) togglePage;

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

  String? contentValidator(String? value) {
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
  final TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _savePost() async {
    if (_selectedImage != null && headingController.text.isNotEmpty && sourceController.text.isNotEmpty && contentController.text.isNotEmpty) {
      // Вызываем метод сервиса для сохранения поста
      await _databaseService.savePost(_selectedImage!, headingController.text, sourceController.text, contentController.text);
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
                  'Управление постами',
                  style: TextStyle(
                      color: Colors.white, fontSize: AppSizes.width * 0.08),
                ),
                SizedBox(height: AppSizes.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Действие при нажатии
                      },
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
                                  'Добавить пост',
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
                          debugPrint('1');
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
                                  'Редактировать пост',
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
                          'Добавить пост',
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
                  width: AppSizes.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      width: 2,
                      color: Color(0xFF393535),
                    ),
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
                          SizedBox(height: AppSizes.height * 0.01),
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
                              fillColor: Color(0xFF1E1E1E),
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
                            maxLines: 1,
                            keyboardType: TextInputType.multiline,
                          ),
                          SizedBox(height: AppSizes.height * 0.01),
                          Text(
                            'Введите содержание:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.04,
                            ),
                          ),
                          SizedBox(height: AppSizes.height * 0.01),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: contentController,
                            decoration: InputDecoration(
                              hintText: "Ввести текст...",
                              hintStyle: TextStyle(color: Color(0xFF909090)),
                              filled: true,
                                fillColor: Color(0xFF1E1E1E),
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
                            validator: contentValidator,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                          ),
                          SizedBox(height: AppSizes.height * 0.01),
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
                                    fillColor: Color(0xFF1E1E1E),
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
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await _savePost();
                                      widget.togglePage(1);
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
    String? imageUrl, // Добавленный параметр для ссылки на изображение
    required Future<void> Function(FormFieldState<File?> fieldState) onPickImage,
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
              child: state.value != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(
                  state.value!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
                  : (imageUrl != null && imageUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                ),
              )
                  : _buildPlaceholder()),
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

  static Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/add_image.png',
          width: AppSizes.width * 0.07,
          height: AppSizes.height * 0.03,
        ),
        SizedBox(height: AppSizes.height * 0.007),
        Text(
          'Добавить изображение',
          style: TextStyle(
            color: Color(0xFF909090),
            fontSize: AppSizes.width * 0.04,
          ),
        ),
      ],
    );
  }
}