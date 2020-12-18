import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  final bool filled;
  final Color color;
  final EdgeInsets contentPadding;

  DropDownFormField(
      {FormFieldSetter<dynamic> onSaved,
        FormFieldValidator<dynamic> validator,
        bool autovalidate = false,
        this.titleText = 'Title',
        this.hintText = 'Select one option',
        this.required = false,
        this.errorText = 'Please select one option',
        this.value,
        this.dataSource,
        this.textField,
        this.valueField,
        this.onChanged,
        this.filled = true,
        this.color = Colors.white,
        this.contentPadding = const EdgeInsets.fromLTRB(12, 4, 8, 0)})
      : super(
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    initialValue: value == '' ? null : value,
    builder: (FormFieldState<dynamic> state) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputDecorator(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffd3e9f6))),
                contentPadding: contentPadding,
//                      labelText: titleText,
                filled: filled,
                fillColor: color,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                  // dropdownColor: Colors.white,
                  isExpanded: true,
                  hint: Text(
                    hintText,
                    style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey.shade600,
                        fontFamily: 'KanitRegular'),
                  ),
                  value: value == '' ? null : value,
                  onChanged: (dynamic newValue) {
                    state.didChange(newValue);
                    onChanged(newValue);
                  },
                  items: dataSource.map((item) {
                    return DropdownMenuItem<dynamic>(
                      value: item[valueField],
                      child: Text(item[textField],
                          overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: state.hasError ? 5.0 : 0.0),
            Text(
              state.hasError ? state.errorText : '',
              style: TextStyle(
                  color: Colors.redAccent.shade700,
                  fontSize: state.hasError ? 12.0 : 0.0),
            ),
          ],
        ),
      );
    },
  );
}
