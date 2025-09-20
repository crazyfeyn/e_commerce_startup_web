import 'package:country_picker/country_picker.dart';
import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomPhoneField extends StatefulWidget {
  final bool readOnly;
  final String? title;
  final TextEditingController controller;

  const CustomPhoneField({super.key, this.readOnly = false, this.title, required this.controller});

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  final TextEditingController ctr = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(mask: '##########', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  Country _selectedCountry = Country.parse('KR');

  Future<void> _initState() async {
    final countryList = CountryService().getAll();
    _selectedCountry = countryList.firstWhere((e) => e.countryCode == 'KR', orElse: () => countryList.first);
    maskFormatter = _onMask(_selectedCountry);
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: AppStyles.labelLGRegular.copyWith(color: AppColors.black400),
          ),
        TextFormField(
          controller: ctr,
          readOnly: widget.readOnly,
          inputFormatters: [maskFormatter],
          maxLength: _selectedCountry.example.length,
          keyboardType: TextInputType.number,
          style: AppStyles.bodyMDRegular,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            hintText: _selectedCountry.example,
            border: InputBorder.none,
            prefixIcon: _buildFlagsButton(),
            counter: const SizedBox.shrink(),
          ),
          onChanged: (value) {
            if(mounted) setState(() {});
            if (value.length <= _selectedCountry.example.length) {
              widget.controller.text = '${_selectedCountry.phoneCode}$value';
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.tr(LocaleKeys.phone_number_error_field_empty);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFlagsButton() {
    return InkWell(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: true,
          onSelect: (Country country) {
            ctr.clear();
            widget.controller.text = '';
            maskFormatter = _onMask(country);
            _selectedCountry = country;
            setState(() {});
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              child: Text(
                "+${_selectedCountry.phoneCode}",
                style: AppStyles.bodyMDRegular,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    );
  }

  MaskTextInputFormatter _onMask(Country country) {
    String mask = '';
    for (int i = 0; i < country.example.length; i++) {
      mask = '$mask#';
    }

    return MaskTextInputFormatter(
      mask: mask,
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }
}
