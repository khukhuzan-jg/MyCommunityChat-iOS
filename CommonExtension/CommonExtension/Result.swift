import Foundation

public extension Result {
    
    // apply a void function if the value present
    
    func `do`(onSuccess f: (Success) -> Void, onError f2: (Failure) -> Void) -> Result {
        switch self {
        case .success(let value):
            f(value)
        case .failure(let e):
            f2(e)
        }
        return self
    }
    
    func then(_ f: (Success) -> Void) {
        switch self {
        case .success(let value):
            f(value)
        case .failure:
            return
        }
    }
    
    static func pure(_ x: Success) -> Result {
        .success(x)
    }
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var success: Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var failure: Failure? {
        switch self {
        case .success:
            return nil
        case .failure(let e):
            return e
        }
    }
    /*
    func apply<B>(_ f: Result<(Success) -> B, Failure>) -> Result<B, Failure> {
        switch (f, self) {
        case let (.success(fx), _):
            return self.map(fx)
        default: break
        }
    }
    
    static func <*> <B>(_ f: Optional<(Success) -> B>, x: Optional) -> Optional<B> {
        x.apply(f)
    }
     */
    
    func orElse(_ x: Success) -> Success {
        switch self {
        case .failure: return x
        case .success(let v): return v
        }
    }

}

public extension Result where Success == String {
    
    var orEmpty: String {
        switch self {
        case .failure: return ""
        case .success(let v): return v
        }
    }
    

}

public extension Result where Success == Double {
    
    var orEmpty: Double {
        switch self {
        case .failure: return 0
        case .success(let v): return v
        }
    }
}

