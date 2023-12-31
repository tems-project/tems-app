import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listbook/translation.dart';
import 'package:listbook/utils/colors.dart';
import 'package:local_auth/local_auth.dart';

class NewTemplateDialog extends StatefulWidget {
  final Future<void> Function(String name, bool isSecurityFolder) onSuccess;

  const NewTemplateDialog({super.key, required this.onSuccess});

  @override
  State<NewTemplateDialog> createState() => _NewTemplateDialogState();
}

class _NewTemplateDialogState extends State<NewTemplateDialog> {
  final TextEditingController _controller = TextEditingController();
  String _bucketName = "";
  bool _isSecurity = false;

  final localAuth = LocalAuthentication();

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        _bucketName = _controller.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 22, right: 22, top: 30, bottom: 18),
          width: deviceWidth - 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Translations.of(context)?.trans("template_name") ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      color: CustomColors.grey3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 53,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: CustomColors.lightGrey,
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Translations.of(context)?.trans("e_g_camping"),
                    hintStyle: TextStyle(
                      fontSize: 17,
                      color: CustomColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 23,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      Translations.of(context)?.trans("security") ?? "",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    CupertinoSwitch(
                      value: _isSecurity,
                      onChanged: (value) async {
                        if (value) {
                          print(await localAuth.canCheckBiometrics);
                          if (!await localAuth.canCheckBiometrics) {
                            showOkAlertDialog(
                              context: context,
                              title: "Auth faild",
                              message: "Not available biometric authentication",
                            );
                            return;
                          }

                          final authentication = await localAuth.authenticate(
                            localizedReason: "Please authenticate to show account balance",
                          );

                          print(authentication);

                          if (authentication) {
                            setState(() {
                              _isSecurity = authentication;
                            });
                          }

                          return;
                        }
                        setState(() {
                          _isSecurity = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(30),
                      color: CustomColors.lightGrey,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            Translations.of(context)?.trans("cancel") ?? "",
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.darkGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  _bucketName == ""
                      ? Expanded(
                          child: Container(
                            height: 53,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: CustomColors.grey,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              Translations.of(context)?.trans("lets_make_it") ?? "",
                              style: TextStyle(
                                fontSize: 17,
                                color: CustomColors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            color: CustomColors.darkGrey,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () async {
                                await widget
                                    .onSuccess(_controller.text, _isSecurity)
                                    .then((value) => Navigator.pop(context));
                              },
                              child: Container(
                                height: 53,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  Translations.of(context)?.trans("lets_make_it") ?? "",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: CustomColors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
