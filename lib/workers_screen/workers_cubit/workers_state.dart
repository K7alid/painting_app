part of 'workers_cubit.dart';

@immutable
abstract class WorkersState {}

class WorkersInitial extends WorkersState {}

class ChangeBottomWorkersSheetState extends WorkersState {}

class GetWorkersSuccessState extends WorkersState {}

class AddNewWorkerSuccessState extends WorkersState {}

class AddNewWorkerErrorState extends WorkersState {
  final String error;

  AddNewWorkerErrorState(this.error);
}
