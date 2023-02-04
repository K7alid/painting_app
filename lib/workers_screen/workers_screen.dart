import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as sky;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painting_app/customers_screen/model/customer_model.dart';
import 'package:painting_app/days_screen/model/day_model.dart';
import 'package:painting_app/shared/components.dart';
import 'package:painting_app/workers_screen/workers_cubit/workers_cubit.dart';

class WorkerScreen extends StatelessWidget {
  WorkerScreen(this.dayModel, this.customerModel, {Key? key}) : super(key: key);

  void clearText() {
    nameController.clear();
  }

  final DayModel dayModel;
  final CustomerModel customerModel;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkersCubit, WorkersState>(
        listener: (context, state) {},
        builder: (context, state) {
          WorkersCubit cubit = WorkersCubit.get(context);

          return Directionality(
            textDirection: sky.TextDirection.rtl,
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      //cubit.workersFromFirebase = [];
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    )),
                title: customText(
                  text: dayModel.dateTime,
                  size: 25,
                  alignment: AlignmentDirectional.centerStart,
                  color: Colors.white,
                ),
              ),
              body: ConditionalBuilder(
                condition: cubit.workersFromFirebase.isEmpty,
                builder: (context) =>
                    const Center(child: Text('لا توجد اي بيانات بعد')),
                fallback: (context) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) => Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        tileColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: customText(
                          text: cubit.workersFromFirebase[index].name,
                          size: 25,
                          alignment: AlignmentDirectional.centerStart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: cubit.workersFromFirebase.length,
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottom) {
                    if (formKey.currentState!.validate()) {
                      cubit.addNewWorker(
                        name: nameController.text,
                        workerUID: DateTime.now().toString(),
                        customerUID: customerModel.uId,
                        dayUID: dayModel.uId,
                      );
                    }
                    clearText();
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultTextFormField(
                                        text: 'اسم العامل',
                                        prefix: Icons.person,
                                        textInputType: TextInputType.name,
                                        controller: nameController,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'من فضلك ادخل اسم العامل';
                                          }
                                          return null;
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                        isOpened: false,
                        icon: Icons.edit,
                      );
                    });
                    cubit.changeBottomSheetState(
                      isOpened: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Icon(
                  cubit.fabIcon,
                ),
              ),
            ),
          );
        },
      );
  }
}
