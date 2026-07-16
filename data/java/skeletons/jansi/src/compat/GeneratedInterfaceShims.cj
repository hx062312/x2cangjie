// Package: jansi.compat
package jansi.compat

// Imports Begin
import std.collection.*
// Imports End

public interface JavaAppendable {
    // Methods Begin
    func append(csq: Any): Any {
        throw Exception('TODO')
    }

    func append(csq: Any, start: Int32, end: Int32): Any {
        throw Exception('TODO')
    }

    func append(c: Rune): Any {
        throw Exception('TODO')
    }

    // Methods End
}

public open class JavaAppendableStub <: JavaAppendable {
    public init() {}
}

public interface JavaCharSequence {
    // Methods Begin
    // Methods End
}

public open class JavaCharSequenceStub <: JavaCharSequence {
    public init() {}
}

public interface JavaException {
    // Methods Begin
    // Methods End
}

public open class JavaExceptionStub <: JavaException {
    public init() {}
}

public interface JavaIllegalArgumentException {
    // Methods Begin
    // Methods End
}

public open class JavaIllegalArgumentExceptionStub <: JavaIllegalArgumentException {
    public init() {}
    public init(s: String) {}
    public init(message: String, cause: Any) {}
    public init(cause: Any) {}
}

public interface JavaIllegalStateException {
    // Methods Begin
    // Methods End
}

public open class JavaIllegalStateExceptionStub <: JavaIllegalStateException {
    public init() {}
    public init(s: String) {}
    public init(message: String, cause: Any) {}
    public init(cause: Any) {}
}

public interface JavaIoBufferedReader {
    // Methods Begin
    func readLine(): String {
        return ""
    }

    // Methods End
}

public open class JavaIoBufferedReaderStub <: JavaIoBufferedReader {
    public init() {}
    public init(in__: Any, sz: Int32) {}
    public init(in__: Any) {}
}

public interface JavaIoByteArrayOutputStream {
    // Methods Begin
    func write(b: Int32): Unit {
        return
    }

    func write(b: Array<Int8>, off: Int32, len: Int32): Unit {
        return
    }

    func toString(): String {
        return ""
    }

    func toString(charsetName: String): String {
        return ""
    }

    func toString(charset: Any): String {
        return ""
    }

    // Methods End
}

public open class JavaIoByteArrayOutputStreamStub <: JavaIoByteArrayOutputStream {
    public init() {}
    public init(size: Int32) {}
}

public interface JavaIoCloseable {
    // Methods Begin
    func close(): Unit {
        return
    }

    // Methods End
}

public open class JavaIoCloseableStub <: JavaIoCloseable {
    public init() {}
}

public interface JavaIoFile {
    // Methods Begin
    func getAbsolutePath(): String {
        return ""
    }

    func canExecute(): Bool {
        return false
    }

    // Methods End
}

public open class JavaIoFileStub <: JavaIoFile {
    public init() {}
    public init(pathname: String) {}
    public init(parent: String, child: String) {}
    public init(parent: Any, child: String) {}
    public init(uri: Any) {}
}

public interface JavaIoFileDescriptor {
    // Methods Begin
    // Methods End
}

public open class JavaIoFileDescriptorStub <: JavaIoFileDescriptor {
    public init() {}
}

public interface JavaIoFileInputStream {
    // Methods Begin
    // Methods End
}

public open class JavaIoFileInputStreamStub <: JavaIoFileInputStream {
    public init() {}
    public init(name: String) {}
    public init(file: Any) {}
}

public interface JavaIoFileOutputStream {
    // Methods Begin
    // Methods End
}

public open class JavaIoFileOutputStreamStub <: JavaIoFileOutputStream {
    public init() {}
    public init(name: String) {}
    public init(name: String, append: Bool) {}
    public init(file: Any) {}
    public init(file: Any, append: Bool) {}
}

public interface JavaIoFilenameFilter {
    // Methods Begin
    // Methods End
}

public open class JavaIoFilenameFilterStub <: JavaIoFilenameFilter {
    public init() {}
}

public interface JavaIoIOError {
    // Methods Begin
    // Methods End
}

public open class JavaIoIOErrorStub <: JavaIoIOError {
    public init() {}
    public init(cause: Any) {}
}

public interface JavaIoIOException {
    // Methods Begin
    // Methods End
}

public open class JavaIoIOExceptionStub <: JavaIoIOException {
    public init() {}
}

public interface JavaIoInputStream {
    // Methods Begin
    func close(): Unit {
        return
    }

    // Methods End
}

public open class JavaIoInputStreamStub <: JavaIoInputStream {
    public init() {}
}

public interface JavaIoInputStreamReader {
    // Methods Begin
    // Methods End
}

public open class JavaIoInputStreamReaderStub <: JavaIoInputStreamReader {
    public init() {}
    public init(in__: Any) {}
    public init(in__: Any, charsetName: String) {}
    public init(in__: Any, cs: Any) {}
}

public interface JavaIoOutputStream {
    // Methods Begin
    // Methods End
}

public open class JavaIoOutputStreamStub <: JavaIoOutputStream {
    public init() {}
}

public interface JavaIoPrintStream {
    // Methods Begin
    // Methods End
}

public open class JavaIoPrintStreamStub <: JavaIoPrintStream {
    public init() {}
}

public interface JavaIoUnsupportedEncodingException {
    // Methods Begin
    // Methods End
}

public open class JavaIoUnsupportedEncodingExceptionStub <: JavaIoUnsupportedEncodingException {
    public init() {}
}

