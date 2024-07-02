import UIKit

public extension URL {
    
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
    
    var queryParameters: QueryParameters {
        return QueryParameters(url: self)
    }
    
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }

    mutating func excludeFromBackup() throws {
        var resource = URLResourceValues()
        resource.isExcludedFromBackup = true
        try setResourceValues(resource)
    }
    
    func toMBFileSize(descimalCount: Int) -> Double {
        if let resources = try? self.resourceValues(forKeys: [.fileSizeKey]) {
            return (Double(resources.fileSize ?? 0) / 1000000).rounded(descimalCount: descimalCount)
        } else {
            return 0
        }
    }
    
    func getFileSize() -> Double {
        let data = try? Data(contentsOf: self)
        return data?.getMBSize.toDouble.orElse(0) ?? 0
    }
    
    func isGIF() -> Bool {
        return self.absoluteString.hasSuffix("GIF") ||  self.absoluteString.hasSuffix("gif")
    }
    
    func toJPEGDataIfIsImage(compressionQuality: CGFloat = 1) -> Data? {
        guard let type = FileType(from: self) else { return nil }
        switch type {
        case .image:
            let data = try? Data(contentsOf: self)
            return data.flatMap(UIImage.init).flatMap {
                $0.jpegData(compressionQuality: compressionQuality)
            }
        case .gif:
            return try? Data(contentsOf: self)
        case .pdf:
            return try? Data(contentsOf: self)
        }
    }

}

public class QueryParameters {
    public let queryItems: [URLQueryItem]
    public init(url: URL?) {
        queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems ?? []
        print(queryItems)
    }
    public subscript(name: String) -> String? {
        return queryItems.first(where: { $0.name == name })?.value
    }
}
