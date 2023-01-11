import 'package:flutter/material.dart';
import 'new_todo_screen.dart';
import 'todo.dart';
import 'todo_provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: FutureBuilder(
        future: TodoProvider.instance.getTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final todos = snapshot.data;
          _todos = todos!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return TodoItem(
                todo: todos[index],
                onTodoUpdate: _onTodoUpdate,
                onTodoDelete: _onTodoDelete,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Todo? todo = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const NewTodoScreen();
              },
            ),
          );
          if (todo != null) {
            setState(() {
              _todos.add(todo);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTodoUpdate(Todo todo, Todo updatedTodo) {
    setState(() {
      _todos[_todos.indexOf(todo)] = updatedTodo;
    });
  }

  void _onTodoDelete(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo todo, Todo updatedTodo) onTodoUpdate;
  final Function(Todo todo) onTodoDelete;

  const TodoItem(
      {super.key,
      required this.todo,
      required this.onTodoUpdate,
      required this.onTodoDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          todo.title,
          style: todo.checked == 0
              ? null
              : const TextStyle(
                  color: Colors.black54,
                  decoration: TextDecoration.lineThrough,
                ),
        ),
        onTap: () async {
          Todo updatedTodo = todo;
          updatedTodo.checked = todo.checked == 0 ? 1 : 0;
          onTodoUpdate(todo, updatedTodo);
          await TodoProvider.instance.updateTodo(updatedTodo);
        },
        onLongPress: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Delete this todo?"),
                content: Text(todo.title),
                actions: <Widget>[
                  TextButton(
                    child: const Text("delete"),
                    onPressed: () async {
                      await TodoProvider.instance.deleteTodo(todo.id);
                      onTodoDelete(todo);
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
