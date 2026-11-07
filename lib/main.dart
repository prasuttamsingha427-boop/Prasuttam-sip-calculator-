
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prasuttam SIP Calculator',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const SipHome(),
    );
  }
}

class SipHome extends StatefulWidget {
  const SipHome({super.key});

  @override
  State<SipHome> createState() => _SipHomeState();
}

class _SipHomeState extends State<SipHome> {
  final amount = TextEditingController(text: '5000');
  final rate = TextEditingController(text: '12');
  final years = TextEditingController(text: '10');

  double invested = 0;
  double profit = 0;
  double total = 0;

  void calculate() {
    double p = double.tryParse(amount.text) ?? 0;
    double r = (double.tryParse(rate.text) ?? 0) / 1200;
    int n = ((double.tryParse(years.text) ?? 0) * 12).round();

    if (p <= 0 || n <= 0 || r < 0) return;

    double result = r == 0
        ? p * n
        : p * ((powValue(1 + r, n) - 1) / r);

    setState(() {
      invested = p * n;
      total = result;
      profit = total - invested;
    });
  }

  double powValue(double x, int n) {
    double answer = 1;
    for (int i = 0; i < n; i++) {
      answer *= x;
    }
    return answer;
  }

  String money(double value) {
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prasuttam SIP Calculator'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Calculate Your SIP Returns',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monthly Investment (₹)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: rate,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Expected Annual Return (%)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: years,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Investment Period (Years)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: calculate,
            child: const Text('Calculate SIP'),
          ),
          const SizedBox(height: 25),
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Estimated Maturity Value'),
                  Text(
                    money(total),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(),
                  resultRow('Total Investment', invested),
                  resultRow('Estimated Profit', profit),
                ],
              ),
            ),
          ),
          const Text(
            'Note: Returns are estimates, not guaranteed.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget resultRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            money(value),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(const SipApp());
}

class SipApp extends StatelessWidget {
  const SipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prasuttam SIP Calculator',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const SipHome(),
    );
  }
}

class SipHome extends StatefulWidget {
  const SipHome({super.key});

  @override
  State<SipHome> createState() => _SipHomeState();
}

class _SipHomeState extends State<SipHome> {
  double monthly = 5000;
  double rate = 12;
  double years = 10;

  double get invested => monthly * years * 12;

  double get maturity {
    int months = (years * 12).round();
    double r = rate / 1200;

    if (r == 0) return invested;

    return monthly *
        ((power(1 + r, months) - 1) / r);
  }

  double get profit => maturity - invested;

  double power(double x, int n) {
    double answer = 1;
    for (int i = 0; i < n; i++) {
      answer *= x;
    }
    return answer;
  }

  String money(double value) {
    return '₹${value.round()}';
  }

  Widget resultRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          Text(
            money(value),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget sliderSection(
    String title,
    String value,
    double current,
    double min,
    double max,
    int divisions,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: current,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double investmentPart =
        maturity > 0 ? invested / maturity : 0;

    double profitPart =
        maturity > 0 ? profit / maturity : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prasuttam SIP Calculator'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.green,
              size: 48,
            ),
            const Text(
              'Plan Your Future',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),

            sliderSection(
              'Monthly Investment',
              money(monthly),
              monthly,
              500,
              50000,
              99,
              (v) => setState(() => monthly = v),
            ),

            sliderSection(
              'Expected Annual Return',
              '${rate.toStringAsFixed(1)}%',
              rate,
              1,
              20,
              38,
              (v) => setState(() => rate = v),
            ),

            sliderSection(
              'Investment Duration',
              '${years.round()} Years',
              years,
              1,
              40,
              39,
              (v) => setState(() => years = v),
            ),

            const SizedBox(height: 15),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text(
                      'Estimated Maturity Value',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      money(maturity),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Divider(height: 28),
                    resultRow('Total Investment', invested),
                    resultRow('Estimated Profit', profit),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Investment Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text('Your Invested Money'),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: investmentPart,
              minHeight: 15,
              color: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 15),

            const Text('Estimated Profit'),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: profitPart,
              minHeight: 15,
              color: Colors.green,
              backgroundColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 12),

            const Text(
              'Blue = Investment | Green = Estimated Profit',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 20),

            const Text(
              'Disclaimer: SIP returns are market-linked. '
              'Actual returns are not guaranteed. '
              'This calculator provides estimates only.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(const SipApp());
}

class SipApp extends StatelessWidget {
  const SipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prasuttam SIP Calculator',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const SipHome(),
    );
  }
}

class SipHome extends StatefulWidget {
  const SipHome({super.key});

  @override
  State<SipHome> createState() => _SipHomeState();
}

class _SipHomeState extends State<SipHome> {
  double monthly = 5000;
  double rate = 12;
  double years = 10;

