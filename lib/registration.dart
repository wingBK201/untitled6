import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/main.dart';

class Registration extends StatelessWidget {
  Registration({Key? key}) : super(key: key);
  String? mailAddress;
  String? password;
  String? passwordCheck;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新規登録'),
      ),
      body: Column(
        children: [
          CustomTextField(
            label: 'メールアドレス',
            onChangedfunc: (newText) {
              mailAddress = newText;
            },
            isPassword: false,
          ),
          CustomTextField(
            label: 'パスワード',
            onChangedfunc: (newText) {
              password = newText;
            },
            isPassword: true,
          ),
          CustomTextField(
            label: 'パスワード確認',
            onChangedfunc: (newText) {
              passwordCheck = newText;
            },
            isPassword: true,
          ),
          ElevatedButton(
              onPressed: () async {
                if (password != passwordCheck) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('ERROR'),
                          content: Text('パスワードを正しく入力してください'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK')),
                          ],
                        );
                      });
                } else if (password != null && passwordCheck != null) {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: mailAddress!, password: password!);
                    final user = userCredential.user!;
                    FirebaseFirestore.instance
                        .collection(user.uid)
                        .doc('0')
                        .set({'item': 'ToDoを始めよう', 'done': false});
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('登録完了'),
                            content: Text('登録しました。'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('パスワードが短すぎます');
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('ERROR'),
                              content: Text('パスワードが短すぎます'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'))
                              ],
                            );
                          });
                    } else if (e.code == 'email-already-in-use') {
                      print('入力されたメールアドレスはすでに登録されています。');
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('ERROR'),
                              content: Text('入力されたメールアドレスはすでに登録されています。'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'))
                              ],
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('ERROR'),
                              content: Text('$e'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'))
                              ],
                            );
                          });
                    }
                  } catch (e) {
                    print(e);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('ERROR'),
                            content: Text('$e'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('yokiしないエラー'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'))
                          ],
                        );
                      });
                }
              },
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  '新規登録',
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }
}
