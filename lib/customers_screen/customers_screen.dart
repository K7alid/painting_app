import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as sky;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painting_app/customers_screen/customers_cubit/customers_cubit.dart';
import 'package:painting_app/days_screen/days_cubit/days_cubit.dart';
import 'package:painting_app/days_screen/days_screen.dart';
import 'package:painting_app/shared/components.dart';

class CustomersScreen extends StatelessWidget {
  CustomersScreen({Key? key}) : super(key: key);

  void clearText() {
    customerNameController.clear();
    customerAddressController.clear();
    customerPhoneController.clear();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var customerNameController = TextEditingController();
  var customerAddressController = TextEditingController();
  var customerPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CustomersCubit()..getCustomers(),
        ),
        BlocProvider(
          create: (context) => DaysCubit(),
        ),
      ],
      child: BlocConsumer<CustomersCubit, CustomersState>(
        listener: (context, state) {},
        builder: (context, state) {
          CustomersCubit customersCubit = CustomersCubit.get(context);
          DaysCubit daysCubit = DaysCubit.get(context);

          return Directionality(
            textDirection: sky.TextDirection.rtl,
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: customText(
                  text: 'عملاء الشغل',
                  color: Colors.white,
                  size: 35,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  itemBuilder: (context, index) => Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () {
                        daysCubit.getDays(
                            customersCubit.customersFromFirebase[index].uId);

                        navigateTo(
                            context,
                            DaysScreen(
                                customerModel: customersCubit
                                    .customersFromFirebase[index]));
                      },
                      tileColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: customText(
                          text: customersCubit.customersFromFirebase[index].name
                              .toString(),
                          size: 25,
                          alignment: AlignmentDirectional.centerStart,
                          color: Colors.white),
                      subtitle: Column(
                        children: [
                          customText(
                            text: customersCubit
                                .customersFromFirebase[index].address
                                .toString(),
                            size: 20,
                            alignment: AlignmentDirectional.centerStart,
                            color: Colors.grey.shade200,
                          ),
                          customText(
                            text: customersCubit
                                .customersFromFirebase[index].phone
                                .toString(),
                            size: 20,
                            color: Colors.grey.shade200,
                            alignment: AlignmentDirectional.centerStart,
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: customersCubit.customersFromFirebase.length,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (customersCubit.isBottom) {
                    if (formKey.currentState!.validate()) {
                      customersCubit.addNewCustomer(
                        name: customerNameController.text,
                        address: customerAddressController.text,
                        phone: customerPhoneController.text,
                        uId: DateTime.now().toString(),
                        dateTime: DateTime.now().toString(),
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
                                        text: 'اسم العميل',
                                        prefix: Icons.person,
                                        textInputType: TextInputType.name,
                                        controller: customerNameController,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'من فضلك ادخل اسم العميل';
                                          }
                                          return null;
                                        }),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    defaultTextFormField(
                                        text: 'العنوان',
                                        prefix: Icons.home_work,
                                        textInputType:
                                            TextInputType.streetAddress,
                                        controller: customerAddressController,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'من فضلك ادخل العنوان';
                                          }
                                          return null;
                                        }),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    defaultTextFormField(
                                        text: 'رقم الهاتف',
                                        prefix: Icons.phone,
                                        textInputType: TextInputType.number,
                                        controller: customerPhoneController,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'من فضلك ادخل رقم الهاتف';
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
                      customersCubit.changeBottomSheetState(
                        isOpened: false,
                        icon: Icons.edit,
                      );
                    });
                    customersCubit.changeBottomSheetState(
                      isOpened: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Icon(
                  customersCubit.fabIcon,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
