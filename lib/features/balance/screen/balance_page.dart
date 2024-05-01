import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class BalancePage extends ConsumerStatefulWidget {
  const BalancePage({super.key});

  @override
  ConsumerState createState() => _BalancePageState();
}

class _BalancePageState extends ConsumerState<BalancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true  ,
        title: Text("Balance Page"),
      ),
    );
  }
}
