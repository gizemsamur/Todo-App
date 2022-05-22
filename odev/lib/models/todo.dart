class Todo{
  String? name;
  String? description;
  String? category;
  String? todoDate;
  int? id;


  todoMapp(){
    var mapping =Map<String,dynamic>();
    mapping["id"]=id;
    mapping["name"]=name;
    mapping["description"]=description;
    mapping["category"]=category;
    mapping["todoDate"]=todoDate;
    return mapping;
  }
}