import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painting_app/workers_screen/model/worker_model.dart';

part 'workers_state.dart';

List<WorkerModel> workersFromFirebase = [];

class WorkersCubit extends Cubit<WorkersState> {
  WorkersCubit() : super(WorkersInitial());

  static WorkersCubit get(context) => BlocProvider.of(context);

  bool isBottom = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isOpened,
    required IconData icon,
  }) {
    isBottom = isOpened;
    fabIcon = icon;
    emit(ChangeBottomWorkersSheetState());
  }

  Future<void> addNewWorker({
    required String name,
    required String dayUID,
    required String customerUID,
    required String workerUID,
  }) async {
    WorkerModel workers = WorkerModel(
      name: name,
      uId: workerUID,
    );
    print('data has sent');
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(customerUID)
        .collection('days')
        .doc(dayUID)
        .collection('workers')
        .doc(workerUID)
        .set(workers.toMap())
        .then((value) {
      print('data has sent');
      emit(AddNewWorkerSuccessState());
    }).catchError((error) {
      print('error during add new customer is ${error.toString()}');
      emit(AddNewWorkerErrorState(error.toString()));
    });
  }

  void getWorkers(customerUID, daysUID) {
    FirebaseFirestore.instance
        .collection('customers')
        .doc(customerUID)
        .collection('days')
        .doc(daysUID)
        .collection('workers')
        .orderBy('uId')
        .snapshots()
        .listen((event) {
      //print('the data in days is ${event.docs.first.id}');
      workersFromFirebase = [];
      event.docs.forEach((element) {
        workersFromFirebase.add(WorkerModel.fromJson(element.data()));
      });
      print(workersFromFirebase
          .length); //print('data in days is ${daysFromFirebase[0].dateTime}');
      emit(GetWorkersSuccessState());
    });
  }
}
