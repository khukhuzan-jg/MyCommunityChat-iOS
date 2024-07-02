import UIKit
import MobileCoreServices

public enum FileType {
    case image
    case gif
    case pdf
    
    public init?(from url: URL) {
        let fileExtension = url.pathExtension as CFString
        let fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)
        guard let uti = fileUTI?.takeRetainedValue() else {
            return nil
        }
        
        if UTTypeConformsTo(uti, kUTTypeGIF) {
            self = .gif
        } else if UTTypeConformsTo(uti, kUTTypeImage) {
            self = .image
        } else if UTTypeConformsTo(uti, kUTTypePDF) {
            self = .pdf
        } else {
            return nil
        }
    }
}

public extension FileManager {
    
    func searchImageNPDF(at url: URL = FileManager.default.temporaryDirectory) -> [URL] {
        
        var files = [URL]()
        if let enumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    
                    if fileAttributes.isRegularFile!, FileType(from: fileURL) != nil {
                        files.append(fileURL)
                        
                    }
                } catch { print(error, fileURL) }
            }
            print(files.map { $0.localizedName })
        }
        return files
    }
    
    func deleteImageNPDFIfPresentInTempDir() {
        let files = searchImageNPDF()
        files.forEach { try? removeItem(at: $0) }
    }
    
    func deleteImageNPDFIfPresentInTempDir(_ urls: [URL]) {
        let files = searchImageNPDF()
    
        let datas = urls.compactMap { try? Data(contentsOf: $0) }
        
        files.forEach {
            if let fileData = try? Data(contentsOf: $0), datas.contains(fileData) {
                try? removeItem(at: $0)
                print("deleted ", $0.localizedName ?? "")
            }
        }
    }
}
