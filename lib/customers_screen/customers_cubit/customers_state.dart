part of 'customers_cubit.dart';

@immutable
abstract class CustomersState {}

class HomeInitial extends CustomersState {}

class ChangeBottomCustomersSheetState extends CustomersState {}

class AddNewCustomerSuccessState extends CustomersState {}

class GetCustomersSuccessState extends CustomersState {}

class AddNewCustomerErrorState extends CustomersState {
  final String error;

  AddNewCustomerErrorState(this.error);
}
