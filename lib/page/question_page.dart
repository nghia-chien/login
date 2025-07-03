import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  String? _gender;
  String? _bodyType;

  final List<String> _genders = ['Nam', 'Nữ', 'Khác'];
  final List<String> _bodyTypes = ['Body Type 1', 'Body Type 2', 'Body Type 3', 'Body Type 4'];

  bool _isLoading = false;

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _birthDate == null || _gender == null || _bodyType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'dob': _birthDate!.toIso8601String(),
      'gender': _gender,
      'bodyType': _bodyType,
    }, SetOptions(merge: true));

    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Comic Sans MS',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (_) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 20,
          height: 2,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildBodyTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_bodyTypes.length, (index) {
        final selected = _bodyType == _bodyTypes[index];
        return GestureDetector(
          onTap: () => setState(() => _bodyType = _bodyTypes[index]),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: selected ? Colors.blue : Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Image.network(
                  'https://placehold.co/60x60?text=${Uri.encodeComponent(_bodyTypes[index])}',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => FirebaseAuth.instance.signOut(),
                      ),
                    ),
                    _buildSectionTitle('Tên của bạn là gì?'),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập tên...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Ngày sinh của bạn là gì?'),
                    ListTile(
                      title: Text(_birthDate == null
                          ? 'Chọn ngày sinh'
                          : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: _pickBirthDate,
                    ),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Giới tính của bạn là gì?'),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (val) => setState(() => _gender = val),
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Bạn thuộc dáng người như nào?'),
                    _buildBodyTypeSelector(),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Tiếp tục'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
