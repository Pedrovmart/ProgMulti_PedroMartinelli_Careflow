import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the download URL
  ///
  /// [file] - The file to upload
  /// [folder] - The folder in storage where the file should be saved (e.g., 'users_images')
  /// [fileName] - Optional custom file name. If not provided, the original file name will be used
  Future<String> uploadFile({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      log('Iniciando upload do arquivo para a pasta $folder');
      log('Nome do arquivo fornecido: $fileName');

      // Garante que temos um nome de arquivo
      final fileExtension = path.extension(file.path).toLowerCase();
      final storageFileName =
          fileName ?? '${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      log('Nome do arquivo a ser salvo: $storageFileName');

      // Remove barras iniciais para evitar problemas
      final sanitizedFolder =
          folder.startsWith('/') ? folder.substring(1) : folder;
      final storagePath = '$sanitizedFolder/$storageFileName';

      log('Caminho completo no storage: $storagePath');

      // Faz o upload do arquivo
      final ref = _storage.ref().child(storagePath);
      final uploadTask = ref.putFile(file);

      // Aguarda o upload ser concluído
      final taskSnapshot = await uploadTask.whenComplete(() => null);

      // Obtém a URL de download
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

  /// Deletes a file from Firebase Storage
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Error deleting file: $e');
    }
  }

  /// Updates a file in Firebase Storage by first deleting the old one (if exists) and uploading the new one
  Future<String> updateFile({
    required File newFile,
    required String folder,
    String? oldFileUrl,
    String? fileName,
  }) async {
    try {
      // Delete old file if exists
      if (oldFileUrl != null && oldFileUrl.isNotEmpty) {
        await deleteFile(oldFileUrl);
      }

      // Upload new file
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
