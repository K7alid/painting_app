import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painting_app/days_screen/model/day_model.dart';

part 'days_state.dart';

List<DayModel> daysFromFirebase = [];

class DaysCubit extends Cubit<DaysState> {
  DaysCubit() : super(DaysInitial());

  static DaysCubit get(context) => BlocProvider.of(context);

  bool isBottom = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isOpened,
    required IconData icon,
  }) {
    isBottom = isOpened;
    fabIcon = icon;
    emit(ChangeBottomDaysSheetState());
  }

  Future<void> addNewDays({
    required String dateTime,
    required String dayUID,
    required String customerUID,
  }) async {
    DayModel days = DayModel(
      dateTime: dateTime,
      uId: dayUID,
    );
    print('data has sent');
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(customerUID)
        .collection('days')
        .doc(dayUID)
        .set(days.toMap())
        .then((value) {
      print('data has sent');
      emit(AddNewDaySuccessState());
    }).catchError((error) {
      print('error during add new customer is ${error.toString()}');
      emit(AddNewDayErrorState(error.toString()));
    });
  }

  /*void getDays() {
    FirebaseFirestore.instance
        .collection('customers')
        .doc('2023-01-26 19:25:05.416547')
        .collection('days')
        .orderBy('uId')
        .snapshots()
        .listen((event) {
      //print('the data in days is ${event.docs.first}');
      daysFromFirebase = [];
      event.docs.forEach((element) {
        daysFromFirebase.add(CustomerModel.fromJson(element.data()));
      });
      emit(GetDaysSuccessState());
    });
  }

  void getData() {
    FirebaseFirestore.instance.collection('customers').get().then((value) {
      print('the data in days is ${value.docs.first['uId']}');
      emit(GetDaysSuccessState());
    }).catchError((error) {
      print(error.toString());
    });
  }*/

  void getDays(uId) {
    FirebaseFirestore.instance
        .collection('customers')
        .doc(uId)
        .collection('days')
        .orderBy('uId')
        .snapshots()
        .listen((event) {
      //print('the data in days is ${event.docs.first.id}');
      daysFromFirebase = [];
      event.docs.forEach((element) {
        daysFromFirebase.add(DayModel.fromJson(element.data()));
      });
      print(daysFromFirebase
          .length); //print('data in days is ${daysFromFirebase[0].dateTime}');
      emit(GetDaysSuccessState());
    });
  }
}
