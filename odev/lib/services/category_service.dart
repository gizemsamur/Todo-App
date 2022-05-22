import 'package:odev/models/category.dart';
import 'package:odev/repositories/repository.dart';

class CategoryService {
  Repository? _repository;
  CategoryService() {
    _repository = Repository();
  }
  saveCategory(Category category) async {
    return await _repository?.insertData('categories', category.categoryMapp());
  }

  readCategories() async {
    return await _repository?.readData('categories');
  }

  readCategoryById(categoryId) async {
    return await _repository?.readDataById('categories', categoryId);
  }

  updateCategory(Category category) async {
    return await _repository?.updateData('categories', category.categoryMapp());
  }

  deleteCategory(categoryId) async {
    return await _repository?.deleteDate('categories', categoryId);
  }
}
