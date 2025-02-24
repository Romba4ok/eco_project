import 'dart:io';

import 'package:Eco/appSizes.dart';
import 'package:Eco/request.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) togglePage;

  ProfilePage({required this.togglePage});

  @override
  _StateProfilePage createState() => _StateProfilePage();
}

class _StateProfilePage extends State<ProfilePage> {
  String selector = 'authorization';
  final DatabaseService _databaseService = DatabaseService();
  final SupabaseClient supabase = Supabase.instance.client;
  String name = DatabaseService.userName ?? 'Загрузка';
  String email =  DatabaseService.userEmail ?? 'Загрузка';
  String password =  DatabaseService.userPassword ?? 'Загрузка';
  String avatar =  DatabaseService.userAvatar ?? '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController submitPasswordController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Map<String, String>? userData;
  bool isLoading = true;

  Future<void> _loadUserData() async {
    User? user = supabase.auth.currentUser;
    if (user != null) {
      String userId = user.id;
      Map<String, String>? fetchedUser = await _databaseService.fetchUser(
          userId);
      if (mounted) {
        setState(() {
          userData = fetchedUser;
          name = fetchedUser?['name'] ?? 'Загрузка';
          email = fetchedUser?['email'] ?? 'Загрузка';
          password = fetchedUser?['password'] ?? 'Загрузка';
          avatar = fetchedUser?['avatar'] ?? '';
          passwordController.text = password;
          newPasswordController.clear();
          submitPasswordController.clear();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateUser() async {
    if (mounted) {
      // Сначала выполняем асинхронную операцию, а затем обновляем состояние
      await _databaseService.updateUser(
        name: nameController.text,
        city: RequestCheck.city,
        state: RequestCheck.state,
        email: emailController.text,
        password: newPasswordController.text,
        newAvatar: _selectedImage, // Только если новая аватарка
      );
      _loadUserData();
      newPasswordController.text = '';
      nameController.text = '';
      emailController.text = '';
      submitPasswordController.text = '';
    }
  }

  File? _selectedImage; // Здесь сохраняется выбранное изображение как файл

// Логика для загрузки изображения, например, с устройства
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage =
            File(pickedFile.path); // Устанавливаем выбранное изображение
      });
    }
  }

  final _formKeyUpdatePassword = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscure2 = true;
  bool _isObscure3 = true;

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите имя';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Неверный формат email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 8) {
      return 'Пароль должен содержать не менее 8 символов';
    }
    return null;
  }

  String? newPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 8) {
      return 'Пароль должен содержать не менее 8 символов';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != newPasswordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppSizes.height * 0.1,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: AppSizes.width * 0.17,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (avatar.isNotEmpty
                          ? NetworkImage(avatar)
                          : null),
                      backgroundColor:
                      avatar.isEmpty && _selectedImage == null
                          ? Colors.white
                          : Colors.transparent,
                      child: avatar.isEmpty && _selectedImage == null
                          ? Text(
                        name[0],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: AppSizes.width * 0.08),
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          await _pickImage(); // Вызываем функцию выбора изображения
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF03E050),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit,
                              color: Colors.black, size: AppSizes.width * 0.05),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height * 0.01),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white, fontSize: AppSizes.width * 0.06),
                ),
                SizedBox(height: AppSizes.height * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  // Устанавливаем выравнивание по левому краю
                  child: Text(
                    'Ваш ник',
                    style: TextStyle(
                        color: Colors.white, fontSize: AppSizes.width * 0.045),
                  ),
                ),
                SizedBox(height: AppSizes.height * 0.01),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFF717171), // Задаем белый цвет для иконки
                      size: AppSizes.width * 0.06,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintStyle: TextStyle(
                      color: Color(0xFF717171),
                    ),
                    hintText: name,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF717171)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF717171)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // Цвет границы при ошибке
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // Граница при фокусе и ошибке
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: nameValidator,
                ),
                SizedBox(
                  height: AppSizes.height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  // Устанавливаем выравнивание по левому краю
                  child: Text(
                    'Почта',
                    style: TextStyle(
                        color: Colors.white, fontSize: AppSizes.width * 0.045),
                  ),
                ),
                SizedBox(height: AppSizes.height * 0.01),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFF717171), // Задаем белый цвет для иконки
                      size: AppSizes.width * 0.06,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintStyle: TextStyle(
                      color: Color(0xFF717171),
                    ),
                    hintText: email,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF717171)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF717171)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // Цвет границы при ошибке
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // Граница при фокусе и ошибке
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: emailValidator,
                ),
                SizedBox(
                  height: AppSizes.height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  // Устанавливаем выравнивание по левому краю
                  child: Text(
                    'Пароль',
                    style: TextStyle(
                        color: Colors.white, fontSize: AppSizes.width * 0.045),
                  ),
                ),
                SizedBox(height: AppSizes.height * 0.01),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: Color(0xFF717171), // Задаем белый цвет для иконки
                      size: AppSizes.width * 0.06,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintStyle: TextStyle(
                      color: Color(0xFF717171),
                    ),
                    hintText: "Ваш пароль",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF717171)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF717171)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // Цвет границы при ошибке
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // Граница при фокусе и ошибке
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure; // Переключение состояния
                        });
                      },
                    ),
                  ),
                  validator: passwordValidator,
                ),
                SizedBox(
                  height: AppSizes.height * 0.05,
                ),
                Form(
                  key: _formKeyUpdatePassword,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        // Устанавливаем выравнивание по левому краю
                        child: Text(
                          'Смена пароля',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.045),
                        ),
                      ),
                      SizedBox(height: AppSizes.height * 0.01),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: newPasswordController,
                        obscureText: _isObscure2,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.password,
                            color: Color(0xFF717171),
                            // Задаем белый цвет для иконки
                            size: AppSizes.width * 0.06,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintStyle: TextStyle(
                            color: Color(0xFF717171),
                          ),
                          hintText: "Новый пароль",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF717171)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF717171)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            // Цвет границы при ошибке
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            // Граница при фокусе и ошибке
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure2 =
                                !_isObscure2; // Переключение состояния
                              });
                            },
                          ),
                        ),
                        validator: newPasswordValidator,
                      ),
                      SizedBox(
                        height: AppSizes.height * 0.02,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: submitPasswordController,
                        obscureText: _isObscure3,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.password,
                            color: Color(0xFF717171),
                            // Задаем белый цвет для иконки
                            size: AppSizes.width * 0.06,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintStyle: TextStyle(
                            color: Color(0xFF717171),
                          ),
                          hintText: "Подтвердите пароль",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF717171)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF717171)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            // Цвет границы при ошибке
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            // Граница при фокусе и ошибке
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure3
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure3 =
                                !_isObscure3; // Переключение состояния
                              });
                            },
                          ),
                        ),
                        validator: confirmPasswordValidator,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.04,
                ),
                OutlinedButton(
                  onPressed: () {
                    if (newPasswordController.text.isNotEmpty) {
                      if (_formKeyUpdatePassword.currentState!.validate()) {
                        _updateUser();
                      }
                    } else {
                      _updateUser();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: AppSizes.height * 0.02,
                        horizontal: AppSizes.width * 0.33),
                    side: BorderSide(color: Color(0xFF68E30B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Сохранить',
                      style: TextStyle(
                          color: Color(0xFF68E30B),
                          fontSize: AppSizes.width * 0.045)),
                ),
                SizedBox(
                  height: AppSizes.height * 0.2,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                      top: AppSizes.height * 0.01,
                      right: AppSizes.width * 0.03),
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: AppSizes.width * 0.08,
                    ),
                    onPressed: () {
                      _showCustomDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListTile("Поддержка"),
              _buildMenuItem(context, Icons.subscriptions, "Моя подписка", () =>
                  _handleAction(context, "Моя подписка")),
              _buildMenuItem(context, Icons.help, "Помощь и поддержка", () =>
                  _handleAction(context, "Помощь и поддержка")),
              _buildMenuItem(context, Icons.info, "Условия и политика", () =>
                  _handleAction(context, "Условия и политика")),
              _buildListTile("Кэш и сотовая связь"),
              _buildMenuItem(context, Icons.delete, "Освободить место", () =>
                  _handleAction(context, "Освободить место")),
              _buildMenuItem(
                  context, Icons.data_saver_off, "Экономия данных", () =>
                  _handleAction(context, "Экономия данных")),
              _buildListTile("Действия"),
              _buildMenuItem(context, Icons.report, "Сообщить о проблеме", () =>
                  _handleAction(context, "Сообщить о проблеме")),
              _buildMenuItem(
                  context, Icons.person_add, "Добавить аккаунт", () =>
                  _handleAction(context, "Добавить аккаунт")),
              _buildMenuItem(context, Icons.exit_to_app, "Выйти", () =>
                  _handleAction(context, "Выйти")),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.width * 0.05,
            color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white,),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: AppSizes.width * 0.045),),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }

  void _handleAction(BuildContext context, String action) {
    if (action == "Выйти") {
      _databaseService.signOut();
      widget.togglePage(0);
    }
  }
}
