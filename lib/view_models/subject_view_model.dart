import 'package:flutter_riverpod/legacy.dart';
import 'package:notely/core/models/message_model.dart';
import 'package:notely/core/models/note_model.dart';
import 'package:notely/core/models/subject_model.dart';
import 'package:notely/core/services/note_service.dart';
import 'package:notely/core/services/subject_service.dart';
import 'package:notely/core/utils/enum.dart';

class SubjectViewModel extends StateNotifier<SubjectState> {
  SubjectViewModel() : super(SubjectState());


  List<SubjectModel> allSubjects = [];
String searchQuery = "";



  Future<MessageModel?> addSubject(SubjectModel subjectModel) async {
    MessageModel? messageModel = await SubjectService.addSubject(subjectModel);
    return messageModel;
  }

  Future<MessageModel?> deleteSubject(int id) async {
    MessageModel? messageModel = await SubjectService.deleteSubject(id);
    return messageModel;
  }

  Future<void> getSubjects() async {
  state = state.copyWith(subjectstate: ViewState.loading);

  allSubjects = await SubjectService.getAllSubjects();

  state = state.copyWith(
    subjectstate: ViewState.idle,
    subjectModel: allSubjects,
  );
}

  Future<MessageModel?> updateSubject(SubjectModel subjectModel) async {
  state = state.copyWith(subjectstate: ViewState.loading);

  final messageModel =
      await SubjectService.updateSubject(subjectModel);

  if (messageModel?.success == true) {
    // Update the item locally
    final updatedList = state.subjectModel?.map((subject) {
      if (subject.id == subjectModel.id) {
        return subjectModel;
      }
      return subject;
    }).toList();

    state = state.copyWith(
      subjectstate: ViewState.idle,
      subjectModel: updatedList,
    );
  } else {
    state = state.copyWith(subjectstate: ViewState.idle);
  }

  return messageModel;
}

void searchSubjects(String query) {
  searchQuery = query;

  if (query.isEmpty) {
    state = state.copyWith(subjectModel: allSubjects);
  } else {
    final filtered = allSubjects
        .where((subject) =>
            subject.name.toLowerCase().contains(query.toLowerCase()) ||
            subject.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    state = state.copyWith(subjectModel: filtered);
  }
}

  
}

class SubjectState {
  final ViewState? subjectState;
  final List<SubjectModel>? subjectModel;

  SubjectState({this.subjectState, this.subjectModel});

 SubjectState copyWith({
  ViewState? subjectstate,
  List<SubjectModel>? subjectModel,
}) {
  return SubjectState(
    subjectState: subjectstate ?? this.subjectState,
    subjectModel: subjectModel ?? this.subjectModel,
  );
}
}

final subjectProvider = StateNotifierProvider<SubjectViewModel, SubjectState>(
  (ref) => SubjectViewModel(),
);
