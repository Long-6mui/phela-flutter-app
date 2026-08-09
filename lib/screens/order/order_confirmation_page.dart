import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import 'dart:convert';

const _brandColor = Color(0xFFBF8248);
const _dividerColor = Color(0xFFF4EFE3);

class OrderConfirmationItem {
  final String name;
  final String imagePath;
  final int unitPrice;
  final int quantity;
  final String option;

  const OrderConfirmationItem({
    required this.name,
    required this.imagePath,
    required this.unitPrice,
    required this.quantity,
    required this.option,
  });
}

class OrderConfirmationPage extends StatefulWidget {
  final List<OrderConfirmationItem> items;
  final int subtotal;
  final String recipientName;
  final String recipientPhone;
  final String deliveryAddress;
  final String storeName;
  final String storePhone;
  final String storeAddress;
  final bool isPickup;
  final VoidCallback onConfirmed;

  const OrderConfirmationPage({
    super.key,
    required this.items,
    required this.subtotal,
    required this.recipientName,
    required this.recipientPhone,
    required this.deliveryAddress,
    required this.storeName,
    required this.storePhone,
    required this.storeAddress,
    required this.isPickup,
    required this.onConfirmed,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  String _paymentMethod = 'MoMo';
  bool _requestInvoice = false;

  int get _deliveryFee => widget.isPickup ? 0 : 18000;
  int get _total => widget.subtotal + _deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
        ),
        title: const Text(
          'Xác nhận đơn hàng',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          const _SectionDivider(),
          _DeliverySection(
            title: widget.isPickup ? 'Đến lấy tại' : 'Giao hàng tận nơi',
            recipientName: widget.isPickup
                ? widget.storeName
                : widget.recipientName,
            recipientPhone: widget.isPickup
                ? widget.storePhone
                : widget.recipientPhone,
            deliveryAddress: widget.isPickup
                ? widget.storeAddress
                : widget.deliveryAddress,
            isPickup: widget.isPickup,
          ),
          const _SectionDivider(),
          _StoreSection(storeName: widget.storeName),
          const _SectionDivider(),
          _ProductsSection(items: widget.items),
          const _SectionDivider(),
          const _PromotionSection(),
          const _SectionDivider(),
          _PaymentSection(
            selectedMethod: _paymentMethod,
            onChanged: (value) => setState(() => _paymentMethod = value),
          ),
          const _SectionDivider(),
          _PaymentSummary(
            itemCount: widget.items.fold(
              0,
              (total, item) => total + item.quantity,
            ),
            subtotal: widget.subtotal,
            deliveryFee: _deliveryFee,
            total: _total,
          ),
          const _SectionDivider(),
          CheckboxListTile(
            value: _requestInvoice,
            onChanged: (value) {
              setState(() => _requestInvoice = value ?? false);
            },
            title: const Text(
              'Yêu cầu xuất hoá đơn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            activeColor: _brandColor,
            checkColor: Colors.white,
            side: const BorderSide(color: _brandColor),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: const Color(0xFFF8EEDC),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: widget.items.isEmpty ? null : _confirmOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFD8C1A8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'XÁC NHẬN ĐƠN HÀNG',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmOrder() async {
    final firstItemName = widget.items.isNotEmpty ? widget.items.first.name : 'Đơn hàng';
    final itemNameStr = widget.items.length > 1 
        ? '$firstItemName và các món khác' 
        : firstItemName;
        
    final totalQty = widget.items.fold(0, (sum, item) => sum + item.quantity);

    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} '
                    '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // ĐÓNG GÓI DANH SÁCH MÓN THÀNH JSON
    final itemsList = widget.items.map((item) => {
      'name': item.name,
      'quantity': item.quantity,
      'price': item.unitPrice,
      'option': item.option,
    }).toList();
    final itemsJsonStr = jsonEncode(itemsList);

    final newOrder = OrderModel(
      userEmail: '', 
      storeName: widget.storeName,
      itemName: itemNameStr,
      quantity: totalQty,
      totalPrice: _total,
      orderDate: dateStr,
      paymentMethod: _paymentMethod,
      recipientName: widget.recipientName,
      phone: widget.recipientPhone,
      addressStr: widget.deliveryAddress,
      isPickup: widget.isPickup ? 1 : 0,
      itemsJson: itemsJsonStr, // <-- ĐÃ LƯU DANH SÁCH VÀO ĐÂY
    );

    await OrderService.addOrder(newOrder);

    widget.onConfirmed();
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OrderSuccessPage()),
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFAA7041);
    const creamColor = Color(0xFFFFE8C7);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 178,
                  height: 178,
                  decoration: const BoxDecoration(
                    color: creamColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 112,
                    color: backgroundColor,
                  ),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Đặt hàng thành công!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: creamColor,
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Đơn hàng của bạn đã được tiếp nhận\nvà sẽ sớm được giao đến.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: creamColor,
                    fontSize: 17,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 64),
                SizedBox(
                  width: 210,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: creamColor,
                      side: const BorderSide(color: creamColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'VỀ TRANG CHỦ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeliverySection extends StatelessWidget {
  final String title;
  final String recipientName;
  final String recipientPhone;
  final String deliveryAddress;
  final bool isPickup;

  const _DeliverySection({
    required this.title,
    required this.recipientName,
    required this.recipientPhone,
    required this.deliveryAddress,
    required this.isPickup,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, action: 'Thay đổi'),
          const SizedBox(height: 18),
          Text(
            recipientName,
            style: const TextStyle(
              color: _brandColor,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '$recipientPhone\n$deliveryAddress',
                  style: const TextStyle(fontSize: 17, height: 1.4),
                ),
              ),
              const Icon(Icons.chevron_right, color: _brandColor),
            ],
          ),
          if (!isPickup) ...[
            const SizedBox(height: 14),
            TextField(
              decoration: InputDecoration(
                hintText: 'Thêm hướng dẫn giao hàng',
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 17),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE8D7C4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: _brandColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StoreSection extends StatelessWidget {
  final String storeName;

  const _StoreSection({required this.storeName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Từ cửa hàng',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  storeName,
                  style: const TextStyle(
                    color: _brandColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: _brandColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  final List<OrderConfirmationItem> items;

  const _ProductsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sản phẩm đã chọn',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Sản phẩm sẽ phục vụ đá riêng (trừ các món đá xay). Nếu cần để đá chung, vui lòng thêm vào mục “Ghi chú cho cửa hàng”.',
              style: TextStyle(fontSize: 15, height: 1.35),
            ),
          ),
          const SizedBox(height: 18),
          if (items.isEmpty)
            const Text('Giỏ hàng chưa có sản phẩm.')
          else
            ...items.map(_ProductLine.new),
        ],
      ),
    );
  }
}

class _ProductLine extends StatelessWidget {
  final OrderConfirmationItem item;

  const _ProductLine(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 84,
              height: 84,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: Color(0xFFE8D2B8),
                  child: Icon(Icons.local_cafe, color: _brandColor),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                if (item.option.isNotEmpty)
                  Text(
                    '• ${item.option}',
                    style: const TextStyle(fontSize: 15, height: 1.35),
                  ),
                const SizedBox(height: 5),
                Text(
                  '${_formatMoney(item.unitPrice)}đ',
                  style: const TextStyle(
                    color: _brandColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.edit_outlined, color: _brandColor, size: 27),
              const SizedBox(height: 38),
              Text(
                'x${item.quantity}',
                style: const TextStyle(
                  color: _brandColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromotionSection extends StatelessWidget {
  const _PromotionSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: _SectionHeader(title: 'Khuyến mãi', action: 'Chọn'),
    );
  }
}

class _PaymentSection extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const _PaymentSection({
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const methods = [
      ('MoMo', Icons.account_balance_wallet, Color(0xFFA50064)),
      ('Ví VNPay', Icons.wallet, Color(0xFF1674BC)),
      ('Thẻ ATM và Tài khoản ngân hàng', Icons.account_balance, _brandColor),
      ('Thẻ thanh toán quốc tế', Icons.credit_card, _brandColor),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          ...methods.map((method) {
            final selected = method.$1 == selectedMethod;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onChanged(method.$1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFF0DFCF) : Colors.white,
                    border: Border.all(color: const Color(0xFFEDE7DF)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(method.$2, color: method.$3, size: 29),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          method.$1,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: selected ? _brandColor : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: _brandColor),
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 19,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  final int itemCount;
  final int subtotal;
  final int deliveryFee;
  final int total;

  const _PaymentSummary({
    required this.itemCount,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thanh toán ($itemCount món)',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _PriceRow(label: 'Thành tiền', value: subtotal),
          const SizedBox(height: 10),
          _PriceRow(label: 'Phí giao hàng dự tính', value: deliveryFee),
          const Divider(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Số tiền thanh toán',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatMoney(total)}đ',
                    style: const TextStyle(
                      color: _brandColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text('Đã bao gồm thuế', style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            decoration: InputDecoration(
              hintText: 'Ghi chú cho cửa hàng',
              hintStyle: const TextStyle(color: Colors.black38, fontSize: 17),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFE8D7C4)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: _brandColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 17))),
        Text('${_formatMoney(value)}đ', style: const TextStyle(fontSize: 17)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;

  const _SectionHeader({required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: _brandColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Icon(Icons.chevron_right, color: _brandColor),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 7, child: ColoredBox(color: _dividerColor));
  }
}

String _formatMoney(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[index]);
  }
  return buffer.toString();
}
