import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/customer_model.dart';

part 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit() : super(HomeInitial());

  static CustomersCubit get(context) => BlocProvider.of(context);

  bool isBottom = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isOpened,
    required IconData icon,
  }) {
    isBottom = isOpened;
    fabIcon = icon;
    emit(ChangeBottomCustomersSheetState());
  }

  Future<void> addNewCustomer({
    required String name,
    required String address,
    required String phone,
    required String uId,
    required String dateTime,
  }) async {
    CustomerModel customers = CustomerModel(
      name: name,
      address: address,
      phone: phone,
      uId: uId,
      dateTime: dateTime,
    );
    print('data has sent');
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uId)
        .set(customers.toMap())
        .then((value) {
      //print('the id equal ${value.id}');
      print('data has sent');
      emit(AddNewCustomerSuccessState());
    }).catchError((error) {
      print('error during add new customer is ${error.toString()}');
      emit(AddNewCustomerErrorState(error.toString()));
    });
  }

  List<CustomerModel> customersFromFirebase = [];

  void getCustomers() {
    FirebaseFirestore.instance
        .collection('customers')
        .orderBy('uId')
        .snapshots()
        .listen((event) {
      customersFromFirebase = [];
      event.docs.forEach((element) {
        customersFromFirebase.add(CustomerModel.fromJson(element.data()));
      });
      emit(GetCustomersSuccessState());
    });
  }
}
