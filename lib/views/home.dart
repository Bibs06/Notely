import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/core/models/note_model.dart';
import 'package:notely/core/models/subject_model.dart';
import 'package:notely/core/utils/colors.dart';
import 'package:notely/core/utils/enum.dart';
import 'package:notely/core/utils/go.dart';
import 'package:notely/core/widgets/custom_btn.dart';
import 'package:notely/core/widgets/toast.dart';
import 'package:notely/view_models/note_view_model.dart';
import 'package:notely/view_models/subject_view_model.dart';
import 'package:notely/views/notes.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {

  void _showSubjectOptions(SubjectModel subject) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit"),
            onTap: () {
              Navigator.pop(context);
              _openSubjectSheet(context, subject: subject);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Delete", style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await ref
                  .read(subjectProvider.notifier)
                  .deleteSubject(subject.id!);

              ref.read(subjectProvider.notifier).getSubjects();
            },
          ),
        ],
      );
    },
  );
}


bool isSearching = false;
final TextEditingController searchController = TextEditingController();



  void _openSubjectSheet(BuildContext context, {SubjectModel? subject}) {
  final nameController =
      TextEditingController(text: subject?.name ?? "");
  final descController =
      TextEditingController(text: subject?.description ?? "");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          top: 24.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subject == null ? "Create Subject" : "Edit Subject",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Subject Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
           CustomBtn(btnText:  subject == null ? "Create" : "Update",
           bgColor: AppColors.darkBlue,
           textColor: AppColors.white,
           padY: 16.h,
           onTap: ()async {
               final viewModel =
                    ref.read(subjectProvider.notifier);

                if (subject == null) {
                  await viewModel.addSubject(
                    SubjectModel(
                      name: nameController.text,
                      description: descController.text,
                      createdAt: DateTime.now().toString(),
                    ),
                  );
                } else {
                  await viewModel.updateSubject(
                    SubjectModel(
                      id: subject.id,
                      name: nameController.text,
                      description: descController.text,
                      createdAt: subject.createdAt,
                    ),
                  );
                }

                Navigator.pop(context);
                viewModel.getSubjects();
           },
           
             
            ),
          ],
        ),
      );
    },
  );
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subjectProvider.notifier).getSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16.w,
  backgroundColor: AppColors.darkBlue,
  title: isSearching
      ? TextField(
          controller: searchController,
          autofocus: true,
          style: TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: "Search subjects...",
            hintStyle: TextStyle(color: AppColors.white),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(subjectProvider.notifier).searchSubjects(value);
          },
        )
      : Text(
          'Notely',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
  actions: [
    IconButton(
      icon: Icon(
        isSearching ? Icons.close : Icons.search,
        color: AppColors.white,
      ),
      onPressed: () {
        setState(() {
          if (isSearching) {
            searchController.clear();
            ref.read(subjectProvider.notifier).searchSubjects("");
          }
          isSearching = !isSearching;
        });
      },
    ),
  ],
),
      floatingActionButton: FloatingActionButton.extended(
  backgroundColor: AppColors.darkBlue,
  onPressed: () => _openSubjectSheet(context),
  icon: Icon(Icons.add, color: AppColors.white),
  label: Text("Add Subject", style: TextStyle(color: AppColors.white)),
),


      body: Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(subjectProvider);
          if (model.subjectState == ViewState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (model.subjectModel == null ||
              model.subjectModel!.isEmpty) {
            return Center(child: Text('NO subject found'));
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: model.subjectModel?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Go.toWithAnimation(context, NotesView(subjectId: model.subjectModel![index].id!.toInt(),), 1, 0);
                },
                 onLongPress: () {
    _showSubjectOptions(model.subjectModel![index]);
  },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 214, 91),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.subjectModel![index].name.toString(),
                            style: TextStyle(
                              fontSize: 22.sp,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            model.subjectModel![index].description.toString(),
                            style: TextStyle(fontSize: 18.sp, letterSpacing: 2),
                          ),
                          Text(
                            model.subjectModel![index].createdAt.toString(),
                            style: TextStyle(fontSize: 18.sp, letterSpacing: 2),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_right_alt_outlined),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
