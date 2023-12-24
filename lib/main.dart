import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  _loadItems() async {
    List<Map<String, dynamic>> items = await dbHelper.getItems();
    setState(() {
      _items = items;
    });
  }

  _addItem() async {
    String itemName = _textEditingController.text;
    if (itemName.isNotEmpty) {
      await dbHelper.insertItem({'name': itemName});
      _textEditingController.clear();
      _loadItems();
    }
  }

  _queryItems() async {
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ativiade BD'),
      ),
      body: Container(
        color: Colors.yellow, // Cor de fundo amarelo
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Digite um item',
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text('Adicionar'),
                ),
                ElevatedButton(
                  onPressed: _queryItems,
                  child: Text('Consultar'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_items[index]['name']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
