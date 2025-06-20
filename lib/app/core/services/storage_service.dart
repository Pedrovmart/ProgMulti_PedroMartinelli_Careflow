import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      log('Iniciando upload do arquivo para a pasta $folder');
      log('Nome do arquivo fornecido: $fileName');

      final fileExtension = path.extension(file.path).toLowerCase();
      final storageFileName =
          fileName ?? '${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      log('Nome do arquivo a ser salvo: $storageFileName');

      final sanitizedFolder =
          folder.startsWith('/') ? folder.substring(1) : folder;
      final storagePath = '$sanitizedFolder/$storageFileName';

      log('Caminho completo no storage: $storagePath');

      final ref = _storage.ref().child(storagePath);
      final uploadTask = ref.putFile(file);

      final taskSnapshot = await uploadTask.whenComplete(() => null);
      log('Obtendo URL de download do arquivo...');
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      log('URL original do Firebase Storage: $downloadUrl');

      return downloadUrl;
    } catch (e, stackTrace) {
      log('Erro ao fazer upload do arquivo: $e');
      log('Stack trace: $stackTrace');
      throw Exception('Error uploading file: $e');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Error deleting file: $e');
    }
  }

  Future<String> updateFile({
    required File newFile,
    required String folder,
    String? oldFileUrl,
    String? fileName,
  }) async {
    try {
      if (oldFileUrl != null && oldFileUrl.isNotEmpty) {
        await deleteFile(oldFileUrl);
      }
      return await uploadFile(
        file: newFile,
        folder: folder,
        fileName: fileName,
      );
    } catch (e) {
      throw Exception('Error updating file: $e');
    }
  }
}
