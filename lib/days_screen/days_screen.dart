import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as sky;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:painting_app/customers_screen/model/customer_model.dart';
import 'package:painting_app/shared/components.dart';
import 'package:painting_app/workers_screen/workers_cubit/workers_cubit.dart';
import 'package:painting_app/workers_screen/workers_screen.dart';

import 'days_cubit/days_cubit.dart';

class DaysScreen extends StatelessWidget {
  DaysScreen({Key? key, required this.customerModel}) : super(key: key);

  final CustomerModel customerModel;

  void clearText() {
    dateTimeController.clear();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DaysCubit(),
        ),
        BlocProvider(
          create: (context) => WorkersCubit(),
        ),
      ],
      child: BlocConsumer<DaysCubit, DaysState>(
        listener: (context, state) {},
        builder: (context, state) {
          DaysCubit daysCubit = DaysCubit.get(context);
          WorkersCubit workersCubit = WorkersCubit.get(context);

          return Directionality(
            textDirection: sky.TextDirection.rtl,
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      //daysFromFirebase = [];
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    )),
                title: customText(
                  text: customerModel.name,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              body: ConditionalBuilder(
                condition: daysFromFirebase.isEmpty,
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
                        onTap: () {
                          print(daysFromFirebase.length);
                          workersCubit.getWorkers(
                            customerModel.uId,
                            daysFromFirebase[index].uId,
                          );
                          navigateTo(
                              context,
                              WorkerScreen(
                                  daysFromFirebase[index], customerModel));
                        },
                        tileColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: customText(
                          text: daysFromFirebase[index].dateTime,
                          size: 25,
                          alignment: AlignmentDirectional.centerStart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: daysFromFirebase.length,
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (daysCubit.isBottom) {
                    if (formKey.currentState!.validate()) {
                      daysCubit.addNewDays(
                        dateTime: dateTimeController.text,
                        dayUID: DateTime.now().toString(),
                        customerUID: customerModel.uId,
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
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(
                                              const Duration(
                                                days: 30,
                                              ),
                                            ),
                                            lastDate: DateTime.now().add(
                                              const Duration(
                                                days: 30,
                                              ),
                                            ),
                                          ).then((value) {
                                            dateTimeController.text =
                                                DateFormat.yMMMM("ar_EG")
                                                    .format(value!);
                                          });
                                        },
                                        text: 'اليوم والتاريخ',
                                        prefix: Icons.phone,
                                        textInputType: TextInputType.number,
                                        controller: dateTimeController,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'من فضلك ادخل التاريخ';
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
                      daysCubit.changeBottomSheetState(
                        isOpened: false,
                        icon: Icons.edit,
                      );
                    });
                    daysCubit.changeBottomSheetState(
                      isOpened: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Icon(
                  daysCubit.fabIcon,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
