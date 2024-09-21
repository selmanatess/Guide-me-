import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:guide_me/controller/user.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final UserController userController = Get.find<UserController>();
  final TextEditingController searchController = TextEditingController();
  bool isOpenned = false;
  List<Map<String, dynamic>> filteredList = [];
  @override
  void initState() {
    filteredList = [];
    Update();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void Update() async {
    await userController.fetchData();
    filterList("");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromARGB(200, 30, 129, 176),
          title: Text(
            'Kullanıcılar',
            style: GoogleFonts.inter(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: searchController,
                  onChanged: ((value) {
                    filterList(value);
                  }),
                  decoration: InputDecoration(
                    //shadow
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(200, 30, 129, 176),
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Ara',
                    suffixIcon: IconButton(
                        onPressed: () => {print(userController.dataList)},
                        icon: const Icon(Icons.search)),
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: SizedBox(
                      width: double.infinity,
                      height: 80.h,
                      child: Obx(
                        () {
                          if (userController.dataList.isEmpty) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return ExpansionTile(
                                  title: Text(
                                    filteredList[index]['name'] ?? 'No data',
                                    style: GoogleFonts.inter(fontSize: 20),
                                  ),
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                              maxWidth:
                                                  210.0, // Max width ayarı
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              230,
                                                              228,
                                                              228),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Email:  ${filteredList[index]['email']}',
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              230,
                                                              228,
                                                              228),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Telefon Numarası:  ${filteredList[index]['phone']}',
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              230,
                                                              228,
                                                              228),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Rolü:  ${filteredList[index]['role']}',
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              230,
                                                              228,
                                                              228),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Oluşturma Tarihi: ${convertDate(filteredList[index]['created_at'])}',
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Column(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: const Color.fromARGB(
                                                      255, 230, 228, 228),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Aktif Abonelik: ${filteredList[index]['subscribe']}',
                                                    style: GoogleFonts.inter(
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showRadioDialogSubscribe(
                                                    context,
                                                    filteredList[index]
                                                        ['subscribe'],
                                                    filteredList[index]['uid']);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 2),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  fixedSize:
                                                      const Size(140, 25),
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 241, 147, 253)),
                                              child: Text(
                                                maxLines:
                                                    1, // Metni tek satırda tutar
                                                overflow: TextOverflow
                                                    .ellipsis, // Metin sığmazsa sonuna üç nokta ekler
                                                softWrap: false,
                                                'Abonelik Değiştir',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showRadioDialogRole(
                                                    context,
                                                    filteredList[index]['role'],
                                                    filteredList[index]['uid']);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 2),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fixedSize:
                                                      const Size(100, 30),
                                                  backgroundColor: Colors.cyan),
                                              child: Text(
                                                maxLines:
                                                    1, // Metni tek satırda tutar
                                                overflow: TextOverflow
                                                    .ellipsis, // Metin sığmazsa sonuna üç nokta ekler
                                                softWrap: false,
                                                'Role Değiştir',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Kullanıcıyı Sil'),
                                                        content: const Text(
                                                            'Kullanıcıyı silmek istediğinize emin misiniz?'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'İptal')),
                                                          TextButton(
                                                              onPressed: () {
                                                                userController.deleteAccount(
                                                                    userController
                                                                            .dataList[index]
                                                                        [
                                                                        'uid']);
                                                                Update();

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Sil'))
                                                        ],
                                                      );
                                                    });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(100, 30),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  backgroundColor: Colors.red),
                                              child: Text(
                                                maxLines:
                                                    1, // Metni tek satırda tutar
                                                overflow: TextOverflow
                                                    .ellipsis, // Metin sığmazsa sonuna üç nokta ekler
                                                softWrap: false,
                                                'Sil',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ])

                                          // Row(s
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceEvenly,
                                          //   children: [
                                          //     ElevatedButton(
                                          //       onPressed: () {
                                          //         userController.deleteUser(
                                          //             userController.dataList[index]
                                          //                 ['id']);
                                          //       },
                                          //       child: Text('Sil'),
                                          //       style: ElevatedButton.styleFrom(
                                          //         backgroundColor: Colors.red,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (value) {
                                    setState(() {
                                      isOpenned = value;
                                    });
                                  },
                                );
                              },
                            );
                          }
                        },
                      ))

                  // Your code here

                  )
            ],
          ),
        ),
      ),
    );
  }

  String convertDate(Timestamp date) {
    DateTime dateTime = date.toDate();
    String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  void filterList(String query) {
    if (query.isEmpty) {
      filteredList = List.from(userController
          .dataList); // Eğer arama metni boşsa orijinal listeyi göster
    } else {
      filteredList = userController.dataList
          .where((item) {
            String name = item['name'].toString().toLowerCase();
            return name.contains(query.toLowerCase());
          })
          .toList()
          .cast<Map<String, dynamic>>();
    }
    // SetState çağırarak UI'yi güncelleyin (StatefulWidget kullanıyorsanız)
    setState(() {});
  }

  void showRadioDialogSubscribe(BuildContext context, String item, String uid) {
    int selectedValue = 1;

    switch (item) {
      case 'free':
        selectedValue = 1;
        break;
      case 'Plan 1':
        selectedValue = 2;
        break;
      case 'Plan 2':
        selectedValue = 3;
        break;
      default:
        selectedValue = 1;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Radio Button için bir değişken

            return AlertDialog(
              title: const Text('Abonelik Değiştirin'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                    title: const Text('Free'),
                    value: 1,
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Plan 1'),
                    value: 2,
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Plan 2'),
                    value: 3,
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    userController.changeSubscribe(
                        uid,
                        selectedValue == 1
                            ? 'free'
                            : selectedValue == 2
                                ? 'Plan 1'
                                : 'plan 2');
                    Update();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showRadioDialogRole(BuildContext context, String item, String uid) {
    // Dialog açıldığında bir kere initial değer ayarlıyoruz
    int selectedValue = item == 'admin' ? 1 : 2;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Role Değiştirin'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                    title: const Text('Admin'),
                    value: 1,
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('User'),
                    value: 2,
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    // Seçili değeri kullanarak işlemler yapabilirsiniz
                    userController.changeRole(
                        uid, selectedValue == 1 ? 'admin' : 'user');
                    Update();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
