import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class AddCase extends StatefulWidget {
  const AddCase({super.key, required this.judgeNumber});

  final judgeNumber;
  @override
  State<AddCase> createState() => _AddCaseState();
}

class _AddCaseState extends State<AddCase> {
  final _formKey = GlobalKey<FormState>();
  final _appellantController = TextEditingController();
  final _respondentController = TextEditingController();
  final _caseNumberController = TextEditingController();
  final _writerController = TextEditingController();
  final _caseTitleController = TextEditingController();
  final _sessionDateController = TextEditingController();
  final _sessionDateHijriController = TextEditingController();
  final _judgmentDateController = TextEditingController();
  final _yearController = TextEditingController();
  final _dayNameController = TextEditingController();
  // final _hijriyearController = TextEditingController();

  String _selectedProcedure = 'تحصيل';
  String _selectedCaseType = 'مدني';

  bool _isCaseStatus = false;
  bool _delivered = false;
  bool _isPaid = false;

  String? _caseId;

  @override
  void initState() {
    super.initState();
    // _yearController.text = HijriCalendar.now().hYear.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة قضية')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _caseTitleController,
                    label: 'وصف القضية',
                    hintText: 'أدخل وصف القضية',
                  ),
                  _buildTextField(
                    controller: _appellantController,
                    label: 'المستأنف',
                    hintText: 'أدخل اسم المستأنف',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    controller: _respondentController,
                    label: 'المستأنف ضده',
                    hintText: 'أدخل اسم المستأنف ضده',
                    validator: _validateRequired,
                  ),
                  _buildNumberField(
                    controller: _caseNumberController,
                    label: 'رقم القضية',
                    hintText: 'أدخل رقم القضية',
                    validator: _validateRequired,
                  ),
                  _buildNumberField(
                    controller: _yearController,
                    label: 'لسنـة',
                    hintText: 'أدخل سنة القضية مثل 1445',
                    validator: _validateRequired,
                  ),

                  _buildTextField(
                    controller: _writerController,
                    label: 'الكاتب',
                    hintText: 'أدخل اسم الكاتب',
                  ),
                  // const Center(
                  //     child: Text(
                  //   'سيتم ادخال التاريخ الهجري اوتماتيكي ماعليك سوى إدخال التاريخ الميلادي',
                  //   style: TextStyle(fontSize: 11),
                  // )),
                  _buildTextFieldDate(
                      context: context,
                      label: 'اختر التاريخ الميلادي للجلسة',
                      controller: _sessionDateController,
                      hintText: '(YYYY-MM-DD) أدخل التاريخ الميلادي للجلسة ',
                      validator: _validateDate),
                  _buildTextFieldDate(
                    context: context,
                    controller: _judgmentDateController,
                    label: 'تاريخ اصدار الحكم',
                    hintText: 'أدخل تاريخ الحكم مثل 10-08-2024',
                    validator: _validateDate,
                  ),
                  _buildDropdown(
                    value: _selectedProcedure,
                    items: ['تحصيل', 'للأطلاع', 'حكم'],
                    onChanged: (value) {
                      setState(() {
                        _selectedProcedure = value ?? 'تحصيل';
                      });
                    },
                    label: 'قرار الجلسة',
                  ),
                  _buildDropdown(
                    value: _selectedCaseType,
                    items: ['مدني', 'جنائي'],
                    onChanged: (value) {
                      setState(() {
                        _selectedCaseType = value ?? 'مدني';
                      });
                    },
                    label: 'نوع القضية',
                  ),
                  Visibility(
                    visible: false,
                    child: _buildTextField(
                      label: 'أملاء الحقول',
                      readOnly: true,
                      initialValue: _caseId ?? 'جاري التوليد...',
                    ),
                  ),
                  Row(
                    children: [
                      const Text('منجز'),
                      Checkbox(
                        value: _isCaseStatus,
                        onChanged: (value) {
                          setState(() {
                            _isCaseStatus = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('تم إستلام الاتعاب'),
                      Checkbox(
                        value: _isPaid,
                        onChanged: (value) {
                          setState(() {
                            _isPaid = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('تم التسليم'),
                      Checkbox(
                        value: _delivered,
                        onChanged: (value) {
                          setState(() {
                            _delivered = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addCase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('إضافة قضية',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    bool readOnly = false,
    String? initialValue,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildTextFieldDate({
    required BuildContext context,
    required String label,
    TextEditingController? controller,
    bool readOnly = false,
    String? initialValue,
    String? hintText,
    String? Function(String?)? validator, // Correct type for validator
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
        validator: validator,
        onTap: () async {
          if (readOnly) return; // Prevent date picking if field is read-only

          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            controller?.text = "${pickedDate.toLocal()}".split(' ')[0];

            // Convert to Hijri date
            final hijriDate = HijriCalendar.fromDate(pickedDate);
            // Format the Hijri date as YYYY-MM-DD
            final formattedDate =
                "${hijriDate.hYear}-${hijriDate.hMonth.toString().padLeft(2, '0')}-${hijriDate.hDay.toString().padLeft(2, '0')}";

            // Update the text field with the Hijri date
            setState(() {
              _sessionDateHijriController.text = formattedDate;
              _dayNameController.text = hijriDate.getDayName();
              // _yearController.text = hijriDate.hYear.toString();
            });
          }
        },
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
      ),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null ||
        value.isEmpty ||
        !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      return 'يرجى إدخال تاريخ صحيح بصيغة YYYY-MM-DD';
    }
    return null;
  }

  Future<void> _addCase() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Generate a new document ID
      final newCaseRef = FirebaseFirestore.instance.collection('cases').doc();
      _caseId = newCaseRef.id;

      final caseData = {
        'case_id': _caseId,
        'appellant': _appellantController.text,
        'respondent': _respondentController.text,
        'case_number': _caseNumberController.text,
        'year_hijri': _yearController.text,
        'writer': _writerController.text,
        'procedure': _selectedProcedure,
        'judge_number': widget.judgeNumber,
        'case_title': _caseTitleController.text,
        'case_type': _selectedCaseType,
        'session_date': _sessionDateController.text,
        'session_date_hijri': _sessionDateHijriController.text,
        'is_paid': _isPaid,
        'day_name': _dayNameController.text,
        'judgment_date': _judgmentDateController.text,
        'case_status': _isCaseStatus,
        'delivered': _delivered,
        'isDeleted': false
      };

      try {
        await newCaseRef.set(caseData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة القضية بنجاح')));
        _formKey.currentState?.reset();
        // _yearController.text = DateTime.now()
        //     .year
        //     .toString(); // Reset the year to the current year
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add case: $e')));
      }
    }
  }
}
