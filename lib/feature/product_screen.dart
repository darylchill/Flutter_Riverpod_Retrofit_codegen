
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/feature/login.dart';
import 'package:fluttertest/feature/product_notifier.dart';
import 'package:fluttertest/feature/widget/AddProduct.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_notifier.dart';
import 'widget/DeleteProduct.dart';
import 'widget/UpdateProduct.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _RiverpodExampleState();
}

class _RiverpodExampleState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();
     ref.read(productNotifierProvider.notifier).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products'),),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Flutter Test App - Products'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                // Logout
                await ref.read(loginNotifierProvider.notifier).logout().then((value){
                  if(value=="success"){
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
                    });

                  }else{
                    Fluttertoast.showToast(
                      msg: '$value',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
      body: productState.when(
          data: (products) {
            if(products.isEmpty){
              return const Center(child: Text("Empty",style: TextStyle(fontSize: 20),));
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 15,
                  child: ListTile(
                    // ROW USAGE
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                      [
                        Text(product.productid),
                        const SizedBox(width: 10,),
                        Text(product.name)
                      ],),
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return  UpdateWidgetDialog(product);
                          });
                    },
                    onLongPress: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return  DeleteWidgetDialog(product);
                          });
                    },
                    subtitle: Text('Price: ${product.price}'),
                    trailing: Text("Tap to Update, Long Press to Delete"),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stack) {
            debugPrint('Error: $error');
            return Center(child: Text('Error: $error'));
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Fetch initial load

          showDialog(
              context: context,

              builder: (BuildContext context) {
                return const AddWidgetDialog();
              });
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
