
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(const PokryshkinApp());

const blue = Color(0xFF2675FF);
const bg = Color(0xFFF1F1F1);
const ink = Color(0xFF232428);
const grey = Color(0xFF666666);
const lightBlueBorder = Color(0xFFBBD5FF);

class PokryshkinApp extends StatelessWidget {
  const PokryshkinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Покрышкинъ',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        fontFamily: 'Inter',
      ),
      scrollBehavior: const AppScrollBehavior(),
      home: const ReceiptScreen(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}

class Service {
  Service({
    required this.name,
    required this.category,
    this.fixedPrice,
    this.prices,
    this.quickSet = false,
  });

  final String name;
  final String category;
  final double? fixedPrice;
  final Map<int, double>? prices;
  final bool quickSet;

  int count = 0;
  double? customPrice;

  double price(int radius) {
    if (customPrice != null) return customPrice!;
    if (fixedPrice != null) return fixedPrice!;
    return prices?[radius <= 15 ? 13 : radius] ?? 0;
  }
}

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  int radius = 17;
  int selectedCategory = 0;
  int selectedTab = 0;
  double discount = 0;

  final ScrollController menuController = ScrollController();

  final List<String> categories = const [
    'Быстрый набор',
    'Замена шин',
    'Замена колёс в сборе',
    'Ремонт дисков',
    'Ремонт шин',
    'Хранение колёс',
    'Сварочные работы',
    'Снятие секреток',
    'Доп. услуги',
    'Кондиционеры',
    'Обслуживание колёс и крепежа',
  ];

  static const Map<int, double> patchPrices = {
    10: 1100,
    15: 1300,
    19: 1500,
    20: 1600,
    25: 1800,
    33: 2200,
  };

  final Map<int, int> patchCounts = {
    10: 0,
    15: 0,
    19: 0,
    20: 0,
    25: 0,
    33: 0,
  };

  static const Map<int, double> tirePrices = {
    13: 964, 14: 964, 15: 964, 16: 1108, 17: 1350,
    18: 1448, 19: 1592, 20: 1832, 21: 1976,
    22: 2218, 23: 2264, 24: 2362,
  };

  static const Map<int, double> assemblyPrices = {
    13: 670, 14: 670, 15: 670, 16: 770, 17: 938,
    18: 1006, 19: 1106, 20: 1274, 21: 1374,
    22: 1542, 23: 1574, 24: 1642,
  };

  static const Map<int, double> diskPrices = {
    13: 1800, 14: 1800, 15: 1800, 16: 2000, 17: 2100,
    18: 2200, 19: 2400, 20: 2800, 21: 3000,
    22: 3400, 23: 3800, 24: 4200,
  };

  // Список услуг. Быстрый набор оставлен в исходном порядке.
  // Одни и те же услуги используются и в быстром наборе,
  // и в соответствующих категориях — счётчики общие.

  late final List<Service> services = [
    // БЫСТРЫЙ НАБОР — порядок не меняем
    Service(
      name: 'Замена шин',
      category: 'Замена шин',
      prices: tirePrices,
      quickSet: true,
    ),
    Service(
      name: 'Замена колес в сборе',
      category: 'Замена колёс в сборе',
      prices: assemblyPrices,
      quickSet: true,
    ),
    Service(
      name: 'Грибок - Г7',
      category: 'Ремонт шин',
      fixedPrice: 600,
      quickSet: true,
    ),
    Service(
      name: 'Грибок - Г9',
      category: 'Ремонт шин',
      fixedPrice: 800,
      quickSet: true,
    ),
    Service(
      name: 'Установка латки',
      category: 'Ремонт шин',
      fixedPrice: 100,
      quickSet: true,
    ),
    Service(
      name: 'Ремонт дисков',
      category: 'Ремонт дисков',
      prices: diskPrices,
      quickSet: true,
    ),
    Service(
      name: 'Ремонт штамп. дисков',
      category: 'Ремонт дисков',
      fixedPrice: 980,
      quickSet: true,
    ),
    Service(
      name: 'Мойка колес',
      category: 'Обслуживание колёс и крепежа',
      fixedPrice: 100,
      quickSet: true,
    ),
    Service(
      name: 'Замена вентеля',
      category: 'Доп. услуги',
      fixedPrice: 180,
      quickSet: true,
    ),
    Service(
      name: 'Упаковка колеса',
      category: 'Обслуживание колёс и крепежа',
      fixedPrice: 25,
      quickSet: true,
    ),
    Service(
      name: 'Медная смазка',
      category: 'Обслуживание колёс и крепежа',
      fixedPrice: 50,
      quickSet: true,
    ),
    Service(
      name: 'Хранение',
      category: 'Хранение колёс',
      fixedPrice: 3000,
      quickSet: true,
    ),
    Service(
      name: 'Утилизация',
      category: 'Доп. услуги',
      fixedPrice: 500,
      quickSet: true,
    ),

    // ДОПОЛНИТЕЛЬНЫЕ УСЛУГИ
    Service(
      name: 'Замена золотника в вентиле',
      category: 'Доп. услуги',
      fixedPrice: 100,
    ),
    Service(
      name: 'Установка вентиля под датчик давления',
      category: 'Доп. услуги',
      fixedPrice: 600,
    ),
    Service(
      name: 'Проверка и установка камеры',
      category: 'Доп. услуги',
      fixedPrice: 200,
    ),
    Service(
      name: 'Установка камеры R13, R14, R15, R16',
      category: 'Доп. услуги',
      fixedPrice: 756,
    ),
    Service(
      name: 'Установка запаски под днище автомобиля',
      category: 'Доп. услуги',
      fixedPrice: 500,
    ),
    Service(
      name: 'Установка датчика давления воздуха в шине (1 шт.)',
      category: 'Доп. услуги',
      fixedPrice: 500,
    ),
    Service(
      name: 'Подкачка колеса',
      category: 'Доп. услуги',
      fixedPrice: 50,
    ),
    Service(
      name: 'Подкачка колеса для МГТ',
      category: 'Доп. услуги',
      fixedPrice: 100,
    ),
    Service(
      name: 'Подкачка ватрушки',
      category: 'Доп. услуги',
      fixedPrice: 100,
    ),
    Service(
      name: 'Удаление старых шипов (1 шт.)',
      category: 'Доп. услуги',
      fixedPrice: 10,
    ),
    Service(
      name: 'Проверка колеса на герметичность',
      category: 'Доп. услуги',
      fixedPrice: 200,
    ),
    Service(
      name: 'Программирование / диагностика датчиков давления',
      category: 'Доп. услуги',
      fixedPrice: 500,
    ),

    // СНЯТИЕ СЕКРЕТОК
    Service(
      name: 'Снятие секреток, повреждённых гаек и болтов (1 шт.)',
      category: 'Снятие секреток',
      fixedPrice: 1500,
    ),
    Service(
      name: 'Снятие секреток с применением электросварки (1 шт.)',
      category: 'Снятие секреток',
      fixedPrice: 2000,
    ),

    // ОБСЛУЖИВАНИЕ КОЛЁС И КРЕПЕЖА
    Service(
      name: 'Установка болтов и гаек',
      category: 'Обслуживание колёс и крепежа',
      fixedPrice: 105,
    ),
    Service(
      name: 'Установка супинаторов (комплект 4 шт.)',
      category: 'Обслуживание колёс и крепежа',
      fixedPrice: 510,
    ),
    Service(
      name: 'Протяжка колёс (1 колесо)',
      category: 'Обслуживание колёс и крепежа',
      fixedPrice: 150,
    ),
    Service(
      name: 'Датчик давления TPMS',
      category: 'Обслуживание колёс и крепежа',
      fixedPrice: 3500,
    ),
    Service(
      name: 'Дополнительные работы',
      category: 'Обслуживание колёс и крепежа',
      fixedPrice: 100,
    ),

    // СВАРОЧНЫЕ РАБОТЫ
    Service(
      name: 'Сварка аргоном',
      category: 'Сварочные работы',
      fixedPrice: 1000,
    ),
    Service(
      name: 'Подготовка места повреждения для сварки',
      category: 'Сварочные работы',
      fixedPrice: 500,
    ),
    Service(
      name: 'Удаление сварного шва и обработка места сварки',
      category: 'Сварочные работы',
      fixedPrice: 500,
    ),

    // КОНДИЦИОНЕРЫ
    Service(
      name: 'Вакуумная диагностика системы кондиционирования',
      category: 'Кондиционеры',
      fixedPrice: 0,
    ),
    Service(
      name: 'Заправка автокондиционера',
      category: 'Кондиционеры',
      fixedPrice: 3950,
    ),
    Service(
      name: 'Замена золотника автокондиционера',
      category: 'Кондиционеры',
      fixedPrice: 500,
    ),
    Service(
      name: 'Замена колпачка на порт для заправки',
      category: 'Кондиционеры',
      fixedPrice: 100,
    ),
    Service(
      name: 'Сбор хладагента',
      category: 'Кондиционеры',
      fixedPrice: 1000,
    ),

    // РЕМОНТ ШИН — ДОПОЛНИТЕЛЬНЫЕ РАБОТЫ
    Service(
      name: 'Вулканизация автошины при боковом порезе',
      category: 'Ремонт шин',
      fixedPrice: 1000,
    ),
    Service(
      name: 'Установка термолатки',
      category: 'Ремонт шин',
      fixedPrice: 2300,
    ),
    Service(
      name: 'Установка камерной заплатки',
      category: 'Ремонт шин',
      fixedPrice: 600,
    ),
    Service(
      name: 'Ошиповка шин (1 шип)',
      category: 'Ремонт шин',
      fixedPrice: 18,
    ),
  ];

  Service get patchService =>
      services.firstWhere((s) => s.name == 'Установка латки');

  int get totalPatchCount =>
      patchCounts.values.fold(0, (sum, count) => sum + count);

  double get patchSubtotal => patchCounts.entries.fold(
        0.0,
        (sum, entry) =>
            sum + (patchPrices[entry.key] ?? 0) * entry.value,
      );

  List<Service> get visibleServices {
    if (selectedCategory == 0) {
      return services.where((s) => s.quickSet).toList();
    }

    return services
        .where((s) => s.category == categories[selectedCategory])
        .toList();
  }

  double get subtotal => services.fold<double>(0, (sum, service) {
        if (service.name == 'Установка латки') return sum;
        return sum + service.price(radius) * service.count;
      }) +
      patchSubtotal;

  double get total => subtotal * (1 - discount / 100);

  String money(num value) {
    final digits = value.round().toString();
    final output = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        output.write(' ');
      }
      output.write(digits[i]);
    }

    return output.toString();
  }

  void changeCount(Service service, int delta) {
    setState(() {
      service.count =
          (service.count + delta).clamp(0, 999).toInt();
    });
  }

  void changePatchCount(int size, int delta) {
    setState(() {
      patchCounts[size] =
          ((patchCounts[size] ?? 0) + delta).clamp(0, 999).toInt();
      patchService.count = totalPatchCount;
    });
  }

  void resetReceipt() {
    setState(() {
      for (final service in services) {
        service.count = 0;
        service.customPrice = null;
      }
      for (final size in patchCounts.keys.toList()) {
        patchCounts[size] = 0;
      }
      discount = 0;
    });
  }

  Future<void> editPrice(Service service) async {
    if (service.name == 'Установка латки') return;

    final controller = TextEditingController(
      text: service.price(radius).round().toString(),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          service.name,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: const InputDecoration(
            labelText: 'Цена за единицу, ₽',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(
                controller.text.replaceAll(',', '.'),
              );
              if (value != null && value >= 0) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (result != null && mounted) {
      setState(() => service.customPrice = result);
    }
  }

  Future<void> showPatchMenu() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            4,
            20,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Установка пластыря',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Для радиальной шины',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: grey,
                  ),
                ),
                const SizedBox(height: 16),
                ...patchPrices.entries.map((entry) {
                  final size = entry.key;
                  final price = entry.value;
                  final count = patchCounts[size] ?? 0;
                  final active = count > 0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFFEAF1FF)
                            : bg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: active ? blue : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '№$size',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${money(price)} ₽',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: count > 0
                                ? () {
                                    changePatchCount(size, -1);
                                    setSheetState(() {});
                                  }
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 28,
                            child: Text(
                              '$count',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: ink,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              changePatchCount(size, 1);
                              setSheetState(() {});
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Сумма за пластыри',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: grey,
                        ),
                      ),
                    ),
                    Text(
                      '${money(patchSubtotal)} ₽',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: FilledButton.styleFrom(
                      backgroundColor: blue,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Готово',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth > 500;

        return ColoredBox(
          color: desktop ? const Color(0xFFE6E7E9) : bg,
          child: Center(
            child: SizedBox(
              width: desktop ? 390 : constraints.maxWidth,
              height: desktop
                  ? constraints.maxHeight.clamp(600.0, 850.0)
                  : constraints.maxHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(desktop ? 28 : 0),
                child: Scaffold(
                  body: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        header(),
                        categoryMenu(),
                        radiusPanel(),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: Container(
                              color: bg,
                              child: visibleServices.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'В этой категории пока нет услуг',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: grey,
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: const EdgeInsets.fromLTRB(
                                        14,
                                        12,
                                        14,
                                        12,
                                      ),
                                      itemCount: visibleServices.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 8),
                                      itemBuilder: (_, index) =>
                                          serviceTile(
                                        visibleServices[index],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        actionButtons(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  bottomNavigationBar: bottomBar(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget header() {
    return Container(
      height: 46,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(
            Icons.account_circle_outlined,
            size: 24,
            color: grey,
          ),
          const SizedBox(width: 8),
          const Text(
            'Павел',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              color: grey,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: grey, size: 20),
          const Spacer(),
          IconButton(
            tooltip: 'Уведомления',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Уведомлений пока нет'),
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 36,
              height: 36,
            ),
            icon: const Icon(
              Icons.notifications_none,
              size: 25,
              color: grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryMenu() {
    return Container(
      height: 53,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: ScrollConfiguration(
        behavior: const AppScrollBehavior(),
        child: ListView.separated(
          controller: menuController,
          scrollDirection: Axis.horizontal,
          primary: false,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 5,
          ),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final active = selectedCategory == index;

            return Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => selectedCategory = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: active
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF3F88FC),
                              Color(0xFF0060FF),
                            ],
                          )
                        : null,
                    color: active ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(38),
                  ),
                  child: Text(
                    categories[index],
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: active ? Colors.white : ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget radiusPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Row(
        children: [
          Container(
            width: 177,
            height: 81,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: radius > 13
                      ? () => setState(() => radius--)
                      : null,
                  icon: const Icon(Icons.remove, size: 20),
                ),
                Text(
                  'R$radius',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: radius < 24
                      ? () => setState(() => radius++)
                      : null,
                  icon: const Icon(Icons.add, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 81,
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    money(total),
                    maxLines: 1,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceTile(Service service) {
    final isPatch = service.name == 'Установка латки';
    final count = isPatch ? totalPatchCount : service.count;
    final active = count > 0;

    return Material(
      color: active ? ink : Colors.white,
      borderRadius: BorderRadius.circular(45),
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: isPatch ? showPatchMenu : null,
        onLongPress: isPatch ? null : () => editPrice(service),
        child: SizedBox(
          height: 53,
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 7),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: active ? Colors.white : grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isPatch) ...[
                  SizedBox(
                    width: 31,
                    child: Text(
                      '$count',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: active ? Colors.white : ink,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: active ? Colors.white : ink,
                    size: 24,
                  ),
                  const SizedBox(width: 5),
                ] else ...[
                  countButton(
                    icon: Icons.remove,
                    active: active,
                    onPressed: () => changeCount(service, -1),
                  ),
                  SizedBox(
                    width: 31,
                    child: Text(
                      '${service.count}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: active ? Colors.white : ink,
                      ),
                    ),
                  ),
                  countButton(
                    icon: Icons.add,
                    active: active,
                    onPressed: () => changeCount(service, 1),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget countButton({
    required IconData icon,
    required bool active,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: 29,
        height: 38,
      ),
      icon: Icon(
        icon,
        size: 19,
        color: active ? Colors.white : ink,
      ),
    );
  }

  Widget actionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: resetReceipt,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: blue,
              side: const BorderSide(color: lightBlueBorder),
              minimumSize: const Size(128, 52),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: const Text('Сбросить'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3F88FC),
                    Color(0xFF0060FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: FilledButton(
                onPressed: showPayment,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Оплата',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showPayment() async {
    if (subtotal == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавь услугу в чек')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            8,
            22,
            28 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Оплата чека',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              summaryRow('Сумма', '${money(subtotal)} ₽'),
              Row(
                children: [
                  const Expanded(child: Text('Скидка')),
                  DropdownButton<double>(
                    value: discount,
                    items: [0, 5, 10, 15, 20, 25, 30]
                        .map(
                          (value) => DropdownMenuItem<double>(
                            value: value.toDouble(),
                            child: Text('$value%'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => discount = value);
                      setSheetState(() {});
                    },
                  ),
                ],
              ),
              summaryRow(
                'К оплате',
                '${money(total)} ₽',
                bold: true,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Готово'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: bold ? 22 : 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomBar() {
    const labels = ['Чек', 'Смена', 'Статистика', 'Настройки'];
    const icons = [
      Icons.receipt_long_outlined,
      Icons.event_available_outlined,
      Icons.bar_chart_rounded,
      Icons.settings_outlined,
    ];

    return Container(
      height: 75,
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(
            labels.length,
            (index) => Expanded(
              child: InkWell(
                onTap: () {
                  setState(() => selectedTab = index);
                  if (index != 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Раздел «${labels[index]}» пока не подключён',
                        ),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[index],
                      color: index == selectedTab ? blue : grey,
                      size: 24,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: index == selectedTab ? blue : grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
