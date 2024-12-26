import 'package:ecoalmaty/AppSizes.dart';
import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  final VoidCallback togglePage;

  AddPostPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _AddPostPageState();
  }
}

class _AddPostPageState extends State<AddPostPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        height: AppSizes.height * 0.13,
                        width: AppSizes.width * 0.28,
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
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.togglePage();
                        });
                      },
                      child: Container(
                        height: AppSizes.height * 0.13,
                        width: AppSizes.width * 0.28,
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
                          fontSize: AppSizes.width * 0.05,
                        ),
                        softWrap: true, // Включаем softWrap для переноса текста
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
