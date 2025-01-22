import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../product_notifier.dart';

class UpdateWidgetDialog extends ConsumerWidget{
  final Product product;
  const UpdateWidgetDialog(this.product, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller1 = TextEditingController();
    final TextEditingController controller2 = TextEditingController();

    controller1.text = product.name;
    controller2.text = product.price;

    return AlertDialog(
      title: const Text('Update Widget'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller1,
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
          TextField(
            controller: controller2,
            decoration: const InputDecoration(
              hintText: 'Price',
            ),
              keyboardType: TextInputType.number
          ),
          ElevatedButton(
            onPressed: () {
              final navigator = Navigator.of(context);
              // Handle add button press
              ref.read(productNotifierProvider.notifier).updateProduct(
                  Product(
                    productid:product.productid,
                      name: controller1.text.toString(),
                      price: controller2.text.toString(),
                  )
              );
              ref.read(productNotifierProvider.notifier).fetchProducts();
              // pop the alertdialog
              navigator.pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

}