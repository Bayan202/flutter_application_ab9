import 'package:flutter/material.dart';
import 'package:flutter_application_ab9/bloc/new_bloc.dart';
import 'package:flutter_application_ab9/bloc/new_event.dart';
import 'package:flutter_application_ab9/bloc/new_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Improved Bottom Navigation Bar with API Data',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DataFromAPI(), // 'Дом' is now the API data page
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset('assets/Animation.json',
              width: 150, height: 150, fit: BoxFit.fill),
          SizedBox(height: 20),
          Lottie.asset('assets/Animation2.json',
              width: 150, height: 150, fit: BoxFit.fill),
        ],
      ),
    ),

    Center(child: Text('Аккаунт', style: TextStyle(fontSize: 24))),
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Improved Design with API Data'),
        elevation: 8.0,
      ),
      body: PageView(
        controller: _pageController,
        children: _children,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.teal[300],
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Дом',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work, size: 28),
            label: 'Работа',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 28),
            label: 'Аккаунт',
          ),
        ],
      ),
    );
  }
}

class DataFromAPI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc()..add(FetchPostEvent()),
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.posts[index].title),
                  subtitle: Text(state.posts[index].body),
                );
              },
            );
          } else if (state is PostError) {
            return Center(child: Text('Ошибка загрузки данных.'));
          } else {
            return Center(child: Text('Начальное состояние.'));
          }
        },
      ),
    );
  }
}