  double get invested => monthly * years * 12;

  double get maturity {
    int months = (years * 12).round();
    double r = rate / 1200;

    if (r == 0) return invested;

    return monthly * ((power(1 + r, months) - 1) / r);
  }

  double get profit => maturity - invested;

  double power(double x, int n) {
    double result = 1;
    for (int i = 0; i < n; i++) {
      result *= x;
    }
    return result;
  }

  String money(double value) {
    int number = value.round();
    String digits = number.toString();

    if (digits.length <= 3) return '₹$digits';

    String lastThree = digits.substring(digits.length - 3);
    String remaining = digits.substring(0, digits.length - 3);

    String formatted = '';
    while (remaining.length > 2) {
      formatted = ',' + remaining.substring(remaining.length - 2) + formatted;
      remaining = remaining.substring(0, remaining.length - 2);
    }

    formatted = remaining + formatted + ',' + lastThree;
    return '₹$formatted';
  }

  void reset() {
    setState(() {
      monthly = 5000;
      rate = 12;
      years = 10;
    });
  }

  Widget resultRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          Text(
            money(value),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget sliderSection(
    String title,
    String value,
    double current,
    double min,
    double max,
    int divisions,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title)),
            Text(
              value,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: current,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double investmentPart = maturity > 0 ? invested / maturity : 0;
    double profitPart = maturity > 0 ? profit / maturity : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prasuttam SIP Calculator'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: reset,
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.green,
              size: 48,
            ),
            const Text(
              'Plan Your Future',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),

            sliderSection(
              'Monthly Investment',
              money(monthly),
              monthly,
              500,
              50000,
              99,
              (v) => setState(() => monthly = v),
            ),

            sliderSection(
              'Expected Annual Return',
              '${rate.toStringAsFixed(1)}%',
              rate,
              1,
              20,
              38,
              (v) => setState(() => rate = v),
            ),

            sliderSection(
              'Investment Duration',
              '${years.round()} Years',
              years,
              1,
              40,
              39,
              (v) => setState(() => years = v),
            ),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text('Estimated Maturity Value'),
                    const SizedBox(height: 8),
                    Text(
                      money(maturity),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Divider(height: 28),
                    resultRow('Total Investment', invested),
                    resultRow('Estimated Profit', profit),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Investment Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Center(
              child: SizedBox(
                width: 180,
                height: 180,
                child: CustomPaint(
                  painter: PiePainter(
                    investmentPart,
                    profitPart,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(width: 14, height: 14, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('Your Investment'),
                const Spacer(),
                Text('${(investmentPart * 100).toStringAsFixed(1)}%'),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Container(width: 14, height: 14, color: Colors.green),
                const SizedBox(width: 8),
                const Text('Estimated Profit'),
                const Spacer(),
                Text('${(profitPart * 100).toStringAsFixed(1)}%'),
              ],
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: reset,
                icon: const Icon(Icons.refresh),
                label: const Text('RESET CALCULATOR'),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Disclaimer: SIP returns are market-linked. '
              'Actual returns are not guaranteed. '
              'This calculator provides estimates only.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class PiePainter extends CustomPainter {
  final double investment;
  final double profit;

  PiePainter(this.investment, this.profit);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bluePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final greenPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    double investmentSweep = 6.283185307 * investment;

    canvas.drawArc(
      rect,
      -1.570796327,
      investmentSweep,
      true,
      bluePaint,
    );

    canvas.drawArc(
      rect,
      -1.570796327 + investmentSweep,
      6.283185307 * profit,
      true,
      greenPaint,
    );

    final holePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius * 0.53,
      holePaint,
    );

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'SIP',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant PiePainter oldDelegate) {
    return oldDelegate.investment != investment ||
        oldDelegate.profit != profit;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SipApp());
}

class SipApp extends StatelessWidget {
  const SipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prasuttam SIP Calculator',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const SipHome(),
    );
  }
}

class SipHome extends StatefulWidget {
  const SipHome({super.key});

  @override
  State<SipHome> createState() => _SipHomeState();
}

class _SipHomeState extends State<SipHome> {
  double monthly = 5000;
  double rate = 12;
  double years = 10;

  double get invested => monthly * years * 12;

  double power(double x, int n) {
    double result = 1;
    for (int i = 0; i < n; i++) {
      result *= x;
    }
    return result;
  }

  double get maturity {
    int months = (years * 12).round();
    double r = rate / 1200;
    if (r == 0) return invested;
    return monthly * (power(1 + r, months) - 1) / r;
  }

  double get profit => maturity - invested;

