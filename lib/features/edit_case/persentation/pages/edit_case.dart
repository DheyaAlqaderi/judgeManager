import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class EditCase extends StatefulWidget {
  const EditCase({super.key, this.caseId, this.judgeNumber});
  final String? caseId;
  final String? judgeNumber;

  @override
  State<EditCase> createState() => _EditCaseState();
}

class _EditCaseState extends State<EditCase> {
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

  String _selectedProcedure = 'تحصيل';
  String _selectedCaseType = 'مدني';

  bool _isCaseStatus = false;
  bool _delivered = false;
  bool _isPaid = false;

  @override
  void initState() {
    super.initState();
    if (widget.caseId != null) {
      _loadCaseDetails(widget.caseId!);
    } else {
      _yearController.text = HijriCalendar.now().hYear.toString();
    }
  }

  Future<void> _loadCaseDetails(String caseId) async {
    try {
      DocumentSnapshot caseSnapshot =
      await FirebaseFirestore.instance.collection('cases').doc(caseId).get();
      if (caseSnapshot.exists) {
        final caseData = caseSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _appellantController.text = caseData['appellant'] ?? '';
          _respondentController.text = caseData['respondent'] ?? '';
          _caseNumberController.text = caseData['case_number'] ?? '';
          _writerController.text = caseData['writer'] ?? '';
          _caseTitleController.text = caseData['case_title'] ?? '';
          _sessionDateController.text = caseData['session_date'] ?? '';
          _sessionDateHijriController.text = caseData['session_date_hijri'] ?? '';
          _judgmentDateController.text = caseData['judgment_date'] ?? '';
          _yearController.text = caseData['year_hijri'] ?? '';
          _dayNameController.text = caseData['day_name'] ?? '';
          _selectedProcedure = caseData['procedure'] ?? 'تحصيل';
          _selectedCaseType = caseData['case_type'] ?? 'مدني';
          _isCaseStatus = caseData['case_status'] ?? false;
          _delivered = caseData['delivered'] ?? false;
          _isPaid = caseData['is_paid'] ?? false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load case details: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل قضية')),
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
                    label: 'المدعي',
                    hintText: 'أدخل اسم المدعي',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    controller: _respondentController,
                    label: 'المدعى عليه',
                    hintText: 'أدخل اسم المدعى عليه',
                    validator: _validateRequired,
                  ),
                  _buildNumberField(
                    controller: _caseNumberController,
                    label: 'رقم القضية',
                    hintText: 'أدخل رقم القضية',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    controller: _writerController,
                    label: 'الكاتب',
                    hintText: 'أدخل اسم الكاتب',
                  ),
                  const Center(
                    child: Text(
                      'سيتم ادخال التاريخ الهجري اوتماتيكي ماعليك سوى إدخال التاريخ الميلادي',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  _buildTextFieldDate(
                    context: context,
                    label: 'اختر التاريخ الميلادي للجلسة',
                    controller: _sessionDateController,
                    hintText: '(YYYY-MM-DD) أدخل التاريخ الميلادي للجلسة ',
                    validator: _validateDate,
                  ),
                  _buildTextFieldDate(
                    context: context,
                    controller: _judgmentDateController,
                    label: 'تاريخ اصدار الحكم',
                    hintText: 'أدخل تاريخ الحكم مثل 10-08-2024',
                  ),
                  _buildNumberField(
                    controller: _yearController,
                    label: "السنة",
                    hintText: "ادخل السنة",
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
                    onPressed: _updateCase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('تعديل القضية', style: TextStyle(fontSize: 16, color: Colors.white)),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
            // Format the Hijri date as needed
            String hijriDateString = '${hijriDate.hYear}-${hijriDate.hMonth}-${hijriDate.hDay}';
            setState(() {
              _sessionDateHijriController.text = hijriDateString;
              _dayNameController.text = hijriDate.dayWeName;
            });
          }
        },
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    TextEditingController? controller,
    String? initialValue,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return _buildTextField(
      label: label,
      controller: controller,
      initialValue: initialValue,
      hintText: hintText,
      validator: validator,
      readOnly: false,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
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
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) {
      return 'أدخل التاريخ بالتنسيق (YYYY-MM-DD)';
    }
    return null;
  }

  Future<void> _updateCase() async {
    if (_formKey.currentState!.validate()) {
      final caseData = {
        'appellant': _appellantController.text,
        'respondent': _respondentController.text,
        'case_number': _caseNumberController.text,
        'writer': _writerController.text,
        'case_title': _caseTitleController.text,
        'session_date': _sessionDateController.text,
        'session_date_hijri': _sessionDateHijriController.text,
        'judgment_date': _judgmentDateController.text,
        'year_hijri': _yearController.text,
        'procedure': _selectedProcedure,
        'case_type': _selectedCaseType,
        'case_status': _isCaseStatus,
        'delivered': _delivered,
        'is_paid': _isPaid,
        'day_name': _dayNameController.text,
        'judge_number': widget.judgeNumber, // Add judge number to the case data
      };

      try {
        await FirebaseFirestore.instance
            .collection('cases')
            .doc(widget.caseId)
            .update(caseData);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تحديث القضية بنجاح')));
        Navigator.pop(context); // Navigate back to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل في تحديث القضية: $e')));
      }
    }
  }
}

