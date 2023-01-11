import 'package:flutter/material.dart';
import 'todo.dart';
import 'todo_provider.dart';

class NewTodoScreen extends StatefulWidget {
  const NewTodoScreen({super.key});

  @override
  State<NewTodoScreen> createState() => _NewTodoScreenState();
}

class _NewTodoScreenState extends State<NewTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Todo'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: _titleController,
            validator: (value) {
              if (value == "") {
                return 'Please enter a title';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            Todo todo;
            todo = Todo(
                id: DateTime.now().millisecondsSinceEpoch,
                title: _titleController.text);
            await TodoProvider.instance.insertTodo(todo);
            Navigator.of(context).pop(todo);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
