import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:fl_chart/fl_chart.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  String _expression = '';
  String _result = '0';
  List<String> _history = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _numClick(String text) {
    setState(() {
      _expression += text;
    });
  }

  void _clear(String text) {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  void _evaluate(String text) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        _result = eval.toString();
        _history.add('$_expression = $_result');
        _expression = '';
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String text, {Color color = Colors.blueAccent}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (text == 'C') {
            _clear(text);
          } else if (text == '=') {
            _evaluate(text);
          } else {
            _numClick(text);
          }
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          backgroundColor: color,
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Expanded(
      child: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _history[index],
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator & Unit Converter & Graphing'),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Calculator'),
            Tab(text: 'Unit Converter'),
            Tab(text: 'Graphing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalculator(),
          _buildUnitConverter(),
          _buildGraphingCalculator(),
        ],
      ),
    );
  }

  Widget _buildCalculator() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(
            _expression,
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(
            _result,
            style: TextStyle(fontSize: 48, color: Colors.white),
          ),
        ),
        Expanded(
          child: _buildHistory(),
        ),
        Divider(),
        Column(
          children: [
            Row(children: [
              _buildButton("7"),
              _buildButton("8"),
              _buildButton("9"),
              _buildButton("/", color: Colors.blueAccent),
            ]),
            Row(children: [
              _buildButton("4"),
              _buildButton("5"),
              _buildButton("6"),
              _buildButton("*", color: Colors.blueAccent),
            ]),
            Row(children: [
              _buildButton("1"),
              _buildButton("2"),
              _buildButton("3"),
              _buildButton("-", color: Colors.blueAccent),
            ]),
            Row(children: [
              _buildButton("."),
              _buildButton("0"),
              _buildButton("C", color: Colors.blueAccent),
              _buildButton("+", color: Colors.blueAccent),
            ]),
            Row(children: [
              _buildButton("(", color: Colors.blueAccent),
              _buildButton(")", color: Colors.blueAccent),
              _buildButton("^", color: Colors.blueAccent),
              _buildButton("=", color: Colors.blueAccent),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _buildUnitConverter() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildLengthConverter(),
          _buildWeightConverter(),
          _buildTemperatureConverter(),
        ],
      ),
    );
  }

  Widget _buildLengthConverter() {
    return UnitConverter(
      title: 'Length Converter',
      units: ['Meters', 'Kilometers', 'Miles', 'Yards'],
      conversionRates: {
        'Meters': 1,
        'Kilometers': 1000,
        'Miles': 1609.34,
        'Yards': 0.9144
      },
    );
  }

  Widget _buildWeightConverter() {
    return UnitConverter(
      title: 'Weight Converter',
      units: ['Grams', 'Kilograms', 'Pounds', 'Ounces'],
      conversionRates: {
        'Grams': 1,
        'Kilograms': 1000,
        'Pounds': 453.592,
        'Ounces': 28.3495
      },
    );
  }

  Widget _buildTemperatureConverter() {
    return TemperatureConverter();
  }

  Widget _buildGraphingCalculator() {
    return GraphingCalculator();
  }
}

class UnitConverter extends StatefulWidget {
  final String title;
  final List<String> units;
  final Map<String, double> conversionRates;

  UnitConverter({
    required this.title,
    required this.units,
    required this.conversionRates,
  });

  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  String _fromUnit = '';
  String _toUnit = '';
  String _input = '';
  String _output = '';

  @override
  void initState() {
    super.initState();
    _fromUnit = widget.units[0];
    _toUnit = widget.units[1];
  }

  void _convert() {
    if (_input.isEmpty) return;

    double inputValue = double.tryParse(_input) ?? 0;
    double fromRate = widget.conversionRates[_fromUnit]!;
    double toRate = widget.conversionRates[_toUnit]!;
    double outputValue = (inputValue * fromRate) / toRate;

    setState(() {
      _output = outputValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.headline6),
            TextField(
              decoration: InputDecoration(labelText: 'Input Value'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _input = value;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromUnit,
                    onChanged: (newValue) {
                      setState(() {
                        _fromUnit = newValue!;
                      });
                    },
                    items: widget.units
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Icon(Icons.arrow_forward),
                Expanded(
                  child: DropdownButton<String>(
                    value: _toUnit,
                    onChanged: (newValue) {
                      setState(() {
                        _toUnit = newValue!;
                      });
                    },
                    items: widget.units
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            Text(
              _output,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  String _fromUnit = 'Celsius';
  String _toUnit = 'Fahrenheit';
  String _input = '';
  String _output = '';

  void _convert() {
    if (_input.isEmpty) return;

    double inputValue = double.tryParse(_input) ?? 0;
    double outputValue = 0;

    if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') {
      outputValue = (inputValue * 9 / 5) + 32;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') {
      outputValue = (inputValue - 32) * 5 / 9;
    } else if (_fromUnit == 'Celsius' && _toUnit == 'Kelvin') {
      outputValue = inputValue + 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Celsius') {
      outputValue = inputValue - 273.15;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Kelvin') {
      outputValue = (inputValue - 32) * 5 / 9 + 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Fahrenheit') {
      outputValue = (inputValue - 273.15) * 9 / 5 + 32;
    }

    setState(() {
      _output = outputValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Temperature Converter',
                style: Theme.of(context).textTheme.headline6),
            TextField(
              decoration: InputDecoration(labelText: 'Input Value'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _input = value;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromUnit,
                    onChanged: (newValue) {
                      setState(() {
                        _fromUnit = newValue!;
                      });
                    },
                    items: <String>['Celsius', 'Fahrenheit', 'Kelvin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Icon(Icons.arrow_forward),
                Expanded(
                  child: DropdownButton<String>(
                    value: _toUnit,
                    onChanged: (newValue) {
                      setState(() {
                        _toUnit = newValue!;
                      });
                    },
                    items: <String>['Celsius', 'Fahrenheit', 'Kelvin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            Text(
              _output,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class GraphingCalculator extends StatefulWidget {
  @override
  _GraphingCalculatorState createState() => _GraphingCalculatorState();
}

class _GraphingCalculatorState extends State<GraphingCalculator> {
  String _expression = '';
  List<FlSpot> _points = [];

  void _plotGraph() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      List<FlSpot> points = [];

      for (double x = -10; x <= 10; x += 0.1) {
        cm.bindVariable(Variable('x'), Number(x));
        double y = exp.evaluate(EvaluationType.REAL, cm);
        points.add(FlSpot(x, y));
      }

      setState(() {
        _points = points;
      });
    } catch (e) {
      setState(() {
        _points = [];
      });
      // Show error message if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
              labelText: 'Enter expression (e.g., x^2 + 2*x + 1)'),
          onChanged: (value) {
            _expression = value;
          },
        ),
        ElevatedButton(
          onPressed: _plotGraph,
          child: Text('Plot Graph'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _points,
                    isCurved: true,
                    colors: [Colors.blue],
                    barWidth: 2,
                  ),
                ],
                minX: -10,
                maxX: 10,
                minY: -10,
                maxY: 10,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        return value.toInt() % 5 == 0
                            ? value.toInt().toString()
                            : '';
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        return value.toInt() % 5 == 0
                            ? value.toInt().toString()
                            : '';
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AxisTitles({required SideTitles sideTitles}) {}
}
