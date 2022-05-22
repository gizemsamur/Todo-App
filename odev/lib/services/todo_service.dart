import 'package:odev/models/todo.dart';
import 'package:odev/repositories/repository.dart';

class TodoService{
  Repository? _repository;
  TodoService(){
    _repository=Repository();
  }
  saveTodo(Todo todo) async{
    return await _repository?.insertData("todos",todo.todoMapp());
  }
  readTodo() async{
    return await _repository?.readData("todos");
  }
  readTodoById(todoId) async{
    return await _repository?.readDataById("todos",todoId);
  }
  readDataByCategory(todoName) async{
    return await _repository?.readDataByCategory("todos",todoName);
  }
  updateTodo(Todo todo) async{
    return await _repository?.updateData("todos",todo.todoMapp());
  }
  deleteTodo(todoId) async{
    return await _repository?.deleteDate("todos",todoId);
  }
}