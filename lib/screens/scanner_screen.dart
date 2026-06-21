import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../utils/constants.dart';

/// Écran qui ouvre la caméra et scanne un QR code collé sur un livre.
///
/// Dès qu'un code est détecté :
/// - on le transmet au ScheduleProvider via handleScan()
/// - on affiche un message adapté (ajouté / déjà scanné / inconnu)
/// - on bloque temporairement les détections pour éviter de traiter
///   plusieurs fois le même code en rafale (la caméra scanne en continu).
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();

  // Empêche de traiter plusieurs scans du même code en quelques millisecondes
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    final String? code = barcode?.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);

    final provider = context.read<ScheduleProvider>();
    final result = await provider.handleScan(code);

    if (!mounted) return;

    // Couleur du message selon le résultat, pour un retour visuel clair
    Color bgColor;
    switch (result.type) {
      case ScanResultType.added:
        bgColor = AppConstants.colorPresent;
        break;
      case ScanResultType.alreadyScanned:
        bgColor = Colors.orange;
        break;
      case ScanResultType.unknown:
        bgColor = AppConstants.colorMissing;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
      ),
    );

    // Petite pause avant de réactiver le scan, pour laisser le temps
    // à l'utilisateur de voir le message et d'éloigner le livre.
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(AppConstants.msgScanButton),
        backgroundColor: AppConstants.colorPrimary,
        foregroundColor: Colors.white,
        actions: [
          // Bouton pour activer/désactiver le flash, utile en classe sombre
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Cadre visuel au centre pour guider le cadrage du QR code
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isProcessing
                      ? AppConstants.colorPresent
                      : Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
