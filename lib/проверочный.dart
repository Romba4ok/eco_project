import 'package:flutter/material.dart';



class ExamplesPage extends StatefulWidget {
  const ExamplesPage({super.key});

  @override
  _ExamplesPageState createState() => _ExamplesPageState();
}

class _ExamplesPageState extends State<ExamplesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<Task> tasks = [
    Task(
        title: "День без машины",
        description: "Не пользуйтесь машиной в течение дня",
        date: "25.02.2025",
        progress: 0.7),
    Task(
        title: "Сортировка мусора",
        description: "Разделите мусор и сдайте перерабатываемое",
        date: "26.02.2025",
        progress: 0.4),
    Task(
        title: "Эко-поход",
        description: "Посетите парк и соберите мусор",
        date: "27.02.2025",
        progress: 0.8),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 📌 Шапка
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Назад
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 24),
                  onPressed: () {},
                ),
                // Заголовок
                const Expanded(
                  child: Center(
                    child: Text(
                      "Ежедневные задания",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Баланс + Аватар
                Row(
                  children: [
                    const Icon(Icons.monetization_on,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 5),
                    const Text(
                      "100000",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      backgroundImage: AssetImage("assets/avatar.jpg"),
                      radius: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 🔹 Фильтры
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                FilterButton(title: "Популярное", isSelected: true),
                FilterButton(title: "Особое"),
                FilterButton(title: "Выполнено"),
              ],
            ),
          ),
          // 📝 Список заданий
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(task: tasks[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🎯 Класс модели задания
class Task {
  final String title;
  final String description;
  final String date;
  final double progress;

  Task(
      {required this.title,
        required this.description,
        required this.date,
        required this.progress});
}

// 🎯 Виджет кнопки фильтра
class FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;

  const FilterButton({super.key, required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green),
      ),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}

// 🎯 Виджет карточки задания
class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: widget.task.progress).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.task.title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 5),
          Text(widget.task.description,
              style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.green, size: 16),
              const SizedBox(width: 5),
              Text(widget.task.date,
                  style: const TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.white10,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 5),
                  Text("${(_progressAnimation.value * 100).toInt()}% выполнено",
                      style:
                      const TextStyle(fontSize: 14, color: Colors.white)),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Принять вызов",
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}