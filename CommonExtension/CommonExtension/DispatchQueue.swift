import Foundation

public func delay(_ sec: Double, execute:@escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: (.now() + sec), execute: execute)
}

public func onMainThread(execute:@escaping () -> Void) {
    DispatchQueue.main.async(execute: execute)
}
