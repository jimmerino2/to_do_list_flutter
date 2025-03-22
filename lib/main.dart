import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Base App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 154, 106, 233),
        ),
      ),
      home: const MyHomePage(title: 'To Do List App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.star),
                label: Text("Completed"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.pending),
                label: Text("Pending"),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: TaskList(filter: selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}

// #region Task List
class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.filter});
  final int filter;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Map<String, dynamic>> tasks = [
    {"title": "Finish project", "icon": Icons.work, "isComplete": false},
    {"title": "Go jogging", "icon": Icons.directions_run, "isComplete": false},
    {"title": "Go gym", "icon": Icons.sports_gymnastics, "isComplete": false},
  ];

  List<Map<String, dynamic>> getFilteredTasks() {
    if (widget.filter == 0) {
      return tasks.where((task) => task["isComplete"] == true).toList();
    } else {
      return tasks.where((task) => task["isComplete"] == false).toList();
    }
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      getFilteredTasks()[index]["isComplete"] =
          !getFilteredTasks()[index]["isComplete"];
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  final TextEditingController _controller = TextEditingController();
  void insertTask(String title) {
    setState(() {
      tasks.add({
        "title": title,
        "icon": Icons.sticky_note_2,
        "isComplete": false,
      });
    });
  }

  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Add Item"),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    () => {
                      insertTask(_controller.text),
                      Navigator.pop(context),
                    },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getFilteredTasks().isEmpty
            ? Center(child: Text("No tasks available"))
            : ListView.builder(
              itemCount: getFilteredTasks().length,
              itemBuilder: (context, index) {
                var item = getFilteredTasks()[index];
                return ListTile(
                  leading: Icon(item["icon"]),
                  title: Text(item["title"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Checkbox
                      IconButton(
                        icon: Icon(
                          item["isComplete"]
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                        onPressed: () => toggleTaskCompletion(index),
                      ),
                      // Delete
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),

        // Floating Button (Example)
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              showMyDialog(context);
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

// #endregion
