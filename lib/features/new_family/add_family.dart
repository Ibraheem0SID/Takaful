import 'package:data_table_try/data/family.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_family_mv.dart';

class AddFamily extends StatefulWidget {
  const AddFamily({Key? key, this.family}) : super(key: key);

  final Family? family;
  @override
  State<AddFamily> createState() => _AddFamilyState();
}

class _AddFamilyState extends State<AddFamily> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AddFamilyMv>(context, listen: false).initializeControllers();
      if (widget.family != null) {
        Provider.of<AddFamilyMv>(context, listen: false)
            .setFamilyValues(widget.family!);
      }
    });
    super.initState();
  }

  @override
  void deactivate() {
    Provider.of<AddFamilyMv>(context, listen: false).disposeControllers();
    Provider.of<AddFamilyMv>(context, listen: false).currentStep = 0;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AddFamilyMv>(
          builder: (context, data, child) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: (data.isLoading)
                ? const CircularProgressIndicator()
                : Stepper(
                    currentStep: data.currentStep,
                    onStepTapped: (step) => data.onStepTapped(step),
                    type: StepperType.horizontal,
                    steps: data.getSteps(),
                    controlsBuilder: (context, details) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  data.onStepCancel(context);
                                },
                                child: const Text(
                                  'عودة',
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                data.onStepContinue(context);
                              },
                              child: Text(
                                (details.currentStep == 2)
                                    ? (data.updating)
                                        ? 'تحديث'
                                        : 'اضافة'
                                    : 'التالي',
                                style: const TextStyle(fontSize: 18),
                              )),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
