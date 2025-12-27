import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../widgets/primary_button.dart';
import '../models/cart_item.dart';
import 'order_confirmation_screen.dart';

class CardDetailsScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;

  const CardDetailsScreen({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _numberController = TextEditingController(); // In real app, use input formatters
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  Future<void> _onSaveCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulate card save/validation
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            totalAmount: widget.totalAmount,
            paymentMethod: 'Visa ending in ${_numberController.text.length >= 4 ? _numberController.text.substring(_numberController.text.length - 4) : 'xxxx'}',
            cartItems: widget.cartItems,
          ),
        ),
      );

      if (result == true && mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       const Text('Card Owner'),
                       const SizedBox(height: 8),
                       TextFormField(
                         controller: _nameController,
                         decoration: const InputDecoration(
                           hintText: 'Mr. John Doe',
                           filled: true,
                           border: OutlineInputBorder(),
                         ),
                         validator: (v) => v?.isEmpty == true ? 'Required' : null,
                       ),
                       const SizedBox(height: AppSpacing.md),
                       
                       const Text('Card Number'),
                       const SizedBox(height: 8),
                       TextFormField(
                         controller: _numberController,
                         keyboardType: TextInputType.number,
                         maxLength: 16,
                         decoration: const InputDecoration(
                           hintText: '1234 5678 1234 5678',
                           filled: true,
                           border: OutlineInputBorder(),
                           counterText: '',
                         ),
                         validator: (v) => (v?.length ?? 0) < 13 ? 'Invalid Number' : null,
                       ),
                       const SizedBox(height: AppSpacing.md),
                       
                       Row(
                         children: [
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 const Text('EXP'),
                                 const SizedBox(height: 8),
                                 TextFormField(
                                   controller: _expiryController,
                                   keyboardType: TextInputType.datetime,
                                   decoration: const InputDecoration(
                                     hintText: 'MM/YY',
                                     filled: true,
                                     border: OutlineInputBorder(),
                                   ),
                                   validator: (v) => v?.isEmpty == true ? 'Required' : null,
                                 ),
                               ],
                             ),
                           ),
                           const SizedBox(width: AppSpacing.md),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 const Text('CVV'),
                                 const SizedBox(height: 8),
                                 TextFormField(
                                   controller: _cvvController,
                                   keyboardType: TextInputType.number,
                                   maxLength: 3,
                                   obscureText: true,
                                   decoration: const InputDecoration(
                                     hintText: '123',
                                     filled: true,
                                     border: OutlineInputBorder(),
                                     counterText: '',
                                   ),
                                   validator: (v) => (v?.length ?? 0) < 3 ? 'Invalid' : null,
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton(
                label: 'Save & Continue',
                onPressed: _onSaveCard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
