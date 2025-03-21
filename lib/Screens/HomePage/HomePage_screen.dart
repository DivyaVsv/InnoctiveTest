import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoctive_test/Model/ImageData_model.dart';
import 'package:innoctive_test/Screens/HomePage/HomePage_cubit.dart';
import 'package:innoctive_test/Screens/HomePage/HomePage_state.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePageScreen extends StatefulWidget {
  _HomePageScreen createState() => _HomePageScreen();
}

class _HomePageScreen extends State<HomePageScreen> {
  final ScrollController _scrollcontroller = ScrollController();
  var page = 0;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final cubit = context.read<HomePageCubit>();
    cubit.fetchData(page);

    _scrollcontroller.addListener(onScroll);
  }

  onScroll() {
    if (_scrollcontroller.position.pixels >=
        _scrollcontroller.position.maxScrollExtent - 200) {
      setState(() {
        //page++;
        context.read<HomePageCubit>().fetchData(page);
      }); // Load next page
    }
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) => HomePageCubit()..fetchData(page),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(tabs: [
                Tab(text: "All"),
                Tab(text: "Following"),
                Tab(text: "Makeup"),
                Tab(text: "Dior")
              ]),
              title: Row(
                children: [
                  Icon(
                    Icons.supervised_user_circle,
                    size: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Tamara Kingston",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Makeup Artist",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade500),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.grey.shade500,
                    size: 30,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                    size: 30,
                  ),
                  Icon(
                    Icons.chat,
                    color: Colors.grey.shade500,
                    size: 30,
                  ),
                  Icon(
                    Icons.notifications,
                    color: Colors.grey.shade500,
                    size: 30,
                  ),
                  Icon(
                    Icons.phone,
                    color: Colors.grey.shade500,
                    size: 30,
                  )
                ],
              ),
            ),
            body: BlocBuilder<HomePageCubit, HomePage_state>(
                builder: (context, state) {
              List<ImageData_model> data = [];
              if (state is HomePageLoading) {
                return CircularProgressIndicator();
              } else if (state is HomePageLoaded) {
                data = state.data;
              } else if (state is HomePageError) {
                return Text(" No Data Found");
              }
              return Column(
                children: [
                  Expanded(
                      child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (_scrollcontroller.position.pixels >=
                          _scrollcontroller.position.maxScrollExtent - 200) {
                        setState(() {
                          page++;
                          context.read<HomePageCubit>().fetchData(page);
                        });
                      }
                      return true;
                    },
                    child: MasonryGridView.builder(
                        controller: _scrollcontroller,
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    "${data[index].url}",
                                    fit: BoxFit.cover,
                                    //height: 100,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.supervised_user_circle_outlined,
                                      size: 40,
                                    ),
                                    Text(
                                      "${data[index].id}",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  )),
                  if (state is HomePageLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            })),
      ),
    );
  }
}
