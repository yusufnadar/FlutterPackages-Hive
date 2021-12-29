import 'package:flutter/material.dart';
import 'package:flutter_packages/hive/hive_box.dart';
import 'package:flutter_packages/hive/model/amount.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AmountPage extends StatefulWidget {
  const AmountPage({Key? key}) : super(key: key);

  @override
  _AmountPageState createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  final textController = TextEditingController();
  final amountController = TextEditingController();
  var isPlus;

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive'),
      ),
      body: ValueListenableBuilder<Box<AmountModel>>(
        valueListenable: HiveBox.getAmount().listenable(),
        builder: (context, box, widget) {
          var amounts = box.values.toList();
          return buildList(amounts);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addAmount(context,null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void addAmount(BuildContext context, AmountModel? amount) {

    if(amount != null){
      textController.text = amount.name;
      amountController.text = amount.amount.toString();
      isPlus = amount.isPlus;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Column(
            children: [
              TextFormField(
                controller: textController,
                decoration: const InputDecoration(hintText: 'Başlık'),
              ),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(hintText: 'Miktar'),
              ),
              RadioListTile(
                value: true,
                groupValue: isPlus,
                onChanged: (value) {
                  setState(() {
                    isPlus = value;
                  });
                },
                title: const Text('True'),
              ),
              RadioListTile(
                value: false,
                groupValue: isPlus,
                onChanged: (value) {
                  setState(() {
                    isPlus = value;
                  });
                },
                title: const Text('False'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if(amount == null){
                  // ekleme işlemi
                  var amount = AmountModel()
                    ..name = textController.text
                    ..amount = double.parse(amountController.text)
                    ..isPlus = isPlus;
                  var box = HiveBox.getAmount();
                  box.add(amount);
                }else{
                  // güncelleme işlemi
                  amount
                    ..name = textController.text
                    ..amount = double.parse(amountController.text)
                    ..isPlus = isPlus;
                  amount.save();
                }
                textController.clear();
                amountController.clear();
                Navigator.pop(context);
              },
              child:  amount == null ? const Text('Kaydet') : const Text('Güncelle'),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Vazgeç')),
          ],
        );
      }),
    );
  }

  Widget buildList(List<AmountModel> amounts) {
    if (amounts.isEmpty) {
      return const Center(
        child: Text('Empty List'),
      );
    } else {
      var totalAmount = amounts.fold<double>(
          0,
          (previousValue, element) => element.isPlus
              ? previousValue + element.amount
              : previousValue - element.amount);
      var color;
      if (totalAmount > 0) {
        color = Colors.green;
      } else {
        color = Colors.red;
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              totalAmount.toString(),
              style: TextStyle(color: color, fontSize: 30),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: amounts.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    child: ExpansionTile(
                      title: Text(amounts[index].name),
                      trailing: Text(amounts[index].amount.toString()),
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            var thisAmount = amounts[index];
                            thisAmount.delete();
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Sil'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            addAmount(context,amounts[index]);
                          },
                          icon: const Icon(Icons.update),
                          label: const Text('Güncelle'),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      );
    }
  }
}
