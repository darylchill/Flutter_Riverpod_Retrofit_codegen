import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../product_notifier.dart';

class DeleteWidgetDialog extends ConsumerWidget{
  final Product product;
  const DeleteWidgetDialog(this.product, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Removing Product from the list'),
      content: const Text('Continue?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: ()  async {
            debugPrint('Deleting Product with id: ${product.productid}');
            final navigator = Navigator.of(context);
            //get Delete function from notifier
            ref.read(productNotifierProvider.notifier).deleteProduct(product);

            ref.read(productNotifierProvider.notifier).fetchProducts();
            // pop the alertdialog
            navigator.pop();
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

}