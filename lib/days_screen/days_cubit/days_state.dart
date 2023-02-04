part of 'days_cubit.dart';

@immutable
abstract class DaysState {}

class DaysInitial extends DaysState {}

class ChangeBottomDaysSheetState extends DaysState {}

class AddNewDaySuccessState extends DaysState {}

class GetDaysSuccessState extends DaysState {}

class AddNewDayErrorState extends DaysState {
  final String error;

  AddNewDayErrorState(this.error);
}
