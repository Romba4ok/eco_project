import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/authorization.dart';
import 'package:ecoalmaty/profile.dart';
import 'package:ecoalmaty/request.dart';
import 'package:ecoalmaty/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Registration extends StatefulWidget {
  final Function(int) togglePage;
  Registration({required this.togglePage});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegistrationState();
  }
}

class RegistrationState extends State<Registration> {
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

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController submitPasswordController =
      TextEditingController();
  late final ProfilePage profilePage;

  void _log() {
    widget.togglePage(0);
  }

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscure2 = true;

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _reg() async {
    try {
      final res = await supabase.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      );
      if (res.user != null) {
        print(res.user!.id);
        await Supabase.instance.client.from('users').insert({
          'uuid': res.user!.id, // UUID пользователя из auth
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'state': RequestCheck.state,
          'city': RequestCheck.city,
          'avatar': '',
          'user': 'user',
        });
        widget.togglePage(2);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(
              left: AppSizes.width * 0.05, right: AppSizes.width * 0.05),
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Text(
                  "Создайте аккаунт",
                  style: TextStyle(
                    fontSize: AppSizes.width * 0.08,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.01,
                ),
                Text(
                  "Не забудьте свои данные !",
                  style: TextStyle(
                    fontSize: AppSizes.width * 0.045,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.05,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF262323),
                    labelText: "Имя",
                    labelStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                    hintStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                    hintText: "Как вас зовут?",
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
                  validator: nameValidator,
                ),
                SizedBox(
                  height: AppSizes.height * 0.02,
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
                  height: AppSizes.height * 0.02,
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
                  height: AppSizes.height * 0.02,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: submitPasswordController,
                  obscureText: _isObscure2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF262323),
                    labelText: "Подтвердите пароль",
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
                        _isObscure2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure2 = !_isObscure2; // Переключение состояния
                        });
                      },
                    ),
                  ),
                  validator: confirmPasswordValidator,
                ),
                SizedBox(
                  height: AppSizes.height * 0.03,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF57B113), // Задаём цвет фона
                    borderRadius:
                        BorderRadius.circular(12.0), // Закруглённые углы
                  ),
                  width: double.infinity,
                  height: AppSizes.height * 0.06,
                  // Растянуть на всю ширину
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _reg();
                      }
                    },
                    child: Text(
                      "Зарегестрироваться",
                      style: TextStyle(
                          color: Colors.white, fontSize: AppSizes.width * 0.06),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.07,
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
                        _log();
                      },
                      child: Text(
                        "Войти",
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
