import 'package:bottom_sheet_scroll_wrapper/bottom_sheet_scroll_wrapper.dart';
import 'package:flutter/material.dart';

class ExampleBottomModalSheet extends StatefulWidget {
  const ExampleBottomModalSheet({
    super.key,
  });

  Future<bool?> show(BuildContext context) async {
    final Widget child = this;
    final mediaQuery = MediaQuery.of(context);
    return showModalBottomSheet(
      context: context,
      elevation: 10,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) => MediaQuery(
        data: mediaQuery,
        child: child,
      ),
    );
  }

  @override
  State<ExampleBottomModalSheet> createState() =>
      _ExampleBottomModalSheetState();
}

class _ExampleBottomModalSheetState extends State<ExampleBottomModalSheet> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height - mediaQuery.padding.top - 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 30,
              height: 3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BottomSheetScrollWrapper(
                child: Builder(builder: (context) {
                  return SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      controller: PrimaryScrollController.of(context),
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      primary: false,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          'ListTile $index',
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
