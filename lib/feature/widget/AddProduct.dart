import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../product_notifier.dart';

class AddWidgetDialog extends ConsumerWidget{
  const AddWidgetDialog({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller1 = TextEditingController();
    final TextEditingController controller2 = TextEditingController();

    return AlertDialog(
      title: const Text('Add Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller1,
            decoration: const InputDecoration(
              hintText: 'Product Name',
            ),
          ),
          TextField(
            controller: controller2,
            decoration: const InputDecoration(
              hintText: 'Price',
            ), keyboardType: TextInputType.number
          ),
          ElevatedButton(

            onPressed: () {
              final navigator = Navigator.of(context);
              // Handle add button press
              ref.read(productNotifierProvider.notifier).addProduct(
                  Product(productid: "0", name: controller1.text.toString(), price:controller2.text.toString())
              );
              ref.read(productNotifierProvider.notifier).fetchProducts();
              // pop the alertdialog
              navigator.pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

}