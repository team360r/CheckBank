import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Transfer screen with intentional accessibility bugs.
///
/// BUG 1: Stepper progress communicated by colour only (active = teal,
///        inactive = grey) — fails WCAG 1.4.1 Use of Color.
/// BUG 2: No announcement when step changes — screen reader users don't
///        know a new step is now active.
/// BUG 3: Focus does NOT move to the new step's first field on step advance.
/// BUG 4: Confirmation dialog doesn't explicitly manage focus.
/// BUG 5: TextFields use hintText only — no labelText (consistent with
///        login bug).
class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _currentStep = 0;
  final _recipientController = TextEditingController();
  final _sortCodeController = TextEditingController();
  final _accountNumController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _sortCodeController.dispose();
    _accountNumController.dispose();
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep < 2) {
      // BUG 2: No announcement when step changes
      // BUG 3: Focus does NOT move to the new step's first field
      setState(() => _currentStep += 1);
    } else {
      _showConfirmation();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  // BUG 4: Confirmation dialog doesn't explicitly manage focus
  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm transfer'),
        content: Text(
          'Send £${_amountController.text} to ${_recipientController.text}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transfer submitted')),
              );
              setState(() => _currentStep = 0);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
      ),
      // BUG 1: Stepper active/inactive state communicated by colour only
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_currentStep == 2 ? 'Submit' : 'Continue'),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Recipient'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                // BUG 5: hintText only — no labelText
                TextField(
                  controller: _recipientController,
                  decoration: const InputDecoration(
                    hintText: 'Recipient name',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _sortCodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Sort code',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _accountNumController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Account number',
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Amount'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                // BUG 5: hintText only — no labelText
                TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: 'Amount (£)',
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Reference'),
            isActive: _currentStep >= 2,
            state: StepState.indexed,
            content: Column(
              children: [
                // BUG 5: hintText only — no labelText
                TextField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    hintText: 'Payment reference',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
