import 'dart:io';

import 'package:Eco/appSizes.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddSponsorPage extends StatefulWidget {
  final Function(int) togglePage;

  AddSponsorPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _AddSponsorPageState();
  }
}

class _AddSponsorPageState extends State<AddSponsorPage> {
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
                      onTap: () {
                        widget.togglePage(0);
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
                      onTap: () {},
                      child: Container(
                        height: AppSizes.height * 0.1,
                        width: AppSizes.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xFF393535),
                          border: Border.all(
                            color: Color(0xFFDCE06B), // Цвет границы
                            width: 2, // Толщина границы
                          ),
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
                                            AssetImage('assets/icons/ads.png'),
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
                                            AssetImage('assets/icons/ads.png'),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: AppSizes.width * 0.09,
                      height: AppSizes.width * 0.09,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/ads.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Добавляем небольшой отступ
                    Text(
                      'SPONSOR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppSizes.width * 0.05,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height * 0.01),
                Container(
                  width: AppSizes.width, // Ширина контейнера
                  padding: EdgeInsets.all(AppSizes.width * 0.04),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      width: 2,
                      color: Color(0xFF393535),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Заголовок",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.height * 0.01),
                      // Поле ввода заголовка
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Ввести заголовок задания...",
                          hintStyle: TextStyle(color: Color(0xFF909090)),
                          filled: true,
                          fillColor: Color(0xFF1E1E1E),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF565656)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF565656)),
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
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: AppSizes.height * 0.02),
                      Center(
                        child: Text(
                          "Краткое описание и награда",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.height * 0.01),
                      // Поле ввода описания
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Введите краткое описание...",
                          hintStyle: TextStyle(color: Color(0xFF909090)),
                          filled: true,
                          fillColor: Color(0xFF1E1E1E),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF565656)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF565656)),
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
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: AppSizes.height * 0.02),
                      Row(
                        children: [
                          // Метка "Спонсор:"
                          Text(
                            "Спонсор:",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSizes.width * 0.04),
                          ),
                          SizedBox(width: AppSizes.width * 0.01),

                          // Поле ввода для спонсора
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
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
                            ),
                          ),
                          SizedBox(width: AppSizes.width * 0.01),

                          // Метка "Награда:"
                          Text(
                            "Награда:",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSizes.width * 0.04),
                          ),
                          SizedBox(width: AppSizes.width * 0.01),
                          // Поле награды (неизменяемый контейнер)
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "ecocoin...",
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
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.height * 0.015),
                      // Кнопка "Сохранить"
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: AppSizes.height * 0.06,
                          width: AppSizes.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Color(0xFF292626),
                          ),
                          child: TextButton(
                            onPressed: () async {},
                            child: Center(
                              child: Text(
                                'Сохранить',
                                style: TextStyle(
                                  color: Color(0xFFA3E567),
                                  fontSize: AppSizes.width * 0.033,
                                ),
                              ),
                            ),
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
