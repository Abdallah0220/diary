import 'package:flutter/material.dart';

class EntryDetailPage extends StatefulWidget {
  final String entry;
  final int entryIndex;
  final Function(int) onDelete;
  final Function(int, String) onEdit;

  const EntryDetailPage({
    super.key,
    required this.entry,
    required this.entryIndex,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  final Color _primaryColor = Colors.deepPurple;
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.entry);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Save edits when exiting edit mode
        widget.onEdit(widget.entryIndex, _editController.text);
      }
    });
  }

  Future<void> _confirmDelete() async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Delete Entry'),
            content: const Text('Are you sure you want to delete this entry?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  widget.onDelete(widget.entryIndex);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
              _isEditing
                  ? const Text('Editing Entry', key: Key('editing'))
                  : const Text('Diary Entry', key: Key('viewing')),
        ),
        centerTitle: true,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _isEditing
                      ? const Icon(Icons.check, key: Key('check'))
                      : const Icon(Icons.edit, key: Key('edit')),
            ),
            onPressed: _toggleEdit,
          ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primaryColor.withOpacity(0.05), Colors.grey[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      _isEditing
                          ? TextField(
                            key: const Key('edit-field'),
                            controller: _editController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write your thoughts...',
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                            autofocus: true,
                          )
                          : AnimatedDefaultTextStyle(
                            key: const Key('display-text'),
                            duration: const Duration(milliseconds: 300),
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                            child: Text(widget.entry),
                          ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child:
            _isEditing
                ? FloatingActionButton(
                  key: const Key('cancel-fab'),
                  onPressed: _toggleEdit,
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  elevation: 4,
                  child: const Icon(Icons.close),
                )
                : FloatingActionButton(
                  key: const Key('back-fab'),
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  child: const Icon(Icons.arrow_back),
                ),
      ),
    );
  }
}
