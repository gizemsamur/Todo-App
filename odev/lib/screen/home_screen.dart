import 'package:flutter/material.dart';
import 'package:odev/helpers/drawer_navigation.dart';
import 'package:odev/models/todo.dart';
import 'package:odev/screen/todo_screen.dart';
import 'package:odev/services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  var _todo =Todo();
  var _todoService = TodoService();
  List<Todo> _todoList = List<Todo>.empty(growable: true);

  getAllTodos() async{
    var todos = await _todoService.readTodo();
    print(todos);
    todos.forEach((category) {
      setState(() {
        var todoModel = Todo();
        todoModel.name = category["name"];
        todoModel.description = category["description"];
        todoModel.todoDate = category["todoDate"];
        todoModel.category = category["category"];
        todoModel.id = category["id"];
        _todoList.add(todoModel);

      });
    });

  }
  @override
  void initState(){
    super.initState();
    getAllTodos();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("todo list"),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context,index){
            return Padding(padding: EdgeInsets.only(top:8.0,left:16.0,right:16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(

                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_todoList[index].name.toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_todoList[index].category.toString(),style: TextStyle(fontSize: 13),),
                            Text(_todoList[index].todoDate.toString(),style: TextStyle(fontSize: 15),),
                          ],
                        ),
                      ],
                    )
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {Navigator.of(context).push(MaterialPageRoute(builder: (contex)=>TodoScreen()));},
        child: Icon(Icons.add),
      ),
    );
  }
}

