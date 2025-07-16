import 'package:flutter/material.dart';

enum UIMessageType {
  success,
  error,
  warning,
  info,
}

class UIMessage {
  final String message;
  final UIMessageType type;
  final String? actionLabel;
  final VoidCallback? onAction;

  UIMessage({
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
  });
}

class OrderResult {
  final String customerName;
  final double total;
  final double discount;
  final int itemCount;

  OrderResult({
    required this.customerName,
    required this.total,
    required this.discount,
    required this.itemCount,
  });
}
