import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/core/models/note_model.dart';
import 'package:notely/core/utils/colors.dart';
import 'package:notely/core/utils/enum.dart';
import 'package:notely/core/widgets/custom_btn.dart';
import 'package:notely/view_models/note_view_model.dart';

class NotesView extends ConsumerStatefulWidget {
  final int subjectId;
  const NotesView({super.key, required this.subjectId});

  @override
  ConsumerState<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends ConsumerState<NotesView> {
  final ScrollController scrollController = ScrollController();
  final pageProvider = StateProvider<int>((ref) => 1);

  bool isSearching = false;
final TextEditingController searchController = TextEditingController();

  int incrementPage() {
    final newPage = ref
        .read(pageProvider.notifier)
        .update((state) => state + 1);
    return newPage;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(noteProvider.notifier).fetchNotes(widget.subjectId);
    });

    scrollController.addListener(() {
      final viewModel = ref.read(noteProvider.notifier);

      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.8) {
        final model = ref.read(noteProvider);
        if (scrollController.position.pixels != 0 &&
            model.notes != null &&
            model.loadMoreState != ViewState.loading &&
            ref.read(pageProvider) < viewModel.totalPage) {
          ref
              .read(noteProvider.notifier)
              .loadMoreNotes(widget.subjectId, incrementPage());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteProvider);
    final viewModel = ref.read(noteProvider.notifier);

    return Scaffold(
     appBar: AppBar(
      backgroundColor: AppColors.darkBlue,
      
  elevation: 0,
  title: isSearching
      ? TextField(
          controller: searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search notes...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(noteProvider.notifier).searchNotes(value);
          },
        )
      : const Text("Notes",style: TextStyle(
        color: AppColors.white,fontWeight: FontWeight.bold,letterSpacing: 2
      ),),
  actions: [
    IconButton(
      icon: Icon(isSearching ? Icons.close : Icons.search),
      onPressed: () {
        setState(() {
          if (isSearching) {
            searchController.clear();
            ref.read(noteProvider.notifier).searchNotes("");
          }
          isSearching = !isSearching;
        });
      },
    ),
  ],
),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteSheet(context),
        icon: const Icon(Icons.add),
        label: const Text("Add Note"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(noteProvider);

          final viewModel = ref.read(noteProvider.notifier);

          final currentPage = ref.watch(pageProvider);

          final isLastPage = currentPage >= viewModel.totalPage!;

          if (model.noteState == ViewState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (model.notes == null || model.notes!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No Notes Yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap + to create your first note",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final displayList = state.searchQuery.isEmpty
              ? state.notes!
              : state.filteredNotes ?? [];

          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final note = displayList[index];
              if (index < model.notes!.length) {
                return Dismissible(
                  key: Key(note.id.toString()),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    viewModel.deleteNote(note.id!, widget.subjectId);
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          note.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onTap: () => _openNoteSheet(context, note: note),
                    ),
                  ),
                );
              }
              if (model.loadMoreState == ViewState.loading) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hang on, loading content',
                        style: TextStyle(color: AppColors.black),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 22.h,
                        width: 22.w,
                        child: CircularProgressIndicator(
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (isLastPage) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    'No more data',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.black),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  void _openNoteSheet(BuildContext context, {NoteModel? note}) {
    final titleController = TextEditingController(text: note?.title ?? "");
    final descController = TextEditingController(text: note?.description ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note == null ? "Add Note" : "Edit Note",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              CustomBtn(
                btnText: 'Save',
                padY: 16.h,
                textColor: AppColors.white,
                bgColor: AppColors.darkBlue,
                onTap: () async {
                  final viewModel = ref.read(noteProvider.notifier);

                  if (note == null) {
                    await viewModel.addNote(
                      NoteModel(
                        title: titleController.text,
                        description: descController.text,
                        subjectId: widget.subjectId,
                        createdAt: DateTime.now().toIso8601String(),
                      ),
                      widget.subjectId,
                    );
                  } else {
                    await viewModel.updateNote(
                      NoteModel(
                        id: note.id,
                        title: titleController.text,
                        description: descController.text,
                        subjectId: widget.subjectId,
                        createdAt: note.createdAt,
                      ),
                      widget.subjectId,
                    );
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
