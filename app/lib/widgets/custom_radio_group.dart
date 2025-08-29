import 'package:flutter/material.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  const CustomRadioGroup({
    super.key,
    required this.items,
    required this.selectedItem,
    this.onChanged,
    required this.labelBuilder,
  });

  final List<T> items;
  final T selectedItem;
  final ValueChanged<T>? onChanged;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        items.length,
        (index) {
          final item = items[index];
          return Flexible(
            child: GestureDetector(
              onTap: () => onChanged?.call(item),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: selectedItem == item
                      ? Colors.pink.shade100
                      : Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: items.length == 1
                      ? BorderRadius.circular(10)
                      : index == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )
                      : index == items.length - 1
                      ? BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    labelBuilder(item),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
