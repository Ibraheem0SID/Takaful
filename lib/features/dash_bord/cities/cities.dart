import 'package:data_table_try/data/city.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cities_mv.dart';

class Cities extends StatefulWidget {
  const Cities({Key? key}) : super(key: key);

  @override
  State<Cities> createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CitiesMV>(context, listen: false).initializeControllers();
      Provider.of<CitiesMV>(context, listen: false).fetchData();
    });
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void deactivate() {
    Provider.of<CitiesMV>(context, listen: false).disposeControllers();
    super.deactivate();
  }

  void _scrollListener() {
    if (controller.position.maxScrollExtent == controller.offset) {
      Provider.of<CitiesMV>(context, listen: false).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CitiesMV>(
          builder: (context, data, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'المناطق',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      data.initializeControllers();
                      showDialog(
                        context: context,
                        builder: (context) => Consumer<CitiesMV>(
                          builder: (context, value, child) => AlertDialog(
                            title: Column(
                              children: const [
                                Text(
                                  'منطقة جديدة',
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('الغاء')),
                              TextButton(
                                  onPressed: () => value.addNewCity(),
                                  child: const Text('اضافة')),
                            ],
                            content: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, left: 16, right: 16),
                              child: TextField(
                                maxLength: 255,
                                maxLines: 1,
                                textDirection: TextDirection.rtl,
                                controller: value.newCityController,
                                decoration: const InputDecoration(
                                    label: Text('اسم المنطقة'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.center,
                                    border: OutlineInputBorder()),
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'منطقة جديدة',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => data.fetchData(),
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller,
                      itemCount: data.cities.length,
                      itemBuilder: (context, index) {
                        City city = data.cities[index];
                        return ListTile(
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                city.name!,
                                style: const TextStyle(fontSize: 26),
                              ),
                              Expanded(
                                child: Text(
                                  ' عدد العوائل : ${city.familiesCount.toString()}',
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          leading: IconButton(
                              onPressed: (city.familiesCount != 0)
                                  ? null
                                  : () => data.deleteCity(city),
                              disabledColor: Colors.grey,
                              color: Colors.deepPurple,
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 30,
                              )),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          horizontalTitleGap: 30,
                        );
                      }),
                ),
              ),
              if (data.loading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
