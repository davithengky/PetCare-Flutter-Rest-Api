import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/pets/providers/pets_provider.dart';

/// Memeriksa apakah pengguna sudah memiliki anabul sebelum mengakses fitur tertentu.
/// Jika belum, menampilkan dialog ajakan untuk menambah anabul.
Future<bool> ensureHasPet(BuildContext context, WidgetRef ref) async {
  final pets = ref.read(petsProvider).value ?? [];

  if (pets.isEmpty) {
    await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Belum Ada Anabul'),
          content: const Text('Kamu belum punya anabul. Tambah dulu yuk!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Nanti'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
                context.push('/pets/add');
              },
              child: const Text('Tambah Anabul'),
            ),
          ],
        );
      },
    );
    return false;
  }

  return true;
}
