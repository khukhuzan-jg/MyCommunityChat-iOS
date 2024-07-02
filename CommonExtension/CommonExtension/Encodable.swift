import UIKit

public extension Encodable {
    
    func toDict(_ encoder: JSONEncoder) -> [String: Any] {
        do {
            let data = try encoder.encode(self)
            let dic =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dic ?? [:]
            
        } catch {
            return [:]
        }
    }
    
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }

}

public extension JSONDecoder {
    static var converter: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    static var `default`: JSONDecoder {
        JSONDecoder()
    }
}

public extension JSONEncoder {
    static var converter: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    static var def: JSONEncoder {
        JSONEncoder()
    }
}

public func toJSONString<T: Encodable>(_ encodable: T) -> String? {
    let encData = try? JSONEncoder().encode(encodable)
    return encData.flatMap { String(data: $0, encoding: .utf8) }
}

public func toBase64DataString(_ image: UIImage?) -> String? {
    image.flatMap { $0.pngData()?.base64EncodedString() }
}

public func toBase64DataStringFromJPEG(_ image: UIImage?) -> String? {
    image.flatMap { $0.jpegData(compressionQuality: 1)?.base64EncodedString() }
}
