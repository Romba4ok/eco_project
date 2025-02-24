import 'package:Eco/appSizes.dart';
import 'package:Eco/examples.dart';
import 'package:flutter/material.dart';

class TrainingExamples2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrainingExamples2State();
  }
}

class _TrainingExamples2State extends State<TrainingExamples2> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: AppSizes.width,
          height: AppSizes.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
              AssetImage('assets/images/background_training_examples2.png'),
              // Путь к изображению
              fit: BoxFit.cover, // Растянуть изображение на весь контейнер
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSizes.height * 0.7,
                ),
                Text(
                  'Начало нового',
                  style: TextStyle(
                    color: Color(0xFF79FF00),
                    fontSize: AppSizes.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Предлагаем присоединиться к инициативе по уборке мусора в игровой форме, чтобы сделать этот процесс увлекательным и эффективным.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: AppSizes.width * 0.1,
                          height: AppSizes.height * 0.045,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage('assets/images/container_training_examples1.png'),
                              // Путь к изображению
                              fit: BoxFit.cover, // Растянуть изображение на весь контейнер
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.width * 0.05,),
                        Container(
                          width: AppSizes.width * 0.1,
                          height: AppSizes.height * 0.045,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage('assets/images/container_training_examples2.png'),
                              // Путь к изображению
                              fit: BoxFit.cover, // Растянуть изображение на весь контейнер
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.width * 0.05,),
                        Container(
                          width: AppSizes.width * 0.1,
                          height: AppSizes.height * 0.045,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage('assets/images/container_training_examples3.png'),
                              // Путь к изображению
                              fit: BoxFit.cover, // Растянуть изображение на весь контейнер
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: AppSizes.width * 0.15,
                      height: AppSizes.width * 0.15,
                      decoration: BoxDecoration(
                        color: Color(0xFF2E2E2E), // Тёмно-серый фон контейнера
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(builder: (context) => ExamplesPage());
                          Navigator.pushReplacement(context, route);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.green, // Зелёная стрелка
                          size: AppSizes.width * 0.08,
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
    );
  }
}
