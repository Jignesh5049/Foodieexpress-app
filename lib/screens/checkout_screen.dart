import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../data/local/app_database.dart';
import '../models/address.dart';
import '../models/order_history.dart';
import '../models/payment_method.dart';
import 'delivery_addresses_screen.dart';
import 'home_screen.dart';
import 'payment_methods_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String deliveryTime = 'ASAP';
  final AppDatabase _database = AppDatabase.instance;
  List<Address> _addresses = [];
  List<PaymentMethod> _paymentMethods = [];
  double _walletBalance = 0;
  int? _selectedAddressId;
  String _selectedPaymentKey = 'wallet';
  bool _loadingLocal = true;

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    final addresses = await _database.getAddresses();
    final methods = await _database.getPaymentMethods();
    final walletBalance = await _database.getWalletBalance();
    if (!mounted) {
      return;
    }
    setState(() {
      _addresses = addresses;
      _paymentMethods = methods;
      _walletBalance = walletBalance;
      _selectedAddressId ??= addresses.isNotEmpty ? addresses.first.id : null;
      if (_selectedPaymentKey.isEmpty) {
        _selectedPaymentKey = 'wallet';
      }
      _loadingLocal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Checkout'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddressSection(),
                        const SizedBox(height: 24),
                        _buildPaymentSection(),
                        const SizedBox(height: 24),
                        _buildDeliveryTimeSection(),
                      ],
                    ),
                  ),
                ),
                _buildPlaceOrderBar(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Choose your saved address',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeliveryAddressesScreen(),
                    ),
                  );
                  await _loadLocalData();
                },
                child: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_loadingLocal)
            const Center(child: CircularProgressIndicator())
          else if (_addresses.isEmpty)
            const Text(
              'No saved addresses. Add one to continue.',
              style: TextStyle(color: Colors.grey),
            )
          else
            Column(
              children: _addresses
                  .map(
                    (address) => RadioListTile<int>(
                      value: address.id ?? 0,
                      groupValue: _selectedAddressId,
                      onChanged: (value) {
                        setState(() {
                          _selectedAddressId = value;
                        });
                      },
                      title: Text(address.label),
                      subtitle: Text('${address.street}, ${address.city}'),
                      activeColor: const Color(0xFF6366F1),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.payment, color: Color(0xFF6366F1)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodsScreen(),
                    ),
                  );
                  await _loadLocalData();
                },
                child: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RadioListTile<String>(
            value: 'wallet',
            groupValue: _selectedPaymentKey,
            onChanged: (value) {
              setState(() {
                _selectedPaymentKey = value ?? 'wallet';
              });
            },
            title: const Text('In-App Money'),
            subtitle: Text(
              'Balance: ₹${_walletBalance.toStringAsFixed(2)}',
            ),
            activeColor: const Color(0xFF6366F1),
          ),
          if (_paymentMethods.isEmpty)
            const Text(
              'No saved cards or UPI. Add one to continue.',
              style: TextStyle(color: Colors.grey),
            )
          else
            Column(
              children: _paymentMethods
                  .map(
                    (method) => RadioListTile<String>(
                      value: 'method_${method.id}',
                      groupValue: _selectedPaymentKey,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentKey = value ?? '';
                        });
                      },
                      title: Text(method.label),
                      subtitle: Text(method.details),
                      activeColor: const Color(0xFF6366F1),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Time',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'When do you want it?',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDeliveryTimeOption(
                  'ASAP',
                  '20-30 mins',
                  deliveryTime == 'ASAP',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDeliveryTimeOption(
                  'Schedule',
                  'Choose time',
                  deliveryTime == 'Schedule',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBar(CartState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _handlePlaceOrder(state),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Place Order - ₹${state.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'By placing this order, you agree to our terms and conditions',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimeOption(
    String title,
    String subtitle,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          deliveryTime = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF6366F1) : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePlaceOrder(CartState state) async {
    if (_selectedAddressId == null) {
      _showSnack('Please select a delivery address.');
      return;
    }

    final address = _addresses.firstWhere(
      (item) => item.id == _selectedAddressId,
      orElse: () => _addresses.first,
    );

    String paymentLabel = 'In-App Money';
    if (_selectedPaymentKey != 'wallet') {
      final id = int.tryParse(
        _selectedPaymentKey.replaceFirst('method_', ''),
      );
      final method = _paymentMethods.firstWhere(
        (item) => item.id == id,
        orElse: () => const PaymentMethod(
          id: null,
          type: 'wallet',
          label: 'In-App Money',
          details: '',
        ),
      );
      paymentLabel = method.label;
    } else if (_walletBalance < state.totalAmount) {
      _showSnack('Insufficient wallet balance.');
      return;
    }

    final order = OrderHistory(
      createdAt: DateTime.now().toIso8601String(),
      total: state.totalAmount,
      itemsCount: state.items.length,
      addressLabel: address.label,
      paymentLabel: paymentLabel,
    );
    await _database.insertOrderHistory(order);
    if (_selectedPaymentKey == 'wallet') {
      _walletBalance -= state.totalAmount;
      await _database.setWalletBalance(_walletBalance);
    }

    if (!mounted) {
      return;
    }
    _showOrderConfirmation(state);
  }

  void _showOrderConfirmation(CartState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text('Order Placed!'),
          ],
        ),
        content: const Text(
          'Your order has been successfully placed. You will receive a confirmation shortly.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<CartBloc>().add(ClearCart());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
