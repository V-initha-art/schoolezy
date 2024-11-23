import 'package:admin/adminrepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolezy/utility/sizeconfig.dart';

class WebPaymentGatewayPage extends StatefulWidget {
  const WebPaymentGatewayPage({super.key});

  @override
  State<WebPaymentGatewayPage> createState() => _WebPaymentGatewayPageState();
}

class _WebPaymentGatewayPageState extends State<WebPaymentGatewayPage> {
  List<PaymentGateway> payments = List.empty(growable: true);

  // void sampleDataPayment() {
  //   payments = const [
  //     PaymentGateway(
  //       active: 'yes',
  //       payment_logo: 'JFLVHH90786664',
  //       payment_name: 'Razor Pay',
  //     ),
  //     PaymentGateway(
  //       active: 'no',
  //       payment_logo: 'ADWDGVVXS57B2',
  //       payment_name: 'Stripe Pay',
  //     )
  //   ];
  // }

  // @override
  // void initState() {
  //   sampleDataPayment();
  //   super.initState();
  // }
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Container(
                      // color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30, left: 30),
                        child: Row(
                          children: [
                            Text(
                              'Payment',
                              style: Theme.of(context).textTheme.labelLarge!.merge(TextStyle(fontWeight: FontWeight.w800)),
                            ),
                            Spacer(),
                            TabBarButton(
                              title: 'Card',
                              index: 0,
                              selectedIndex: _selectedIndex,
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 0;
                                });
                              },
                            ),
                            TabBarButton(
                              title: 'Apple Pay',
                              index: 1,
                              selectedIndex: _selectedIndex,
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                            ),
                            TabBarButton(
                              title: 'Upi',
                              index: 2,
                              selectedIndex: _selectedIndex,
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: _buildSelectedTabContent(),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(),
              // Expanded(
              //     flex: 2,
              //     child: Padding(
              //       padding: const EdgeInsets.only(top: 30, left: 20),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Order Summary',
              //             style: Theme.of(context).textTheme.displaySmall,
              //           ),
              //           Flexible(
              //             child: Padding(
              //               padding: const EdgeInsets.only(bottom: 20),
              //               child: Card(
              //                 child: Container(
              //                   width: 400,
              //                   child: Column(
              //                     children: [
              //                       Padding(
              //                         padding: const EdgeInsets.only(top: 30),
              //                         child: Text(
              //                           'First Term Fees',
              //                           style: Theme.of(context).textTheme.titleLarge!.merge(
              //                                 TextStyle(decoration: TextDecoration.underline),
              //                               ),
              //                         ),
              //                       ),
              //                       Padding(
              //                         padding: const EdgeInsets.only(top: 20),
              //                         child: Row(
              //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                           children: [
              //                             Text('Tution Fees'),
              //                             Text('1770'),
              //                           ],
              //                         ),
              //                       ),
              //                       Padding(
              //                         padding: const EdgeInsets.only(top: 20),
              //                         child: Row(
              //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                           children: [
              //                             Text('Book Fees'),
              //                             Text('3340'),
              //                           ],
              //                         ),
              //                       ),
              //                       Padding(
              //                         padding: const EdgeInsets.only(top: 20),
              //                         child: Row(
              //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                           children: [
              //                             Text('Special Class Fees'),
              //                             Text('6770'),
              //                           ],
              //                         ),
              //                       ),
              //                       Padding(
              //                         padding: const EdgeInsets.only(top: 20),
              //                         child: Row(
              //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                           children: [
              //                             Text('Library Fees'),
              //                             Text('340'),
              //                           ],
              //                         ),
              //                       )
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     ))
            ],
          ),
        ),
      ),
    );
    // Scaffold(
    //   body: Center(
    //     child: SizedBox(
    //       width: SizeConfig.blockSizeHorizontal! * 60,
    //       child: Card(
    //         shape: const RoundedRectangleBorder(),
    //         margin: noPadding,
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: mediumPadding,
    //               child: Align(
    //                 alignment: Alignment.centerRight,
    //                 child: ElevatedButton(
    //                   child: const Text('Add payment method'),
    //                   onPressed: () {},
    //                 ),
    //               ),
    //             ),
    //             Expanded(
    //               child: ListView.separated(
    //                   separatorBuilder: (context, index) => const Divider(),
    //                   itemBuilder: (context, index) {
    //                     return ListTile(
    //                       title: Text(payments.elementAt(index).payment_name!),
    //                       trailing: SizedBox(
    //                         width: SizeConfig.blockSizeHorizontal! * 12,
    //                         child: Flexible(
    //                           child: Row(
    //                             children: [
    //                               IconButton(
    //                                   onPressed: () {},
    //                                   icon: const Icon(
    //                                     Icons.visibility,
    //                                   ),),
    //                               IconButton(
    //                                 onPressed: () {},
    //                                 icon: const Icon(
    //                                   Icons.delete_forever_rounded,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                       subtitle: Row(
    //                         children: [
    //                           const Text('Active: '),
    //                           Text(payments.elementAt(index).active!),
    //                         ],
    //                       ),
    //                     );
    //                   },
    //                   itemCount: payments.length,),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedIndex) {
      case 0:
        return CardPayment();
      case 1:
        return ApplePay();
      case 2:
        return GooglePayUpi();
      default:
        return Center(
          child: Text('Invalid Tab Index'),
        );
    }
  }
}

class TabBarButton extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final Function onTap;

  TabBarButton({
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 80,
          height: 52,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: index == selectedIndex ? Colors.black.withOpacity(0.8) : Colors.black.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          //] color: index == selectedIndex ? Colors.white : Colors.blue,
          child: Padding(padding: const EdgeInsets.all(8.0), child: Text(title)),
        ),
      ),
    );
  }
}

class CardPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Row(
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(filled: true, labelText: 'Card number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(filled: true, labelText: 'Valid Thiru', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Row(
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(filled: true, labelText: 'Card Holder', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(filled: true, labelText: 'CVC/CVV', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Row(
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(filled: true, labelText: 'Card Holder', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Spacer(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Row(
            children: [
              Checkbox(
                value: false,
                onChanged: (value) {},
              ),
              Text('Save my card for faster payment in the future'),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 30,
          ),
          child: Column(
            children: [
              Text('By clicking the button you confirm\nto have accepted Terms of Service'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 30, bottom: 30),
          child: SizedBox(
            height: 50,
            width: 200,
            child: OutlinedButton(style: OutlinedButton.styleFrom(shape: BeveledRectangleBorder()), onPressed: () {}, child: Text('Pay  ₹156')),
          ),
        )
      ],
    );
  }
}

class ApplePay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class GooglePayUpi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
