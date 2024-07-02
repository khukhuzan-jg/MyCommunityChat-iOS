import Foundation

public extension Dictionary {
    mutating func swap(key1: Key, key2: Key) {
        if  let value = self[key1], let existingValue = self[key2] {
            self[key1] = existingValue
            self[key2] = value
        }
    }
}

public enum AnyValue: Decodable {

    case int(Int), string(String), double(Double), bool(Bool)

    public init(from decoder: Decoder) throws {
        
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        
        if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(bool)
            return
        }

        throw AnyValueError.missingValue
    }

    enum AnyValueError:Error {
        case missingValue
    }
}
