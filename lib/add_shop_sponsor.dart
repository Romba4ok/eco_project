import 'dart:io';

import 'package:Eco/appSizes.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddShopSponsorPage extends StatefulWidget {
  final Function(int) togglePage;

  AddShopSponsorPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _AddShopSponsorPageState();
  }
}

class _AddShopSponsorPageState extends State<AddShopSponsorPage> {
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
                  'Магазин',
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
                                  'Добавить мерч',
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
                                  'Редактировать мерч',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
