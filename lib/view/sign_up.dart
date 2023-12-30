import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool isCheck;

  @override
  void initState() {
    super.initState();
    isCheck = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Sign up",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 56),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        children: const [Text("Name")],
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          counterText: '',
                          hintStyle: const TextStyle(
                              color: Colors.black, fontSize: 10.0)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        children: const [Text("Phone")],
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          counterText: '',
                          hintStyle: const TextStyle(
                              color: Colors.black, fontSize: 10.0)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: isCheck,
                            onChanged: (value) {
                              setState(() {
                                isCheck = !isCheck;
                              });
                            }),
                        const Expanded(
                          child: Text(
                              "I've read and agree with the Terms and Conditions and the Privacy Policy."),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _buildButtonApply()
                  ],
                ))
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonApply() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Text(
            'Sign up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