public interface JavaLangProcessBuilderRedirect {
    // Methods Begin
    // Methods End
}

public open class JavaLangProcessBuilderRedirectStub <: JavaLangProcessBuilderRedirect {
    public init() {}
}

public interface JavaLangReflectField {
    // Methods Begin
    func setAccessible(flag: Bool): Unit {
        return
    }

    func set(obj: Any, value: Any): Unit {
        return
    }

    // Methods End
}

public open class JavaLangReflectFieldStub <: JavaLangReflectField {
    public init() {}
}

public interface JavaNetURL {
    // Methods Begin
    func openStream(): Any {
        throw Exception('TODO')
    }

    // Methods End
}

public open class JavaNetURLStub <: JavaNetURL {
    public init() {}
}

public interface JavaNioCharsetCharset {
    // Methods Begin
    func name(): String {
        return ""
    }

    // Methods End
}

public open class JavaNioCharsetCharsetStub <: JavaNioCharsetCharset {
    public init() {}
}

public interface JavaNioCharsetUnsupportedCharsetException {
    // Methods Begin
    // Methods End
}

public open class JavaNioCharsetUnsupportedCharsetExceptionStub <: JavaNioCharsetUnsupportedCharsetException {
    public init() {}
}

public interface JavaNullPointerException {
    // Methods Begin
    // Methods End
}

public open class JavaNullPointerExceptionStub <: JavaNullPointerException {
    public init() {}
}

public interface JavaPackage {
    // Methods Begin
    func getImplementationVersion(): String {
        return ""
    }

    // Methods End
}

public open class JavaPackageStub <: JavaPackage {
    public init() {}
}

public interface JavaProcess {
    // Methods Begin
    func getInputStream(): Any {
        throw Exception('TODO')
    }

    func waitFor(): Int32 {
        return 0
    }

    func waitFor(timeout: Int64, unit: Any): Bool {
        return false
    }

    // Methods End
}

public open class JavaProcessStub <: JavaProcess {
    public init() {}
}

public interface JavaProcessBuilder {
    // Methods Begin
    // Methods End
}

public open class JavaProcessBuilderStub <: JavaProcessBuilder {
    public init() {}
    public init(command: Any) {}
    public init(command: Array<String>) {}
}

public interface JavaRuntimeException {
    // Methods Begin
    // Methods End
}

public open class JavaRuntimeExceptionStub <: JavaRuntimeException {
    public init() {}
    public init(message: String) {}
    public init(message: String, cause: Any) {}
    public init(cause: Any) {}
    public init(message: String, cause: Any, enableSuppression: Bool, writableStackTrace: Bool) {}
}

public interface JavaSecurityException {
    // Methods Begin
    // Methods End
}

public open class JavaSecurityExceptionStub <: JavaSecurityException {
    public init() {}
}

public interface JavaStringBuffer {
    // Methods Begin
    // Methods End
}

public open class JavaStringBufferStub <: JavaStringBuffer {
    public init() {}
}

public interface JavaStringBuilder {
    // Methods Begin
    // Methods End
}

public open class JavaStringBuilderStub <: JavaStringBuilder {
    public init() {}
}

public interface JavaThread {
    // Methods Begin
    func start(): Unit {
        return
    }

    func setPriority(newPriority: Int32): Unit {
        return
    }

    func setDaemon(on: Bool): Unit {
        return
    }

    // Methods End
}

public open class JavaThreadStub <: JavaThread {
    public init() {}
    public init(task: Any) {}
    public init(group: Any, task: Any) {}
    public init(name: String) {}
    public init(group: Any, name: String) {}
    public init(group: Any, task: Any, name: String) {}
    public init(group: Any, task: Any, name: String, stackSize: Int64) {}
    public init(group: Any, task: Any, name: String, stackSize: Int64, inheritInheritableThreadLocals: Bool) {}
}

public interface JavaThrowable {
    // Methods Begin
    // Methods End
}

public open class JavaThrowableStub <: JavaThrowable {
    public init() {}
}

public interface JavaUnsatisfiedLinkError {
    // Methods Begin
    // Methods End
}

public open class JavaUnsatisfiedLinkErrorStub <: JavaUnsatisfiedLinkError {
    public init() {}
}

public interface JavaUtilProperties {
    // Methods Begin
    func load(reader: Any): Unit {
        return
    }

    func getProperty(key: String): String {
        return ""
    }

    func getProperty(key: String, defaultValue: String): String {
        return ""
    }

    // Methods End
}

public open class JavaUtilPropertiesStub <: JavaUtilProperties {
    public init() {}
    public init(initialCapacity: Int32) {}
    public init(defaults: Any) {}
}

public interface JavaUtilRandom {
    // Methods Begin
    // Methods End
}

public open class JavaUtilRandomStub <: JavaUtilRandom {
    public init() {}
    public init(seed: Int64) {}
}

public interface JavaUtilRegexMatcher {
    // Methods Begin
    func group(): String {
        return ""
    }

    func group(group: Int32): String {
        return ""
    }

    func group(name: String): String {
        return ""
    }

    func find(): Bool {
        return false
    }

    func find(start: Int32): Bool {
        return false
    }

    // Methods End
}

public open class JavaUtilRegexMatcherStub <: JavaUtilRegexMatcher {
    public init() {}
}

public interface JavaUtilRegexPattern {
    // Methods Begin
    // Methods End
}

public open class JavaUtilRegexPatternStub <: JavaUtilRegexPattern {
    public init() {}
}
