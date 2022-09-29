import 'package:flutter/material.dart';
import 'dart:async';

import './utils_first/context_extension.dart';
import './widgets/dismissible_background_widget.dart';
import './widgets/my_box_widget.dart';
import './constants/constants.dart';
import './models/content_first_object.dart';
import './utils_first/database_helper.dart';
import './utils_first/database_services.dart';
import './widgets/content_item_widget.dart';
import './widgets/icon_button_widget.dart';
import './widgets/text_button_widget.dart';
import './edit_first_page.dart';
import './store_first_page.dart';
import './utils_third/assets_constants.dart';
import './utils_third/color_constants.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  late Size _size;
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _aidList = [];

  Timer? _debounce;

  Future<bool> _getSearchList(String searchText) async {
    final data = await dbHelper.getSearchList(searchText);
    if (data.isNotEmpty) {
      setState(() {
        _aidList = data;
        isSearch = true;
      });
      return true;
    }
    return false;
  }

  void _getList() async {
    final data = await dbHelper.queryAllRows(tableContent);
    setState(() {
      _aidList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: false,
        title: TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          onChanged: (v) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 1000), () {
              _getSearchList(searchController.text).then((value) {
                if (!value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not Found!')),
                  );
                }
              });
              setState(() {
                isSearch = true;
              });
            });
          },
          onSubmitted: (str) {
            if (str.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Type something to search')),
              );
              return;
            } else {
              _getSearchList(searchController.text).then((value) {
                if (!value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not Found!')),
                  );
                }
              });
            }
          },
          decoration: InputDecoration(
            suffixIcon: InkWell(
                onTap: () {
                  if (searchController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Type something to search')),
                    );
                    return;
                  }
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            hintText: 'Search',
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          ),
        ),
        actions: [
          TweenAnimationBuilder<Offset>(
            duration: const Duration(seconds: 2),
            tween: Tween<Offset>(
              begin: const Offset(0, -800),
              end: const Offset(0, 0),
            ),
            curve: Curves.bounceOut,
            builder: (context, Offset offset, child) {
              return Transform.translate(
                offset: offset,
                child: child,
              );
            },
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddNewFeedPage(),
                  ),
                );
              },
              backgroundColor: AppColors.white,
              child: Icon(
                Icons.add,
                color: AppColors.codGray,
                size: _size.width * 0.08,
              ),
            ),
          ),
        ],
      ),
      body: _aidList.isNotEmpty || isSearch
          ? SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _aidList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: DismissibleBackgroundWidget(alignment: Alignment.centerRight, icon: Icons.edit, backgroundColor: Theme.of(context).primaryColor),
                    secondaryBackground: DismissibleBackgroundWidget(
                      alignment: Alignment.centerLeft,
                      icon: Icons.delete_outline_sharp,
                      backgroundColor: Colors.red,
                      iconColor: Colors.white,
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Are you sure you wish to edit this item?"),
                              actions: <Widget>[
                                TextBtnWidget(
                                  name: ' Edit ',
                                  isStretch: false,
                                  onTap: () {
                                    context.to(EditPostPage(ContentObject.fromMap(_aidList[index]))).then((value) {
                                      if (value != null) {
                                        if (value == true) {
                                          setState(() {});
                                          _getList();
                                        }
                                      }
                                      return context.back(false);
                                    });
                                  },
                                ),
                                TextBtnWidget(
                                  name: 'Cancel',
                                  btnColor: Colors.white,
                                  onTap: () => context.back(false),
                                  isStretch: false,
                                ),
                              ],
                            );
                          },
                        );
                      } else if (direction == DismissDirection.endToStart) {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Are you sure you wish to delete this item?"),
                              actions: <Widget>[
                                TextBtnWidget(
                                  name: 'Delete',
                                  nameColor: Colors.white,
                                  btnColor: Colors.red,
                                  onTap: () {
                                    DatabaseServices().deleteItem(_aidList[index]['id'], tableContent).then((value) {
                                      if (value != null) {
                                        context.back(true);
                                      }
                                    });
                                  },
                                  isStretch: false,
                                ),
                                TextBtnWidget(
                                  name: 'Cancel',
                                  btnColor: Colors.white,
                                  onTap: () => context.back(false),
                                  isStretch: false,
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return null;
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                      } else if (direction == DismissDirection.endToStart) {
                        _getList();
                      }
                    },
                    key: Key(_aidList[index]['id'].toString()),
                    child: ContentItemWidget(name: _aidList[index]['name'], body: _aidList[index]['body'], photo: _aidList[index]['photo']),
                  );
                }),
          ],
        ),
      )
          : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/no_data.png'),
              MyBoxWidget(
                height: 5,
              ),
              const Text('게시물이 없습니다.'),
            ],
          )),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

