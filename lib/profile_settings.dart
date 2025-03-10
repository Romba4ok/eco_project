import 'package:Eco/appSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileSettings {
  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFF68E30B), size: AppSizes.width * 0.5), // ✅ Иконка успеха
                SizedBox(height: AppSizes.height * 0.02),
                Text(
                  "Жалоба успешно отправлена!",
                  style: TextStyle(color: Colors.white, fontSize: AppSizes.width * 0.04, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.height * 0.05),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF414141), // Серый цвет кнопки
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Закрываем диалог
                  },
                  child: Text("Назад", style: TextStyle(color: Colors.white, fontSize: AppSizes.width * 0.05)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка Назад + Заголовок
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: AppSizes.width * 0.08),
                    Text(
                      "Помощь и поддержка",
                      style: TextStyle(color: Colors.white, fontSize: AppSizes.width * 0.05, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height * 0.03),

                // Описание
                Text(
                  "Наши контакты для вопросов и сотрудничества, просим писать корректно (вежливо, уместно) :)",
                  style: TextStyle(color: Colors.grey, fontSize: AppSizes.width * 0.04),
                ),
                SizedBox(height: AppSizes.height * 0.04),

                // Список контактов
                _buildContactItem(context, "site: ecoalmaty"),
                _buildContactItem(context, "inst: Hellstreakss"),
                _buildContactItem(context, "тел: 8 707 343 5897"),
                _buildContactItem(context, "2 тел: 8 700 400 5144"),
              ],
            ),
          ),
        );
      },
    );
  }

// 🔹 Виджет для строки с контактами и иконкой копирования
  Widget _buildContactItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF323232),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(text, style: TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: Icon(Icons.copy, color: Colors.grey),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text.split(": ").last));

              // Используем ScaffoldMessenger для показа Snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Скопировано: ${text.split(": ").last}"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.grey[800],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showNetworkCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Использование сети и кэша",
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300, // Ограничиваем ширину
              child: Column(
                mainAxisSize: MainAxisSize.min, // Запрещаем Column занимать всю высоту
                children: [
                  Text(
                    "Ecoalmaty занимает 2% места на вашем устройстве.",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200, // Явно задаем ширину прогресс-бара
                    child: ProgressBar(progress: 0.02),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.refresh, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Использование памяти (кэш)",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text("2,7 GB", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Использование трафика за мес.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text("112,4 GB", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Очистить кэш", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

}

class ProgressBar extends StatelessWidget {
  final double progress; // Значение от 0.0 до 1.0

  const ProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double barWidth = maxWidth * progress;

        return Stack(
          children: [
            Container(
              height: 10,
              width: maxWidth,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Container(
              height: 10,
              width: barWidth,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        );
      },
    );
  }
}