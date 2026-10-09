package com.example.song_sheets

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import android.provider.MediaStore
import android.provider.OpenableColumns
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.security.MessageDigest
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val channelName = "song_sheets/storage"
    private val chooseTreeRequest = 401
    private val pickImageRequest = 402
    private val createBackupRequest = 403
    private val openBackupRequest = 404
    private val ioExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private var pendingResult: MethodChannel.Result? = null
    private var pendingBackupBytes: ByteArray? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler(::handleCall)
    }

    override fun onDestroy() {
        ioExecutor.shutdown()
        super.onDestroy()
    }

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
                    val flags = data.flags and (
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or
                            Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        )
                    contentResolver.takePersistableUriPermission(uri, flags)
                    runIo(result) {
                        val name = DocumentFile.fromTreeUri(this, uri)?.name ?: "Source folder"
                        mapOf("uri" to uri.toString(), "name" to name)
                    }
                }
                pickImageRequest -> {
                    val flags = data.flags and (
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or
                            Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        )
                    try {
                        if (flags != 0) contentResolver.takePersistableUriPermission(uri, flags)
                    } catch (_: SecurityException) {
                        // A transient grant is enough for immediate list OCR or an explicit copy.
                    }
                    result.success(uri.toString())
                }
                createBackupRequest -> {
                    val bytes = pendingBackupBytes.also { pendingBackupBytes = null }
                    if (bytes == null) {
                        result.error("backup_data", "Backup data was lost before the picker returned.", null)
                    } else {
                        runIo(result) {
                            contentResolver.openOutputStream(uri, "w")!!.use { it.write(bytes) }
                            uri.toString()
                        }
                    }
                }
                openBackupRequest -> runIo(result) { readAll(uri) }
                else -> result.error("unknown_request", "Unknown document picker request.", null)
            }
        } catch (error: Exception) {
            result.error("picker_result", error.message, null)
        }
    }

    private fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "chooseSourceFolder" -> launchSingle(
                result,
                chooseTreeRequest,
                Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                    addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
                    addFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
                },
            )
            "pickImage" -> launchSingle(
                result,
                pickImageRequest,
                Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    type = "image/*"
                    addCategory(Intent.CATEGORY_OPENABLE)
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
                },
            )
            "createBackup" -> {
                pendingBackupBytes = call.argument<ByteArray>("bytes")
                launchSingle(
                    result,
                    createBackupRequest,
                    Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                        type = "application/json"
                        addCategory(Intent.CATEGORY_OPENABLE)
                        putExtra(Intent.EXTRA_TITLE, call.argument<String>("name") ?: "song-sheets-backup.json")
                    },
                )
            }
            "openBackup" -> launchSingle(
                result,
                openBackupRequest,
                Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    type = "application/json"
                    addCategory(Intent.CATEGORY_OPENABLE)
                },
            )
            "legacySourceFolder" -> runIo(result) {
                val value = getPreferences(MODE_PRIVATE).getString("managed_tree", null)
                    ?: return@runIo null
                val uri = Uri.parse(value)
                mapOf(
                    "uri" to value,
                    "name" to (DocumentFile.fromTreeUri(this, uri)?.name ?: "Previous source folder"),
                )
            }
            "listImages" -> runIo(result) {
                listImages(
                    Uri.parse(call.argument<String>("treeUri")!!),
                    call.argument<Boolean>("includeSubfolders") == true,
                )
            }
            "metadata" -> runIo(result) {
                metadata(
                    Uri.parse(call.argument<String>("uri")!!),
                    call.argument<String>("parentUri")?.let(Uri::parse),
                )
            }
            "readBytes" -> runIo(result) { readAll(Uri.parse(call.argument<String>("uri")!!)) }
            "readPreview" -> runIo(result) {
                readPreview(
                    Uri.parse(call.argument<String>("uri")!!),
                    call.argument<Int>("maxDimension") ?: 900,
                )
            }
            "readImage" -> runIo(result) { readImage(Uri.parse(call.argument<String>("uri")!!)) }
            "rename" -> runIo(result) { rename(call) }
            "delete" -> runIo(result) {
                DocumentsContract.deleteDocument(contentResolver, Uri.parse(call.argument<String>("uri")!!))
            }
            "exists" -> runIo(result) { exists(Uri.parse(call.argument<String>("uri")!!)) }
            "sameDocument" -> runIo(result) {
                sameDocument(
                    Uri.parse(call.argument<String>("firstUri")!!),
                    Uri.parse(call.argument<String>("secondUri")!!),
                )
            }
            "copyIntoTree" -> runIo(result) { copyIntoTree(call) }
            else -> result.notImplemented()
        }
    }

    private fun runIo(result: MethodChannel.Result, block: () -> Any?) {
        ioExecutor.execute {
            try {
                val value = block()
                mainHandler.post { result.success(value) }
            } catch (error: SecurityException) {
                mainHandler.post { result.error("permission_revoked", error.message, null) }
            } catch (error: Exception) {
                mainHandler.post { result.error("storage_error", error.message, null) }
            }
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

    private fun listImages(treeUri: Uri, includeSubfolders: Boolean): List<Map<String, Any?>> {
        val root = DocumentFile.fromTreeUri(this, treeUri)
            ?: throw IllegalStateException("The selected source folder is unavailable.")
        val images = mutableListOf<Map<String, Any?>>()
        fun visit(directory: DocumentFile) {
            directory.listFiles().forEach { document ->
                if (document.isDirectory) {
                    if (includeSubfolders) visit(document)
                } else if (document.type == "image/jpeg" || document.type == "image/png") {
                    metadata(document.uri, directory.uri)?.let(images::add)
                }
            }
        }
        visit(root)
        return images
    }

    private fun metadata(uri: Uri, parentUri: Uri?): Map<String, Any?>? {
        contentResolver.query(
            uri,
            arrayOf(
                OpenableColumns.DISPLAY_NAME,
                OpenableColumns.SIZE,
                DocumentsContract.Document.COLUMN_MIME_TYPE,
                DocumentsContract.Document.COLUMN_LAST_MODIFIED,
                DocumentsContract.Document.COLUMN_FLAGS,
            ),
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
            return mapOf(
                "uri" to uri.toString(),
                "stableIdentity" to stableIdentity(uri),
                "parentUri" to parentUri?.toString(),
                "name" to name,
                "size" to size,
                "mimeType" to mime,
                "lastModified" to modified,
                "providerAddedAt" to queryProviderAddedAt(uri),
                "canRead" to exists(uri),
                "canWrite" to (flags and DocumentsContract.Document.FLAG_SUPPORTS_WRITE != 0),
                "canRename" to (flags and DocumentsContract.Document.FLAG_SUPPORTS_RENAME != 0),
                "canDelete" to (flags and DocumentsContract.Document.FLAG_SUPPORTS_DELETE != 0),
            )
        }
        return null
    }

    private fun queryProviderAddedAt(uri: Uri): Long? = try {
        contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            if (!cursor.moveToFirst()) return null
            val names = listOf(MediaStore.MediaColumns.DATE_ADDED, "date_created", "downloaded_at")
            for (name in names) {
                val index = cursor.getColumnIndex(name)
                if (index >= 0 && !cursor.isNull(index)) {
                    val value = cursor.getLong(index)
                    if (value > 0) return if (value < 10_000_000_000L) value * 1000 else value
                }
            }
            null
        }
    } catch (_: Exception) {
        null
    }

    private fun stableIdentity(uri: Uri): String = try {
        "${uri.authority}:${DocumentsContract.getDocumentId(uri)}"
    } catch (_: Exception) {
        uri.toString()
    }

    private fun readAll(uri: Uri): ByteArray {
        contentResolver.openInputStream(uri)!!.use { input ->
            val output = ByteArrayOutputStream()
            input.copyTo(output, 64 * 1024)
            return output.toByteArray()
        }
    }

    private fun readImage(uri: Uri): Map<String, Any> {
        val digest = MessageDigest.getInstance("SHA-256")
        val output = ByteArrayOutputStream()
        contentResolver.openInputStream(uri)!!.use { input ->
            val buffer = ByteArray(64 * 1024)
            while (true) {
                val count = input.read(buffer)
                if (count < 0) break
                digest.update(buffer, 0, count)
                output.write(buffer, 0, count)
            }
        }
        return mapOf(
            "bytes" to output.toByteArray(),
            "sha256" to digest.digest().joinToString("") { "%02x".format(it) },
        )
    }

    private fun readPreview(uri: Uri, maxDimension: Int): ByteArray {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        contentResolver.openInputStream(uri)!!.use { BitmapFactory.decodeStream(it, null, bounds) }
        var sample = 1
        while (bounds.outWidth / sample > maxDimension * 2 || bounds.outHeight / sample > maxDimension * 2) {
            sample *= 2
        }
        val options = BitmapFactory.Options().apply { inSampleSize = sample }
        val decoded = contentResolver.openInputStream(uri)!!.use {
            BitmapFactory.decodeStream(it, null, options)
        } ?: throw IllegalArgumentException("Unsupported or damaged image.")
        val scale = minOf(1.0, maxDimension.toDouble() / maxOf(decoded.width, decoded.height))
        val scaled = if (scale < 1.0) {
            Bitmap.createScaledBitmap(decoded, (decoded.width * scale).toInt(), (decoded.height * scale).toInt(), true)
                .also { decoded.recycle() }
        } else {
            decoded
        }
        return ByteArrayOutputStream().use { output ->
            scaled.compress(Bitmap.CompressFormat.JPEG, 82, output)
            scaled.recycle()
            output.toByteArray()
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

    private fun rename(call: MethodCall): Map<String, Any?> {
        val uri = Uri.parse(call.argument<String>("uri")!!)
        val parentUri = Uri.parse(call.argument<String>("parentUri")!!)
        val requested = call.argument<String>("name")!!
        val parent = documentFile(parentUri)
            ?: throw IllegalStateException("The document parent is unavailable.")
        val safeName = collisionFreeName(parent, requested, uri)
        val renamed = DocumentsContract.renameDocument(contentResolver, uri, safeName)
            ?: throw IllegalStateException("The document provider rejected the rename.")
        return metadata(renamed, parentUri)
            ?: throw IllegalStateException("The renamed document could not be read.")
    }

    private fun documentFile(uri: Uri): DocumentFile? =
        if (uri.pathSegments.contains("document")) {
            DocumentFile.fromSingleUri(this, uri)
        } else {
            DocumentFile.fromTreeUri(this, uri)
        }

    private fun collisionFreeName(parent: DocumentFile, requested: String, source: Uri): String {
        val dot = requested.lastIndexOf('.')
        val stem = if (dot > 0) requested.substring(0, dot) else requested
        val extension = if (dot > 0) requested.substring(dot) else ""
        var candidate = requested
        var suffix = 2
        while (parent.findFile(candidate)?.uri?.let { !sameDocument(it, source) } == true) {
            candidate = "$stem ($suffix)$extension"
            suffix++
        }
        return candidate
    }

    private fun copyIntoTree(call: MethodCall): String {
        val source = Uri.parse(call.argument<String>("uri")!!)
        val treeUri = Uri.parse(call.argument<String>("treeUri")!!)
        val root = DocumentFile.fromTreeUri(this, treeUri)
            ?: throw IllegalStateException("The destination folder is unavailable.")
        if (!root.canWrite()) throw SecurityException("The destination folder is read-only.")
        val requested = collisionFreeName(root, call.argument<String>("name") ?: "Imported sheet", source)
        val mime = contentResolver.getType(source) ?: "image/jpeg"
        val target = root.createFile(mime, requested)
            ?: throw IllegalStateException("Could not create a file in the destination folder.")
        contentResolver.openInputStream(source)!!.use { input ->
            contentResolver.openOutputStream(target.uri, "w")!!.use { output ->
                input.copyTo(output, 64 * 1024)
            }
        }
        return target.uri.toString()
    }
}
