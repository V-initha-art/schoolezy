import 'package:flutter/material.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/sizeconfig.dart';

class WebSchoolAccountPage extends StatelessWidget {
  WebSchoolAccountPage({super.key});

  Map<String, String> banks = {'ICICI BANK': '808HJHKXXXX6876', 'FEDERAL BANK': 'HJKV78786BXXX89'};

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add Bank'),
      ),
      body: Center(
        child: SizedBox(
          width: SizeConfig.blockSizeHorizontal! * 60,
          child: ListView(
            children: banks.entries
                .map(
                  (e) => Card(
                    shape: const RoundedRectangleBorder(),
                    margin: noPadding,
                    child: ListTile(
                      title: Text(e.key),
                      subtitle: Text(e.value),
                      trailing: SizedBox(
                        width: SizeConfig.blockSizeHorizontal! * 10,
                        child: const Row(
                          children: [
                            Icon(Icons.visibility),
                            Icon(Icons.delete_forever_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
