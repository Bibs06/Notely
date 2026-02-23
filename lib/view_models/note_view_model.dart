import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:notely/core/models/message_model.dart';
import 'package:notely/core/models/note_model.dart';
import 'package:notely/core/services/note_service.dart';
import 'package:notely/core/utils/enum.dart';


class NoteViewModel extends StateNotifier<NoteState> {
  NoteViewModel() : super(NoteState());

  List<NoteModel> notes = [];
  int totalPage = 1;
int limit = 20;

 Future<void> fetchNotes(int subjectId) async {
  notes.clear();
  state = state.copyWith(noteState: ViewState.loading);

  final totalCount = await NoteService.getTotalNoteCount(subjectId);

  totalPage = (totalCount / limit).ceil();

  final response = await NoteService.getNotesBySubject(
    subjectId: subjectId,
    page: 1,
    limit: limit,
  );

  notes.addAll(response);

  state = state.copyWith(
    noteState: ViewState.idle,
    notes: notes,
  );
}

  Future<void> loadMoreNotes(int subjectId, int page) async {
    state = state.copyWith(loadMoreState: ViewState.loading);

    final response = await NoteService.getNotesBySubject(
      subjectId: subjectId,
      page: page,
      limit: 20,
    );

    notes.addAll(response);

    state = state.copyWith(
      loadMoreState: ViewState.idle,
      notes: notes,
    );
  }

  Future<MessageModel?> addNote(NoteModel noteModel, int subjectId) async {
    final message = await NoteService.addNote(noteModel);

    if (message?.success == true) {
      await fetchNotes(subjectId);
    }

    return message;
  }

  Future<MessageModel?> updateNote(NoteModel noteModel, int subjectId) async {
    final message = await NoteService.updateNote(noteModel);

    if (message?.success == true) {
      await fetchNotes(subjectId);
    }

    return message;
  }

  Future<MessageModel?> deleteNote(int id, int subjectId) async {
    final message = await NoteService.deleteNote(id);

    if (message?.success == true) {
      await fetchNotes(subjectId);
    }

    return message;
  }

  void searchNotes(String query) {
  final allNotes = state.notes ?? [];

  if (query.isEmpty) {
    state = state.copyWith(
      filteredNotes: allNotes,
      searchQuery: "",
    );
    return;
  }

  final filtered = allNotes.where((note) {
    return note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.description.toLowerCase().contains(query.toLowerCase());
  }).toList();

  state = state.copyWith(
    filteredNotes: filtered,
    searchQuery: query,
  );
}
}



class NoteState {
  final ViewState? noteState;
  final ViewState? loadMoreState;
  final List<NoteModel>? notes;
  final List<NoteModel>? filteredNotes;
  final String searchQuery;

  NoteState({
    this.noteState,
    this.loadMoreState,
    this.notes,
    this.filteredNotes,
    this.searchQuery = "",
  });

  NoteState copyWith({
    ViewState? noteState,
    ViewState? loadMoreState,
    List<NoteModel>? notes,
    List<NoteModel>? filteredNotes,
    String? searchQuery,
  }) {
    return NoteState(
      noteState: noteState ?? this.noteState,
      loadMoreState: loadMoreState ?? this.loadMoreState,
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final noteProvider = StateNotifierProvider<NoteViewModel, NoteState>(
  (ref) => NoteViewModel(),
);