  String money(double value) {
    int number = value.round();
    String digits = number.toString();

    if (digits.length <= 3) return '₹$digits';

    String last = digits.substring(digits.length - 3);
    String rest = digits.substring(0, digits.length - 3);
    String formatted = '';

    while (rest.length > 2) {
      formatted = ',' + rest.substring(rest.length - 2) + formatted;
      rest = rest.substring(0, rest.length - 2);
    }

    return '₹$rest$formatted,$last';
  }

  void reset() {
    setState(() {
      monthly = 5000;
      rate = 12;
      years = 10;
    });
  }

  void showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.account_balance_wallet,
          color: Colors.green,
          size: 50,
        ),
        title: const Text('Prasuttam SIP Calculator'),
        content: const Text(
          'A simple SIP calculator to estimate '
          'your mutual fund investment growth.\n\n'
          'Created with Flutter.\n'
          'Brand: Prasuttam Finance\n\n'
          'Note: Investment returns are not guaranteed.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  Future<void> copyDetails() async {
    await Clipboard.setData(
      const ClipboardData(
        text: 'Prasuttam SIP Calculator - '
            'Calculate your estimated SIP returns. '
            'Created with Flutter.',
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App details copied successfully!'),
      ),
    );
  }

  Widget resultRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          Text(
            money(value),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget sliderSection(
    String title,
    String value,
    double current,
    double min,
    double max,
    int divisions,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title)),
            Text(
              value,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: current,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double investmentPart =
        maturity > 0 ? invested / maturity : 0;
    double profitPart =
        maturity > 0 ? profit / maturity : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prasuttam SIP Calculator',
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: const Icon(Icons.account_balance_wallet),
        actions: [
          IconButton(
            onPressed: showAbout,
            icon: const Icon(Icons.info_outline),
            tooltip: 'About App',
          ),
          IconButton(
            onPressed: reset,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const SizedBox(height: 8),
            const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.trending_up,
                size: 42,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'PRASUTTAM FINANCE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Text(
              'Plan Smart. Invest Better.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),

            const Text(
              'Your SIP Investment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            sliderSection(
              'Monthly Investment',
              money(monthly),
              monthly,
              500,
              50000,
              99,
              (v) => setState(() => monthly = v),
            ),

            sliderSection(
              'Expected Annual Return',
              '${rate.toStringAsFixed(1)}%',
              rate,
              1,
              20,
              38,
              (v) => setState(() => rate = v),
            ),

            sliderSection(
              'Investment Duration',
              '${years.round()} Years',
              years,
              1,
              40,
              39,
              (v) => setState(() => years = v),
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text('Estimated Maturity Value'),
                    const SizedBox(height: 8),
                    Text(
                      money(maturity),
                      style: const TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Divider(height: 28),
                    resultRow('Total Investment', invested),
                    resultRow('Estimated Profit', profit),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Investment Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            Center(
              child: SizedBox(
                width: 180,
                height: 180,
                child: CustomPaint(
                  painter: PiePainter(
                    investmentPart,
                    profitPart,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Icon(Icons.circle, color: Colors.blue, size: 13),
                const SizedBox(width: 8),
                const Text('Your Investment'),
                const Spacer(),
                Text('${(investmentPart * 100).toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 13),
                const SizedBox(width: 8),
                const Text('Estimated Profit'),
                const Spacer(),
                Text('${(profitPart * 100).toStringAsFixed(1)}%'),
              ],
            ),

            const SizedBox(height: 22),

            OutlinedButton.icon(
              onPressed: reset,
              icon: const Icon(Icons.refresh),
              label: const Text('RESET CALCULATOR'),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: copyDetails,
              icon: const Icon(Icons.copy),
              label: const Text('COPY APP DETAILS'),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: showAbout,
              icon: const Icon(Icons.info_outline),
              label: const Text('ABOUT OUR APP'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Prasuttam Finance\n'
              'Disclaimer: Mutual fund returns are market-linked '
              'and not guaranteed. This calculator provides estimates only.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class PiePainter extends CustomPainter {
  final double investment;
  final double profit;

  PiePainter(this.investment, this.profit);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    canvas.drawArc(
      rect,
      -1.570796327,
      6.283185307 * investment,
      true,
      Paint()..color = Colors.blue,
    );

    canvas.drawArc(
      rect,
      -1.570796327 + 6.283185307 * investment,
      6.283185307 * profit,
      true,
      Paint()..color = Colors.green,
    );

    canvas.drawCircle(
      center,
      radius * 0.53,
      Paint()..color = Colors.white,
    );

    final painter = TextPainter(
      text: const TextSpan(
        text: 'SIP',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(
      canvas,
      Offset(
        center.dx - painter.width / 2,
        center.dy - painter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant PiePainter oldDelegate) {
    return oldDelegate.investment != investment ||
        oldDelegate.profit != profit;
  }
}
