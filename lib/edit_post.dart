import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/add_post.dart';
import 'package:flutter/material.dart';

class EditPostPage extends StatefulWidget {
  final VoidCallback togglePage;

  EditPostPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _EditPostPageState();
  }
}

class _EditPostPageState extends State<EditPostPage> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
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
                            widget.togglePage();
                          });
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.topLeft, // Поднимаем содержимое вверх и влево
                          padding: EdgeInsets.zero,    // Убираем внутренние отступы, если нужно
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
                        onPressed: () {
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.topLeft, // Поднимаем содержимое вверх и влево
                          padding: EdgeInsets.zero,    // Убираем внутренние отступы, если нужно
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
                  height: _isExpanded ? AppSizes.height : 0,
                  curve: Curves.easeInOut,
                  child: _isExpanded
                      ? SizedBox(
                    height: 200,
                    child: ListView(
                      children: [
                        _buildListItem("Пункт 1"),
                        _buildListItem("Пункт 2"),
                        _buildListItem("Пункт 3"),
                        _buildListItem("Пункт 4"),
                      ],
                    ),
                  )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildListItem(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF393535),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
