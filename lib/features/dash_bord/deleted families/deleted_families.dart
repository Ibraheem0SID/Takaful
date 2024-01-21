import 'package:data_table_try/data/family.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'deleted_families_mv.dart';

class DeletedFamilies extends StatefulWidget {
  const DeletedFamilies({Key? key}) : super(key: key);

  @override
  State<DeletedFamilies> createState() => _DeletedFamiliesState();
}

class _DeletedFamiliesState extends State<DeletedFamilies> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DeletedFamiliesMV>(context, listen: false).fetchData();
    });
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.maxScrollExtent == controller.offset) {
      Provider.of<DeletedFamiliesMV>(context, listen: false).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<DeletedFamiliesMV>(
          builder: (context, data, child) => Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'العوائل المحذوفة',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => data.fetchData(),
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller,
                      itemCount: data.deletedFamilies.length,
                      itemBuilder: (context, index) {
                        Family deletedFamily = data.deletedFamilies[index];
                        return ListTile(
                          title: Text(
                            deletedFamily.providerName,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 26),
                          ),
                          onTap: () {
                            //show family info
                          },
                          trailing: Text(
                            deletedFamily.id.toString(),
                            style: const TextStyle(fontSize: 26),
                          ),
                          leading: IconButton(
                              onPressed: () =>
                                  data.restoreFamily(deletedFamily.id!),
                              icon: const Icon(
                                Icons.settings_backup_restore_rounded,
                                color: Colors.deepPurple,
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
