import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../../main.dart';

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ApiClient apiClient;

  ProductNotifier(this.apiClient) : super(const AsyncLoading());

  Future<void> fetchProducts() async {
    try {
      final product = await apiClient.getProducts();
      state = AsyncData(product);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> addProduct(Product product) async {
    final previousState = state; // Store previous state in case of failure.
    try {
      debugPrint('Adding Product: ${product.productid} ${product.name} ${product.price}');
       final addedProduct = await apiClient.addProduct(product);
      // Append the newly added tutor to the current list of tutors.
      final currentProduct = state.asData?.value ?? [];
      state = AsyncData([...currentProduct, addedProduct]);

    } catch (e, st) {
      state = previousState; // Revert to previous state on error.
      state = AsyncError(e, st); // Handle errors.
    }
  }


// Update tutor using PUT request and update the state.
  Future<void> updateProduct(Product product) async {
    final previousState = state; // Store previous state in case of failure.

    try {
      // Send the PUT request to update the product.
      final updatedProduct= await apiClient.updateProduct(product);

      // Update the tutor in the current list of tutors.
      final currentProduct= state.asData?.value ?? [];
      final updatedProducts = currentProduct.map((e) => e.productid == updatedProduct.productid ? updatedProduct : e).toList();
      state = AsyncData(updatedProducts);
    } catch (e, st) {
      debugPrint('Update Error: $st',);
      state = previousState; // Revert to previous state on error.
      state = AsyncError(e, st); // Handle errors.
    }
  }

// Delete tutor using DELETE request and update the state.
  Future<void> deleteProduct(Product product) async {
    final previousState = state; // Store previous state in case of failure.
    try {
      // Send the DELETE request to delete the tutor.
      await apiClient.deleteProduct(product);

      // Remove the tutor from the current list of tutors.
      final currentProduct = state.asData?.value ?? [];
      final updatedProduct = currentProduct.where((e) => e.productid != product.productid).toList();
      state = AsyncData(updatedProduct);
    } catch (e, st) {
      state = previousState; // Revert to previous state on error.
      state = AsyncError(e, st); // Handle errors.
    }
  }
}



//Riverpod provider to expose ProductNotifier
final productNotifierProvider = StateNotifierProvider<ProductNotifier,AsyncValue<List<Product>>>((ref) {
  final apiClient = ref.read(apiClientProvider);

  return ProductNotifier(apiClient);
});
