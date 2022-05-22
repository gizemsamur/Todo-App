import 'package:flutter/material.dart';
import 'package:odev/models/category.dart';
import 'package:odev/services/category_service.dart';

import 'home_screen.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var category;
  var _categoryNameController=TextEditingController();
  var _categoryDescriptionController=TextEditingController();
  var _editCategoryNameController=TextEditingController();
  var _editCategoryDescriptionController=TextEditingController();

  var _category =Category();
  var _categoryService = CategoryService();
  List<Category> _categoryList = List<Category>.empty(growable: true);
  @override
  void initState(){
    super.initState();
    getAllCategories();
  }
  getAllCategories() async{
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category["name"];
        categoryModel.description = category["description"];
        categoryModel.id = category["id"];
        _categoryList.add(categoryModel);

      });
    });

  }

  _editCategory(BuildContext context,categoryId) async{
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text= category[0]["name"] ?? "No name";
      _editCategoryNameController.text= category[0]["description"] ?? "No description";
    });
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context){
    return showDialog(context:context,
        barrierDismissible:true,
        builder:(param){
          return AlertDialog(
              actions: <Widget>[
                FlatButton(
                    color: Colors.red,
                    onPressed: ()=>Navigator.pop(context),
                    child: Text("Cancel")
                ),
                FlatButton(
                    color: Colors.blue,
                    onPressed: () async{
                      _category.name = _categoryNameController.text;
                      _category.description = _categoryDescriptionController.text;
                      var result = await _categoryService.saveCategory(_category);
                      //print(result);
                      if (result>0){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            CategoriesScreen()),(Route<dynamic> route) => false);
                      }
                    },
                    child: Text("save")
                )
              ],
              title: Text("categories form"),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          hintText: "write a category",
                          labelText: "category"
                      ),
                      controller: _categoryNameController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "write a description",
                          labelText: "description"
                      ),
                      controller: _categoryDescriptionController,
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  _editFormDialog(BuildContext context){
    return showDialog(context:context,
        barrierDismissible:true,
        builder:(param){
          return AlertDialog(
              actions: <Widget>[
                FlatButton(
                    color: Colors.red,
                    onPressed: ()=>Navigator.pop(context),
                    child: Text("Cancel")
                ),
                FlatButton(
                    color: Colors.blue,
                    onPressed: () async{
                      _category.id =category[0]["id"];
                      _category.name = _editCategoryNameController.text;
                      _category.description = _editCategoryDescriptionController.text;
                      var result = await _categoryService.updateCategory(_category);
                      //print(result);
                      if (result>0){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            CategoriesScreen()),(Route<dynamic> route) => false);
                      }
                    },
                    child: Text("Update")
                )
              ],
              title: Text("categories form"),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          hintText: "write a category",
                          labelText: "category"
                      ),
                      controller: _editCategoryNameController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "write a description",
                          labelText: "description"
                      ),
                      controller: _editCategoryDescriptionController,
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  _deleteFormDialog(BuildContext context,categoryId){
    return showDialog(context:context,
        barrierDismissible:true,
        builder:(param){
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  color: Colors.green,
                  onPressed: ()=>Navigator.pop(context),
                  child: Text("Cancel")
              ),
              FlatButton(
                  color: Colors.red,
                  onPressed: () async{
                    var result = await _categoryService.deleteCategory(categoryId);
                    //print(result);
                    if (result>0){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          CategoriesScreen()),(Route<dynamic> route) => false);
                    }
                  },
                  child: Text("Delete")
              )
            ],
            title: Text("Are you sure you want to delete this."),

          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: ()=>Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>HomeScreen()),
          ),
          elevation: 0.0,
          child: Icon(Icons.arrow_back,color: Colors.white,),
          color: Colors.blue,
        ),
        title: Text("Categories"),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context,index){
            return Padding(padding: EdgeInsets.only(top:8.0,left:16.0,right:16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  leading: IconButton(icon:Icon(Icons.edit),
                      onPressed: (){
                        _editCategory(context,_categoryList[index].id);
                      }),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_categoryList[index].name.toString()),
                      IconButton(onPressed: (){
                        _deleteFormDialog(context,_categoryList[index].id);

                      },icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),)
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
