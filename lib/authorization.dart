import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/pageSelectionAdmin.dart';
import 'package:ecoalmaty/profile.dart';
import 'package:ecoalmaty/registration.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authorization extends StatefulWidget {
  final Function(int) togglePage;

  Authorization({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _AuthorizationState();
  }
}

class _AuthorizationState extends State<Authorization> {
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _reg() {
    widget.togglePage(1);
  }

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _log() async {
    try {
      final email = emailController.text;
      final password = passwordController.text;

      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('log');

      User? user = res.user;

      if (user != null) {
        String id = user.id;
        print(id);
        final response = await supabase
            .from('users')
            .select('user')
            .eq('id', user.id)
            .single();
        if (response != null && response['user'] != null) {
          final String userCheck = response['user'];
          print('user');

          // Проверяем роль пользователя
          if (userCheck == 'user') {
            widget.togglePage(2); // Переход для обычного пользователя
          } else if (userCheck == 'admin') {
            Route route =
                MaterialPageRoute(builder: (context) => PageSelectionAdmin());
            Navigator.pushReplacement(
                context, route); // Переход для администратора
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: Роль пользователя не найдена.')),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${error.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  bool _value = false;

  void _updateChechBox(bool? _newValue) {
    setState(() {
      _value = _newValue!;
    });
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: AppSizes.height * 0.15,
                ),
                Text(
                  "Привет, с возвращением 👋",
                  style: TextStyle(
                      fontSize: AppSizes.width * 0.07, color: Colors.white),
                ),
                SizedBox(
                  height: AppSizes.height * 0.1,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF262323),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                    hintStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                    hintText: "example@gmail.com",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
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
                  height: AppSizes.height * 0.03,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF262323),
                    labelText: "Пароль",
                    labelStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                    hintStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                    hintText: "Введите пароль",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
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
                  height: AppSizes.height * 0.015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _value, // Замените null на false или true
                          onChanged: _updateChechBox,
                        ),
                        Text(
                          "Запомнить меня",
                          style: TextStyle(
                              fontSize: AppSizes.width * 0.045,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Забыли пароль?",
                        style: TextStyle(
                          fontSize: AppSizes.width * 0.045,
                          color: Color(0xFF57B113),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.height * 0.02,
                ),
                Container(
                  width: double.infinity,
                  height: AppSizes.height * 0.06, // Растянуть на всю ширину
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _log();
                      }
                    },
                    child: Text(
                      "Войти",
                      style: TextStyle(
                          color: Colors.white, fontSize: AppSizes.width * 0.05),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF57B113),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Закругление углов
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.12,
                ),
                Row(
                  children: [
                    Expanded(child: Divider()), // Левый разделитель
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.width * 0.06),
                      // Отступы вокруг текста
                      child: Text(
                        "Войти с помощью",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.04),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(
                  height: AppSizes.height * 0.04,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Задаём цвет фона
                    borderRadius:
                        BorderRadius.circular(12.0), // Закруглённые углы
                  ),
                  width: double.infinity,
                  height: AppSizes.width * 0.15, // Высота кнопки
                  child: TextButton(
                    onPressed: () {
                      // Обработчик нажатия кнопки
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Центрирование содержимого по горизонтали
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Центрирование по вертикали
                      children: [
                        Image.asset(
                          'assets/images/google_logo.png',
                        ),
                        SizedBox(
                          width: AppSizes.width * 0.04,
                        ),
                        // Отступ между иконкой и текстом
                        Text(
                          "Войти с помощью Google",
                          style: TextStyle(
                            color: Colors.grey, // Цвет текста
                            fontSize: AppSizes.width * 0.05, // Размер шрифта
                            fontWeight: FontWeight.w500, // Полужирный текст
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "У вас уже есть аккаунт?",
                      style: TextStyle(
                        fontSize: AppSizes.width * 0.05,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0,
                        decorationColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.width * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        _reg();
                      },
                      child: Text(
                        "Регистрация",
                        style: TextStyle(
                          fontSize: AppSizes.width * 0.055,
                          color: Color(0xFFA6FF63),
                          decoration: TextDecoration.underline,
                          decorationThickness: 2.0,
                          decorationColor: Color(0xFFA6FF63),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.height * 0.2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
