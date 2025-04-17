import 'dart:io';
import 'package:Eco/appSizes.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditSponsorPage extends StatefulWidget {
  final Function(int) togglePage;

  EditSponsorPage({required this.togglePage});

  @override
  State<StatefulWidget> createState() {
    return _EditSponsorPageState();
  }
}

class _EditSponsorPageState extends State<EditSponsorPage> {
  bool _isExpanded = true;
  bool isLoading = true;

  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, String>> examples = [];

  Future<void> loadPosts() async {
    List<Map<String, String>> fetchExamples =
    await _databaseService.fetchExamplesSponsors();
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

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Duration? taskDuration;
  TextEditingController coinsController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController sponsorController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  /// Виджет выбора времени
  Widget _buildTimePicker(
      Function(int, int, int) onChanged,
      int days,
      int hours,
      int minutes,
      ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberPicker(
              label: "Д",
              max: 31,
              value: days,
              onChanged: (val) => onChanged(val, hours, minutes),
            ),
            SizedBox(width: 16),
            _buildNumberPicker(
              label: "Ч",
              max: 23,
              value: hours,
              onChanged: (val) => onChanged(days, val, minutes),
            ),
            SizedBox(width: 16),
            _buildNumberPicker(
              label: "М",
              max: 59,
              value: minutes,
              onChanged: (val) => onChanged(days, hours, val),
            ),
          ],
        ),
      ],
    );
  }

  /// Виджет колеса выбора числа
  Widget _buildNumberPicker({
    required String label,
    required int max,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white54)),
        SizedBox(height: 4),
        Container(
          height: 120,
          width: 64,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListWheelScrollView.useDelegate(
            itemExtent: 36,
            diameterRatio: 1.2,
            physics: FixedExtentScrollPhysics(),
            squeeze: 0.8,
            onSelectedItemChanged: onChanged,
            controller: FixedExtentScrollController(initialItem: value),
            // Устанавливаем сохраненное значение
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontSize: 22,
                      color: index == value ? Colors.white : Colors.white54,
                    ),
                  ),
                );
              },
              childCount: max + 1,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    List<String> parts = [];
    if (days > 0 && days < 10)
      parts.add("0$days:");
    else if (days > 9)
      parts.add("$days:");
    else
      parts.add('00:');
    if (hours > 0 && hours < 10)
      parts.add("0$hours:");
    else if (hours > 9)
      parts.add("$hours:");
    else
      parts.add('00:');
    if (minutes > 0 && minutes < 10)
      parts.add("0$minutes");
    else if (minutes > 9)
      parts.add("$minutes");
    else
      parts.add('00');

    return parts.isNotEmpty ? parts.join("") : "Не выбрано";
  }

  String? titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите заголовок';
    }
    return null;
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите источник';
    }
    return null;
  }

  String? coinsValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите источник';
    }
    return null;
  }

  String? experienceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите источник';
    }
    return null;
  }

  String? sponsorValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите источник';
    }
    return null;
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
                      onTap: () {
                        widget.togglePage(2);
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
                SizedBox(height: AppSizes.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  height: _isExpanded ? AppSizes.height * 0.6 : 0,
                  curve: Curves.easeInOut,
                  child: isLoading
                      ? SizedBox(
                    height: AppSizes.height * 0.8,
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : Container(
                    height: AppSizes.height * 0.4,
                    // Повыше для горизонтальных карточек
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.width * 0.02),
                      itemCount: examples.length,
                      itemBuilder: (context, index) {
                        final example = examples[index];
                        return GestureDetector(
                          onTap: () {
                            titleController.text = example['title']!;
                            sponsorController.text = example['sponsor']!;
                            descriptionController.text =
                            example['description']!;
                            coinsController.text = example['coins']!;
                            experienceController.text =
                            example['experience']!;
                            if (example['time'] != null && example['time']!.trim().isNotEmpty) {
                              String dateStr = example['time']!;
                              DateTime targetDate = DateTime.parse(dateStr);
                              DateTime now = DateTime.now();

                              // Вычисляем разницу
                              Duration difference = targetDate.difference(now);

                              // Если дата в будущем - сохраняем разницу, иначе устанавливаем 0
                              taskDuration = difference.isNegative ? null : difference;
                            } else {
                              taskDuration = null;
                            }
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    // <-- Ключевое изменение
                                      builder: (context, setDialogState) {
                                        return AlertDialog(
                                          backgroundColor: Color(0xFF131010),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                            side: BorderSide(
                                              // Граница
                                              color: Color(0xFF333333),
                                              // Цвет границы
                                              width: 2.0, // Толщина границы
                                            ),
                                          ),
                                          content: SizedBox(
                                            width: AppSizes.width * 0.75,
                                            height: AppSizes.height * 0.49,
                                            // 60% от высоты экрана
                                            child: SingleChildScrollView(
                                              // Прокрутка, если контент выходит за границы
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                      AppSizes.height *
                                                          0.02,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        "Заголовок",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                          AppSizes.width *
                                                              0.04,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                        AppSizes.height *
                                                            0.01),
                                                    TextFormField(
                                                      controller:
                                                      titleController,
                                                      decoration:
                                                      InputDecoration(
                                                        hintText:
                                                        "Ввести заголовок задания...",
                                                        hintStyle: TextStyle(
                                                            color: Color(
                                                                0xFF909090)),
                                                        filled: true,
                                                        fillColor:
                                                        Color(0xFF1E1E1E),
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF565656)),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0),
                                                        ),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF565656)),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0),
                                                        ),
                                                        errorBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .red),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0),
                                                        ),
                                                        focusedErrorBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .red),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0),
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white),
                                                      validator:
                                                      titleValidator,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                        AppSizes.height *
                                                            0.02),
                                                    Center(
                                                      child: Text(
                                                        "Краткое описание и награда",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                          AppSizes.width *
                                                              0.04,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                        AppSizes.height *
                                                            0.01),
                                                    TextFormField(
                                                      controller:
                                                      descriptionController,
                                                      decoration:
                                                      InputDecoration(
                                                        hintText:
                                                        "Введите краткое описание...",
                                                        hintStyle: TextStyle(
                                                            color: Color(
                                                                0xFF909090)),
                                                        filled: true,
                                                        fillColor:
                                                        Color(0xFF1E1E1E),
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF565656)),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0),
                                                        ),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF565656)),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0),
                                                        ),
                                                        errorBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .red),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0),
                                                        ),
                                                        focusedErrorBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .red),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0),
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white),
                                                      validator:
                                                      descriptionValidator,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                        AppSizes.height *
                                                            0.02),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Особое задание",
                                                                  style:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    AppSizes.width *
                                                                        0.04,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .fireFlameCurved,
                                                                  size: AppSizes
                                                                      .width *
                                                                      0.05,
                                                                  color: Color(
                                                                      0xFFFF8000),
                                                                ),
                                                              ],
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  ()  {
                                                                Widget _buildTopButton(String label, Duration? duration,
                                                                    {required bool isSelected}) {
                                                                  return Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                      child: ElevatedButton(
                                                                        onPressed: () {
                                                                          setDialogState(() {
                                                                            // <--- Добавлен setState для обновления UI
                                                                            taskDuration = duration;
                                                                          });
                                                                          Navigator.pop(context);
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: isSelected ? Colors.white24 : Colors.grey[800],
                                                                          padding: EdgeInsets.symmetric(vertical: 12),
                                                                        ),
                                                                        child: Text(label),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }

                                                                showModalBottomSheet(
                                                                  context: context,
                                                                  backgroundColor: Colors.transparent,
                                                                  builder: (BuildContext context) {
                                                                    int days = taskDuration?.inDays ?? 0;
                                                                    int hours = taskDuration != null ? (taskDuration!.inHours % 24) : 0;
                                                                    int minutes = taskDuration != null ? (taskDuration!.inMinutes % 60) : 0;

                                                                    return StatefulBuilder(
                                                                      builder: (context, setModalState) {
                                                                        return Container(
                                                                          padding: EdgeInsets.all(16),
                                                                          decoration: BoxDecoration(
                                                                            color: Color(0xFF1E1E1E),
                                                                            borderRadius: BorderRadius.circular(20),
                                                                          ),
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text("Выберите время выполнения",
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Colors.white)),
                                                                              SizedBox(height: 16),

                                                                              /// Быстрый выбор времени
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  _buildTopButton(
                                                                                    "Не особое",
                                                                                    null,
                                                                                    isSelected: taskDuration == null,
                                                                                  ),
                                                                                  _buildTopButton(
                                                                                    "1 Час",
                                                                                    Duration(hours: 1),
                                                                                    isSelected: taskDuration == Duration(hours: 1),
                                                                                  ),
                                                                                  _buildTopButton(
                                                                                    "2 Часа",
                                                                                    Duration(hours: 2),
                                                                                    isSelected: taskDuration == Duration(hours: 2),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 16),

                                                                              /// Ручной выбор времени
                                                                              _buildTimePicker(
                                                                                    (d, h, m) {
                                                                                  setModalState(() {
                                                                                    days = d;
                                                                                    hours = h;
                                                                                    minutes = m;
                                                                                  });
                                                                                },
                                                                                days,
                                                                                hours,
                                                                                minutes,
                                                                              ),

                                                                              SizedBox(height: 16),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(context),
                                                                                    child: Text("Отменить",
                                                                                        style: TextStyle(color: Colors.grey)),
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      setDialogState(() {
                                                                                        taskDuration =
                                                                                        (days > 0 || hours > 0 || minutes > 0)
                                                                                            ? Duration(
                                                                                            days: days,
                                                                                            hours: hours,
                                                                                            minutes: minutes)
                                                                                            : null;
                                                                                      });
                                                                                      print(taskDuration);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Colors.green),
                                                                                    child: Text("Подтвердить"),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                );

                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                Colors
                                                                    .grey,
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                    AppSizes.width *
                                                                        0.03,
                                                                    vertical:
                                                                    AppSizes.height *
                                                                        0.015),
                                                                shape:
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      12),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                taskDuration !=
                                                                    null
                                                                    ? "${_formatDuration(taskDuration!)}"
                                                                    :  example['special'] == 'special' ? "Продлить" : 'Нет',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    AppSizes.width *
                                                                        0.04),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              "Награда:",
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                AppSizes.width *
                                                                    0.04,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: AppSizes
                                                                      .width *
                                                                      0.15,
                                                                  child:
                                                                  TextFormField(
                                                                    controller:
                                                                    coinsController,
                                                                    keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                    decoration:
                                                                    InputDecoration(
                                                                      hintText:
                                                                      "ecocoin",
                                                                      hintStyle:
                                                                      TextStyle(color: Color(0xFF909090)),
                                                                      filled:
                                                                      true,
                                                                      fillColor:
                                                                      Color(0xFF1E1E1E),
                                                                      enabledBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(color: Color(0xFF565656)),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12.0),
                                                                      ),
                                                                      focusedBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(color: Color(0xFF565656)),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12.0),
                                                                      ),
                                                                      errorBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(color: Colors.red),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12.0),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(color: Colors.red),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12.0),
                                                                      ),
                                                                    ),
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.white),
                                                                    validator:
                                                                    coinsValidator,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: AppSizes
                                                                        .width *
                                                                        0.01),
                                                                Container(
                                                                  width: AppSizes
                                                                      .width *
                                                                      0.15,
                                                                  child:
                                                                  TextFormField(
                                                                    controller:
                                                                    experienceController,
                                                                    keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                    decoration:
                                                                    InputDecoration(
                                                                      hintText:
                                                                      "experience",
                                                                      hintStyle:
                                                                      TextStyle(color: Color(0xFF909090)),
                                                                      filled:
                                                                      true,
                                                                      fillColor:
                                                                      Color(0xFF1E1E1E),
                                                                      enabledBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(color: Color(0xFF565656)),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12.0),
                                                                      ),
                                                                      focusedBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(color: Color(0xFF565656)),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12.0),
                                                                      ),
                                                                      errorBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(color: Colors.red),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12.0),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(color: Colors.red),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12.0),
                                                                      ),
                                                                    ),
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.white),
                                                                    validator:
                                                                    experienceValidator,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: AppSizes.height * 0.02),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Спонсор: ",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: AppSizes.width * 0.04,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: AppSizes.width * 0.3,
                                                          child: TextFormField(
                                                            controller: sponsorController,
                                                            decoration: InputDecoration(
                                                              hintText: "Наименование",
                                                              hintStyle: TextStyle(
                                                                  color: Color(0xFF909090)),
                                                              filled: true,
                                                              fillColor: Color(0xFF1E1E1E),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF565656)),
                                                                borderRadius:
                                                                BorderRadius.circular(12.0),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF565656)),
                                                                borderRadius:
                                                                BorderRadius.circular(12.0),
                                                              ),
                                                              errorBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: Colors.red),
                                                                borderRadius:
                                                                BorderRadius.circular(12.0),
                                                              ),
                                                              focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: Colors.red),
                                                                borderRadius:
                                                                BorderRadius.circular(12.0),
                                                              ),
                                                            ),
                                                            style: TextStyle(color: Colors.white),
                                                            validator: sponsorValidator,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: AppSizes.height * 0.02),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        TextButton(
                                                          onPressed:
                                                              () async {
                                                            print(example['id']);
                                                            try {
                                                              await DatabaseService().deleteExample(int.parse(example['id'].toString()));
                                                              Navigator.of(context).pop();
                                                              setState(
                                                                      () {
                                                                    loadPosts();
                                                                  });
                                                            } catch (e) {
                                                              print(
                                                                  "Ошибка удаления поста: $e");
                                                            }
                                                          },
                                                          child: Text(
                                                              "Удалить",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed:
                                                              () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              try {
                                                                final now = DateTime.now();
                                                                final expiresAt = taskDuration != null
                                                                    ? now.add(taskDuration!)
                                                                    : null;
                                                                await DatabaseService()
                                                                    .updateExample(
                                                                  postId: int.parse(example['id'].toString()),
                                                                  newCoins: int.parse(coinsController.text),
                                                                  newDescription: descriptionController.text,
                                                                  newExperience: int.parse(experienceController.text),
                                                                  newTitle: titleController.text,
                                                                  newTime: expiresAt,
                                                                  newSpecial: taskDuration != null ? 'special' : '',
                                                                  newSponsor: sponsorController.text,
                                                                );
                                                                setState(
                                                                        () {
                                                                      loadPosts();
                                                                    });

                                                                // Закрываем диалог
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();

                                                              } catch (e) {
                                                                print(
                                                                    "Ошибка при обновлении поста: $e");
                                                              }
                                                            }
                                                          },
                                                          style:
                                                          ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                            Color(
                                                                0xFF68E30B),
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                          child: Text(
                                                              "Сохранить",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }).then((_) {
                              setState(() {
                                taskDuration = null;
                              });
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                width: AppSizes.width,
                                padding:
                                EdgeInsets.all(AppSizes.width * 0.02),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/background_editExample.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${example['title']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.07,
                                      ),
                                    ),
                                    Text(
                                      '${example['description']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.035,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSizes.height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              example['special'] == 'special' ?
                                              '${_databaseService.getTimeLeft(example['time']!)}'
                                                  : '',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: AppSizes.width *
                                                    0.035,
                                              ),
                                            ),
                                            Text(
                                              'Нажмите для редактирования',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: AppSizes.width *
                                                    0.035,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: AppSizes.width *
                                                      0.04,
                                                  height:
                                                  AppSizes.height *
                                                      0.028,
                                                  decoration:
                                                  BoxDecoration(
                                                    image:
                                                    DecorationImage(
                                                      image: AssetImage(
                                                          'assets/icons/union.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: AppSizes.width *
                                                      0.01,
                                                ),
                                                Text(
                                                  '${example['coins']} coins',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                    AppSizes.width *
                                                        0.035,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${example['experience']} exp',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: AppSizes.width *
                                                    0.035,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.height * 0.01,
                              )
                            ],
                          ),
                        );
                      },
                    ),
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
