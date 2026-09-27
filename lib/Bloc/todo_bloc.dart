import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../Model/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState()) {
    on<GetTodos>(_getTodos);
    on<AddTodo>(_addTodo);
    on<DeleteTodo>(_deleteTodo);
    on<EditTodo>(_editTodo);
    on<ToggleTodo>(_toggleTodo);
  }

  Future<void> _getTodos(GetTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/todos'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['todos'];
        List<Todo> fetchedTodos = list.map((e) => Todo.fromJson(e)).toList();
        emit(state.copyWith(todos: fetchedTodos, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: 'Failed to load data'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _addTodo(AddTodo event, Emitter<TodoState> emit) {
    final newTodo = Todo(id: DateTime.now().millisecondsSinceEpoch, title: event.title);
    final updatedList = List<Todo>.from(state.todos)..add(newTodo);
    emit(state.copyWith(todos: updatedList));
  }

  void _deleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    final updatedList = List<Todo>.from(state.todos)..removeAt(event.index);
    emit(state.copyWith(todos: updatedList));
  }

  void _editTodo(EditTodo event, Emitter<TodoState> emit) {
    final updatedList = List<Todo>.from(state.todos);
    updatedList[event.index] = Todo(
      id: updatedList[event.index].id,
      title: event.newTitle,
      isDone: updatedList[event.index].isDone,
    );
    emit(state.copyWith(todos: updatedList));
  }

  void _toggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    final updatedList = List<Todo>.from(state.todos);
    updatedList[event.index].isDone = !updatedList[event.index].isDone;
    emit(state.copyWith(todos: updatedList));
  }
}