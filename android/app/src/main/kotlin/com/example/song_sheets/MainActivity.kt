package com.example.song_sheets

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import android.provider.OpenableColumns
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val channelName = "song_sheets/storage"
    private val chooseTreeRequest = 401
    private val pickImageRequest = 402
    private val createBackupRequest = 403
    private val openBackupRequest = 404
    private var pendingResult: MethodChannel.Result? = null
    private var pendingBackupBytes: ByteArray? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val result = pendingResult.also { pendingResult = null } ?: return
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            pendingBackupBytes = null
            result.success(null)
            return
        }
        try {
            when (requestCode) {
                chooseTreeRequest -> {
                    val flags = data.flags and (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                    contentResolver.takePersistableUriPermission(uri, flags)
                    getPreferences(MODE_PRIVATE).edit().putString("managed_tree", uri.toString()).apply()
                    result.success(uri.toString())
                }
                pickImageRequest -> {
                    val flags = data.flags and (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                    try {
                        if (flags != 0) contentResolver.takePersistableUriPermission(uri, flags)
                    } catch (_: SecurityException) {
                        // A transient grant is sufficient for the immediate managed-folder copy.
                    }
                    result.success(uri.toString())
                }
                createBackupRequest -> {
                    val bytes = pendingBackupBytes.also { pendingBackupBytes = null }
                        ?: throw IllegalStateException("Backup data was lost before the picker returned.")
                    contentResolver.openOutputStream(uri, "w")!!.use { it.write(bytes) }
                    result.success(uri.toString())
                }
                openBackupRequest -> result.success(readAll(uri))
                else -> result.error("unknown_request", "Unknown document picker request.", null)
            }
        } catch (error: Exception) {
            result.error("picker_result", error.message, null)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler(::handleCall)
    }

    private fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "chooseTree" -> launchSingle(result, chooseTreeRequest,
                    Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                        addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
                        addFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
                    })
                "persistedTree" -> result.success(getPreferences(MODE_PRIVATE).getString("managed_tree", null))
                "listImages" -> result.success(listImages())
                "metadata" -> result.success(metadata(Uri.parse(call.argument<String>("uri")!!)))
                "readBytes" -> result.success(readAll(Uri.parse(call.argument<String>("uri")!!)))
                "rename" -> result.success(rename(call))
                "delete" -> result.success(DocumentsContract.deleteDocument(contentResolver, Uri.parse(call.argument<String>("uri")!!)))
                "exists" -> result.success(exists(Uri.parse(call.argument<String>("uri")!!)))
                "sameDocument" -> result.success(sameDocument(
                    Uri.parse(call.argument<String>("firstUri")!!),
                    Uri.parse(call.argument<String>("secondUri")!!),
                ))
                "pickImage" -> launchSingle(result, pickImageRequest,
                    Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                        type = "image/*"
                        addCategory(Intent.CATEGORY_OPENABLE)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
                    })
                "copyIntoTree" -> result.success(copyIntoTree(call))
                "createBackup" -> {
                    pendingBackupBytes = call.argument<ByteArray>("bytes")
                    launchSingle(result, createBackupRequest, Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                        type = "application/json"
                        addCategory(Intent.CATEGORY_OPENABLE)
                        putExtra(Intent.EXTRA_TITLE, call.argument<String>("name") ?: "song-sheets-backup.json")
                    })
                }
                "openBackup" -> launchSingle(result, openBackupRequest,
                    Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                        type = "application/json"
                        addCategory(Intent.CATEGORY_OPENABLE)
                    })
                else -> result.notImplemented()
            }
        } catch (error: SecurityException) {
            result.error("permission_revoked", error.message, null)
        } catch (error: Exception) {
            result.error("storage_error", error.message, null)
        }
    }

    private fun launchSingle(result: MethodChannel.Result, requestCode: Int, intent: Intent) {
        if (pendingResult != null) {
            result.error("picker_busy", "Another document picker is already open.", null)
            return
        }
        pendingResult = result
        startActivityForResult(intent, requestCode)
    }

    private fun managedRoot(): DocumentFile {
        val value = getPreferences(MODE_PRIVATE).getString("managed_tree", null)
            ?: throw IllegalStateException("Choose a managed song folder first.")
        return DocumentFile.fromTreeUri(this, Uri.parse(value))
            ?: throw IllegalStateException("The selected song folder is unavailable.")
    }

    private fun listImages(): List<Map<String, Any?>> {
        val images = mutableListOf<Map<String, Any?>>()
        fun visit(directory: DocumentFile) {
            directory.listFiles().forEach { document ->
                if (document.isDirectory) visit(document)
                else if (document.type?.startsWith("image/") == true) metadata(document.uri)?.let(images::add)
            }
        }
        visit(managedRoot())
        return images
    }

    private fun metadata(uri: Uri): Map<String, Any?>? {
        contentResolver.query(
            uri,
            arrayOf(OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE, DocumentsContract.Document.COLUMN_MIME_TYPE, DocumentsContract.Document.COLUMN_LAST_MODIFIED, DocumentsContract.Document.COLUMN_FLAGS),
            null,
            null,
            null,
        )?.use { cursor ->
            if (!cursor.moveToFirst()) return null
            val name = cursor.getString(0) ?: "Untitled"
            val size = if (cursor.isNull(1)) 0L else cursor.getLong(1)
            val mime = cursor.getString(2) ?: contentResolver.getType(uri) ?: "application/octet-stream"
            val modified = if (cursor.isNull(3)) 0L else cursor.getLong(3)
            val flags = if (cursor.isNull(4)) 0 else cursor.getInt(4)
            val canWrite = flags and (DocumentsContract.Document.FLAG_SUPPORTS_WRITE or DocumentsContract.Document.FLAG_SUPPORTS_RENAME or DocumentsContract.Document.FLAG_SUPPORTS_DELETE) != 0
            return mapOf(
                "uri" to uri.toString(),
                "name" to name,
                "size" to size,
                "mimeType" to mime,
                "lastModified" to modified,
                "canRead" to exists(uri),
                "canWrite" to canWrite,
                "canRename" to (flags and DocumentsContract.Document.FLAG_SUPPORTS_RENAME != 0),
                "canDelete" to (flags and DocumentsContract.Document.FLAG_SUPPORTS_DELETE != 0),
            )
        }
        return null
    }

    private fun readAll(uri: Uri): ByteArray {
        contentResolver.openInputStream(uri)!!.use { input ->
            val output = ByteArrayOutputStream()
            input.copyTo(output, 64 * 1024)
            return output.toByteArray()
        }
    }

    private fun exists(uri: Uri): Boolean = try {
        contentResolver.openFileDescriptor(uri, "r")?.use { true } ?: false
    } catch (_: Exception) {
        false
    }

    private fun sameDocument(first: Uri, second: Uri): Boolean = try {
        first.authority == second.authority &&
            DocumentsContract.getDocumentId(first) == DocumentsContract.getDocumentId(second)
    } catch (_: Exception) {
        first == second
    }

    private fun rename(call: MethodCall): String {
        val uri = Uri.parse(call.argument<String>("uri")!!)
        val requested = call.argument<String>("name")!!
        val parent = parentDocument(uri)
        val safeName = collisionFreeName(parent, requested, uri)
        return DocumentsContract.renameDocument(contentResolver, uri, safeName)?.toString()
            ?: throw IllegalStateException("The document provider rejected the rename.")
    }

    private fun collisionFreeName(parent: DocumentFile?, requested: String, source: Uri? = null): String {
        if (parent == null) return requested
        val dot = requested.lastIndexOf('.')
        val stem = if (dot > 0) requested.substring(0, dot) else requested
        val extension = if (dot > 0) requested.substring(dot) else ""
        var candidate = requested
        var suffix = 2
        while (parent.findFile(candidate)?.uri?.let { it != source } == true) {
            candidate = "$stem ($suffix)$extension"
            suffix++
        }
        return candidate
    }

    private fun parentDocument(uri: Uri): DocumentFile? = try {
        val id = DocumentsContract.getDocumentId(uri)
        val separator = id.lastIndexOf('/')
        if (separator < 0) managedRoot()
        else DocumentFile.fromSingleUri(
            this,
            DocumentsContract.buildDocumentUriUsingTree(uri, id.substring(0, separator)),
        )
    } catch (_: Exception) {
        null
    }

    private fun copyIntoTree(call: MethodCall): String {
        val source = Uri.parse(call.argument<String>("uri")!!)
        val root = managedRoot()
        if (!root.canWrite()) throw SecurityException("The managed folder is read-only.")
        val requested = collisionFreeName(root, call.argument<String>("name") ?: "Imported sheet")
        val mime = contentResolver.getType(source) ?: "image/jpeg"
        val target = root.createFile(mime, requested)
            ?: throw IllegalStateException("Could not create a file in the managed folder.")
        contentResolver.openInputStream(source)!!.use { input ->
            contentResolver.openOutputStream(target.uri, "w")!!.use { output -> input.copyTo(output, 64 * 1024) }
        }
        return target.uri.toString()
    }
}
