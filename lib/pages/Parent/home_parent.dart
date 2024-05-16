import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jadwali_test_1/auth/auth_service.dart';
import 'package:jadwali_test_1/pages/Parent/add_child.dart';
import 'package:jadwali_test_1/pages/Parent/child_schedule.dart';
import 'package:jadwali_test_1/pages/Common/pre_login.dart';
import 'package:jadwali_test_1/providers/child_provider.dart';
import 'package:provider/provider.dart';

class HomeParent extends StatefulWidget {
  static const String routeName = '/';
  const HomeParent({super.key});

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  // List<Child> children = [];
  //calling getting all children function to use in this page and any page down the tree
  @override
  void didChangeDependencies() {
    // Provider.of<childProvider>(context, listen: false).getAllChildren();
    Provider.of<childProvider>(context, listen: false).getAllChildrenwithP();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.dehaze_rounded,
              ),
            ),
            title: const Text(
              ' قائمة الأطفال',
              textAlign: TextAlign.right,
            ),
            backgroundColor: const Color.fromRGBO(255, 249, 227, 100),
            actions: [
              IconButton(
                onPressed: () {
                  AuthService.logout().then((value) => context.goNamed(PreLogin
                      .routeName)); // .then: ino sho ye3mal after logout
                },
                icon: const Icon(Icons.logout),
              )
            ]),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Consumer<childProvider>(
                    builder: (context, provider, child) =>
                        // provider.childList.isEmpty
                        //     ? const Center(
                        //         child: Text("لا يوجد أطفال"),
                        //       )
                        //     :
                        ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: provider.childList.length,
                      itemBuilder: (context, index) {
                        final child = provider.childList[index];
                        return Card(
                          elevation: 3, // Add elevation for a shadow effect
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChildSchedulePage(childInfo: child),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    15), // Adjust the border radius as needed
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1), // Add thin black border
                                color: Colors
                                    .white, // Set background color to white
                              ),
                              height: 100, // Increase the height as needed
                              padding: const EdgeInsets.all(
                                  10), // Add padding to the container
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius:
                                        40, // Adjust the radius of the profile icon
                                    // Add your profile image here, you can use backgroundImage or child with Icon or Image
                                    backgroundImage:
                                        AssetImage('assets/images/logo.png'),
                                    // child: Icon(Icons.person, size: 30), // Sample profile icon
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Add some space between the profile icon and text
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child.name,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                5), // Add some vertical space between name and other details
                                        // Add more details if needed, like age, school, etc.
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Remove the item from the data source
                                      setState(() {
                                        //children.removeAt(index);
                                      });

                                      // Show a snackbar to indicate item deletion
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("تم الحذف"),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addChildPage(),
                        ),
                      );
                      // final newChild = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => addChild(),
                      //   ),
                      // );
                      // if (newChild != null) {
                      //   setState(() {
                      //     //DbHelper.addChilddb(newChild);
                      //     children.add(newChild);
                      //   });
                      // }
                    },
                    child: const Text("أضف طفل"),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Stack(
        //   children:[
        //     Container(
        //   decoration: const BoxDecoration(
        //     image:  DecorationImage(image:  AssetImage("assets/images/background.png"), fit: BoxFit.cover,),
        //   ),
        // ),
        //     Column(
        //     children: [
        //       Expanded(
        //         child: ListView.builder(
        //           padding: const EdgeInsets.all(16.0),
        //           itemCount: children.length,
        //           itemBuilder: (context, index) {
        //             return Card(
        //               elevation: 3, // Add elevation for a shadow effect
        //               child: ListTile(
        //                 title: Text(children[index].name),
        //                 trailing: IconButton(
        //                   icon: const Icon(Icons.delete),
        //                   onPressed: () {
        //                     // Remove the item from the data source
        //                     setState(() {
        //                       children.removeAt(index);
        //                     });

        //                     // Show a snackbar to indicate item deletion
        //                     ScaffoldMessenger.of(context).showSnackBar(
        //                       const SnackBar(
        //                         content: Text("Item deleted"),
        //                       ),
        //                     );
        //                   },
        //                 ),
        //                 onTap: () {
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (context) =>
        //                           ChildProfilePage(child: children[index]),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             );
        //           },
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(20),
        //         child: ElevatedButton(
        //           onPressed: () async {
        //             final newChild = await Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => addChild(),
        //               ),
        //             );
        //             if (newChild != null) {
        //               setState(() {
        //                 //DbHelper.addChilddb(newChild);
        //                 children.add(newChild);
        //               });
        //             }
        //           },
        //           child: const Text("أضف طفل"),
        //         ),
        //       ),
        //     ],
        //   ),
        // ]),
      ),
    );
  }
}

///////////////////////////////////////////////

// Center(
//   child: Column(
//     children: [
//       const Expanded(child: Text('Home parent test')),
//       Padding(
//         padding: const EdgeInsets.all(20),
//         child: ElevatedButton(
//           onPressed: () {
//             ///kjd
//           },
//           child: const Text("أضف طفل"),
//         ),
//       ),
//     ],
//   ),
// ),
//         );
//   }
// }

//////////////////////////
///
/*KeyedSubtree(
                    key: Key(children[index].name),
                    child: Dismissible(
                                  key: Key(children[index].name),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    // Remove the item from the data source
                                    setState(() {
                    children.removeAt(index);
                                    });
                    
                                    // Show a snackbar to indicate item deletion
                                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Item dismissed"),
                    ),
                                    );
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                                    ),
                                  ),
                    child: Card(
                    elevation: 3, // Add elevation for a shadow effect
                    child: ListTile(
                      title: Text(children[index].name),
                      onTap: () {
                        Navigator.push(
                                    context,
                                    MaterialPageRoute(
                    builder: (context) => ChildProfilePage(child: children[index]),
                                    ),
                                  );
                      },
                    ))),
                  );*/
