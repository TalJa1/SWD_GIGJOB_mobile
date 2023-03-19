import 'package:flutter/material.dart';
import 'package:gigjob_mobile/DTO/WalletDTO.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
  }

  double accBalance = 500;
  String userName = "Chau Tan Tai";

  Color cashColor = Colors.green;

  List<WalletDTO> history = [
    WalletDTO("FPT", "Payment"),
    WalletDTO("HPT", "Payment"),
    WalletDTO("NET", "Payment"),
    WalletDTO("Google", "Payment"),
    WalletDTO("Microsofr", "Payment"),
    WalletDTO("FPT", "Payment"),
    WalletDTO("HPT", "Payment"),
    WalletDTO("NET", "Payment"),
    WalletDTO("Google", "Payment"),
    WalletDTO("Microsofr", "Payment"),
  ];

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: Text(
                "This function is not available now",
                textAlign: TextAlign.center,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showAlert(context));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 80,
        title: const Text(
          'Wallet',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            cashRender(accBalance),
            Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20),
              // ignore: prefer_const_literals_to_create_immutables
              child: const Text(
                'History',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final his = history[index];
                  // ignore: prefer_const_literals_to_create_immutables
                  return SingleChildScrollView(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.circle,
                          color: Colors.green,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(his.name.toString()),
                            Text(his.purpose.toString())
                          ],
                        ),
                        // subtitle: Text(his.purpose.toString()),
                      ),
                    ),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget cashRender(double cash) {
    if (cash == 0) {
      cashColor = Colors.grey;
    }
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: cashColor),
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Text(
            "\$ $accBalance",
            style: TextStyle(color: cashColor, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
