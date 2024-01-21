import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gpt_tableMV.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GptTableMV>(
      builder: (context, data, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                const Text(
                  'عدد الصفوف',
                ),
                DropdownButton(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  value: data.perPage,
                  items: const [
                    DropdownMenuItem(
                      value: 5,
                      child: Text('5'),
                    ),
                    DropdownMenuItem(
                      value: 10,
                      child: Text('10'),
                    ),
                    DropdownMenuItem(
                      value: 15,
                      child: Text('15'),
                    ),
                    DropdownMenuItem(
                      value: 20,
                      child: Text('20'),
                    ),
                    DropdownMenuItem(
                      value: 25,
                      child: Text('25'),
                    ),
                  ],
                  onChanged: (value) => data.changePerPage(value),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    onChanged: (value) {
                      data.search(value);
                    },
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                        hintText: "بحث",
                        hintStyle: TextStyle(
                          fontSize: 20,
                        ),
                        hintTextDirection: TextDirection.rtl,
                        contentPadding: EdgeInsets.all(16),
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
