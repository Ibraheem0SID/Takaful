import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gpt_tableMV.dart';

class PagesNavigationBar extends StatelessWidget {
  const PagesNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Consumer<GptTableMV>(
        builder: (context, data, child) => GridView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: data.pages.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 50,
                mainAxisSpacing: 0,
                childAspectRatio: 8 / 10),
            itemBuilder: (context, index) => TextButton(
                  style: (data.pages[index]["active"])
                      ? ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey[200]))
                      : null,
                  onPressed: (data.pages[index]["active"] ||
                          data.pages[index]["label"] == "..." ||
                          data.pages[index]["url"] == null)
                      ? null
                      : () => data.changePage(data.pages[index]["url"]),
                  child: Text(
                    data.pages[index]["label"],
                    softWrap: true,
                  ),
                )),
      ),
    );
  }
}
