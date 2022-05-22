
import 'package:flutter/material.dart';
import 'package:odev/screen/categories_screen.dart';
import 'package:odev/screen/home_screen.dart';
import 'package:odev/models/category.dart';
import 'package:odev/screen/todoListByCategoryScreen.dart';
import 'package:odev/services/category_service.dart';
class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  var image='http://cdn.onlinewebfonts.com/svg/img_524503.png';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children:  <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(image),
              ),
              accountName: Text("test"),
              accountEmail: Text("admin.admin"),
              decoration: BoxDecoration(color: Colors.pinkAccent),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("home"),
              onTap: ()=>Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreen())
              ),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("Categories"),
              onTap: ()=>Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                  itemCount: _categoryList.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            TodoListByCategoryScreen(category:_categoryList[index].name.toString())),(Route<dynamic> route) => false);
                      },
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.only(top:8.0,left:16.0,right:16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_categoryList[index].name.toString()),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
