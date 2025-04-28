import 'dart:io';

import 'package:Eco/appSizes.dart';
import 'package:Eco/camera.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExamplesSpecialPage extends StatefulWidget {
  final Function(int) togglePage;

  ExamplesSpecialPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _ExamplesSpecialPageState();
  }
}

class _ExamplesSpecialPageState extends State<ExamplesSpecialPage> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, String>> examples = [];
  bool isLoading = true;

  Future<void> loadPosts() async {
    List<Map<String, String>> fetchExamples =
        await _databaseService.fetchExamplesUsersSpecial();
    if (mounted) {
      setState(() {
        examples = fetchExamples;
        print(examples);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.05),
          child: SizedBox(
            height: AppSizes.height * 0.7, // ограничение по высоте
            child: ListView.builder(
              itemCount: examples.length,
              itemBuilder: (context, index) {
                final example = examples[index];
                return example['sponsor'] == null ||
                        example['sponsor'].toString().trim().isEmpty
                    ? Column(
                        children: [
                          Container(
                            width: AppSizes.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.width * 0.03,
                                vertical: AppSizes.height * 0.01),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/background_container_examples.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${example['title']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.065,
                                  ),
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.005,
                                ),
                                Text(
                                  '${example['description']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.04,
                                  ),
                                  softWrap: true,
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Color(0xFFA3E567),
                                      size: AppSizes.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: AppSizes.width * 0.01,
                                    ),
                                    Text(
                                      '${example['date_added']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(
                                      width: AppSizes.width * 0.01,
                                    ),
                                    Icon(
                                      Icons.av_timer_rounded,
                                      color: Color(0xFFA3E567),
                                      size: AppSizes.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: AppSizes.width * 0.01,
                                    ),
                                    Text(
                                      '${_databaseService.getTimeLeft(example['time']!)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Прогресс',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      '${example['coins']} coins',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      '${example['experience']} exp',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.01,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: 0,
                                    minHeight: 16,
                                    backgroundColor: Colors.grey[400],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.01,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  // Центрирование только этой кнопки
                                  child: GestureDetector(
                                    onTap: () {
                                      show_dialog(example);
                                    },
                                    child: Container(
                                      width: AppSizes.width * 0.6,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppSizes.height * 0.015),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Принять вызов',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppSizes.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: AppSizes.height * 0.03,
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            width: AppSizes.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.width * 0.03,
                                vertical: AppSizes.height * 0.01),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/background_container_examples_sponsor.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${example['sponsor']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.05,
                                      ),
                                    ),
                                    Container(
                                      width: AppSizes.width * 0.06,
                                      height: AppSizes.width * 0.06,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/sponsor_check_examples.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${example['title']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.065,
                                  ),
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.005,
                                ),
                                Text(
                                  '${example['description']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.width * 0.04,
                                  ),
                                  softWrap: true,
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Color(0xFFA3E567),
                                      size: AppSizes.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: AppSizes.width * 0.01,
                                    ),
                                    Text(
                                      '${example['date_added']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(
                                      width: AppSizes.width * 0.01,
                                    ),
                                    Icon(
                                      Icons.av_timer_rounded,
                                      color: Color(0xFFA3E567),
                                      size: AppSizes.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: AppSizes.width * 0.01,
                                    ),
                                    Text(
                                      '${_databaseService.getTimeLeft(example['time']!)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Прогресс',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      '${example['coins']} coins',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      '${example['experience']} exp',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.04,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.01,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: 0,
                                    minHeight: 16,
                                    backgroundColor: Colors.grey[400],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: AppSizes.height * 0.01,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  // Центрирование только этой кнопки
                                  child: GestureDetector(
                                    onTap: () {
                                      show_dialog(example);
                                    },
                                    child: Container(
                                      width: AppSizes.width * 0.6,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppSizes.height * 0.015),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Принять вызов',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppSizes.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: AppSizes.height * 0.03,
                          )
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  void show_dialog(Map<String, String> example) {
    String? _photoPath;
    double valueProgressBar = 0.0;
    File? image;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF252222),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: const BorderSide(
                  color: Color(0xFF57B113),
                  width: 2.0,
                ),
              ),
              content: SizedBox(
                width: AppSizes.width,
                height: AppSizes.height * 0.32,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Иконка
                      Container(
                        width: AppSizes.width * 0.06,
                        height: AppSizes.width * 0.06,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/sponsor_check_examples.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Заголовок
                      Text(
                        '${example['title']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.width * 0.055,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${example['description']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.width * 0.035,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSizes.height * 0.015),
                      // Прогресс и монеты
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${example['coins']} coins',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.04,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            '${example['experience']} exp',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.04,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: valueProgressBar,
                          minHeight: 16,
                          backgroundColor: const Color(0xFFD9D9D9),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF57B113)),
                        ),
                      ),
                      SizedBox(height: AppSizes.height * 0.02),
                      // Инструкция
                      Text(
                        'Загрузите фото процесса сортировки отходов, чтобы завершить задание:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.width * 0.035,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSizes.height * 0.015),

                      // Зона фото / кнопка
                      _photoPath == null
                          ? GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CameraPage()),
                          );
                          if (result != null && result is String) {
                            setDialogState(() {
                              _photoPath = result;
                              valueProgressBar = 1.0;
                              image = File(_photoPath!);
                            });
                          }
                        },
                        child: Container(
                          width: AppSizes.width * 0.55,
                          padding: EdgeInsets.symmetric(vertical: AppSizes.height * 0.01),
                          decoration: BoxDecoration(
                            color: const Color(0xFF736F6E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.download, color: Colors.white, size: AppSizes.width * 0.06),
                              SizedBox(width: AppSizes.width * 0.01),
                              Text(
                                'Загрузить фото',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.01, vertical: AppSizes.height * 0.01),
                        margin: EdgeInsets.only(bottom: AppSizes.height * 0.01),
                        width: AppSizes.width * 0.7,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A3939),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFF57B113), width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _photoPath!.split('/').last,
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  _photoPath = null;
                                  valueProgressBar = 0.0;
                                });
                              },
                              child: const Icon(Icons.close, color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSizes.height * 0.02),

                      // Подтвердить
                      GestureDetector(
                        onTap: () {
                          if (_photoPath != null) {
                            _databaseService.sendExample(image!, DatabaseService.userIdi ?? '', example['id'] ?? '0', "being checked");
                            Navigator.pop(context); // Закрываем диалог
                            // Тут можешь вызвать API или передать путь куда нужно
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Пожалуйста, загрузите фото')),
                            );
                          }
                        },
                        child: Container(
                          width: AppSizes.width * 0.4,
                          padding: EdgeInsets.symmetric(vertical: AppSizes.height * 0.01),
                          decoration: BoxDecoration(
                            color: const Color(0xFF57B113),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Подтвердить',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSizes.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) => setState(() {}));
  }

}
