import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:odev/models/todo.dart';
import 'package:odev/models/category.dart';
import 'package:odev/screen/home_screen.dart';
import 'package:odev/services/category_service.dart';
import 'package:odev/services/todo_service.dart';
import 'package:odev/src/app.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var todo;
  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();

  var category;
  var _selectedValue;
  DateTime selectedDate = DateTime.now();

  var _todo =Todo();
  var _todoService = TodoService();
  var _categoryService = CategoryService();
  List<DropdownMenuItem<Category>> _categories = [];
  @override
  void initState(){
    super.initState();
    getAllCategories();
  }
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }
  getAllCategories() async{
    var categories = await _categoryService.readCategories();
    print(categories);
    categories.forEach((category) {
      var categoryModel = Category();
      setState(() {
        categoryModel.name = category["name"];
        categoryModel.description = category["description"];
        categoryModel.id = category["id"];
        //_categories.add(categoryModel.categoryMapp());
      });

      _categories.add(DropdownMenuItem(
        value: categoryModel,
        child: Text(
          categoryModel.name.toString(),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ));
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Todo"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: todoTitleController,
              decoration: InputDecoration(
                  labelText: "title",
                  hintText: "write todo title"
              ),
            ),
            TextField(
              controller: todoDescriptionController,
              decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "write todo description"
              ),
            ),
            TextField(
              controller: todoDateController,
              onTap: (){
                _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: selectedDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    // This is called when the user changes the date.
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        selectedDate = newDate;
                        todoDateController.text = "${newDate.day}-${newDate.month}-${newDate.year}";
                      });
                    },
                  ),
                );
              },
              decoration: InputDecoration(
                  labelText: "Date",
                  hintText: "Pick a date",
                  prefixIcon: InkWell(
                    //ödevde dolucak
                    onTap: (){
                      _showDialog(
                        CupertinoDatePicker(
                          initialDateTime: selectedDate,
                          mode: CupertinoDatePickerMode.date,
                          use24hFormat: true,
                          // This is called when the user changes the date.
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              selectedDate = newDate;
                              todoDateController.text = "${newDate.day}-${newDate.month}-${newDate.year}";
                            });
                          },
                        ),
                      );
                    },
                    child: Icon(Icons.calendar_today),
                  )
              ),
            ),
            DropdownButtonFormField<Category>(
              //items: _categories,
                isExpanded: true,
                items: _categories,
                value: _selectedValue,
                onChanged: (value){
                  setState(() {
                    _selectedValue = value;
                  });
                }),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: /*işlemle dolucak*/() async{
                setState(() {
                  _todo.name = todoTitleController.text;
                  _todo.description = todoDescriptionController.text;
                  _todo.category = _selectedValue.name.toString();
                  _todo.todoDate = todoDateController.text;
                });

                if(
                todoTitleController.text!=null && todoTitleController.text!=""
                    && todoDescriptionController.text!=null && todoDescriptionController.text!=""
                    && todoDateController.text!=null && todoDateController.text!=""

                ){
                  var result = await _todoService.saveTodo(_todo);
                  if (result>0){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        HomeScreen()),(Route<dynamic> route) => false);
                  }
                }else{
                  _showDialog(
                      Container(
                        child: Text("fill in the blanks",style: TextStyle(color: Colors.black,fontSize: 15),),
                      )
                  );
                }
                //print(result);

              },
              color: Colors.blue,
              child: Text("Save",style: TextStyle(color:Colors.white)),)
          ],
        ),
      ),
    );
  }
}

