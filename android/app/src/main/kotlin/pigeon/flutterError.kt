package pigeon

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
        val code: String,
        override val message: String? = null,
        val details: Any? = null
) : Throwable()
