import 'package:flutter/material.dart';
import 'package:gigjob_mobile/DTO/WalletDTO.dart';
import 'package:gigjob_mobile/viewmodel/user_viewmodel.dart';
import 'package:scoped_model/scoped_model.dart';

import '../enum/view_status.dart';

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
    userViewModel = UserViewModel();
    userViewModel.getWallet();
  }

  UserViewModel userViewModel = UserViewModel();

  // double accBalance = 500;
  // String userName = "Chau Tan Tai";

  Color cashColor = Colors.green;

  List<WalletDTO> history = [
    WalletDTO("FPT", "Payment", null, null, null),
    WalletDTO("HPT", "Payment", null, null, null),
    WalletDTO("NET", "Payment", null, null, null),
    WalletDTO("Google", "Payment", null, null, null),
    WalletDTO("Microsofr", "Payment", null, null, null),
    WalletDTO("FPT", "Payment", null, null, null),
    WalletDTO("HPT", "Payment", null, null, null),
    WalletDTO("NET", "Payment", null, null, null),
    WalletDTO("Google", "Payment", null, null, null),
    WalletDTO("Microsofr", "Payment", null, null, null),
  ];

  // void showAlert(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => const AlertDialog(
  //             content: Text(
  //               "This function is not available now",
  //               textAlign: TextAlign.center,
  //             ),
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () => showAlert(context));
    return ScopedModel<UserViewModel>(
        model: userViewModel,
        child: ScopedModelDescendant<UserViewModel>(
          builder: (context, child, model) {
            if (userViewModel.status == ViewStatus.Loading) {
              return const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              );
            } else if (userViewModel.status == ViewStatus.Completed) {
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
                      cashRender(userViewModel.walletdto?.balance),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 20),
                        // ignore: prefer_const_literals_to_create_immutables
                        child: const Text(
                          'History',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
            return Container();
          },
        ));
  }

  Widget cashRender(double? cash) {
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
            "\$ $cash",
            style: TextStyle(color: cashColor, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
