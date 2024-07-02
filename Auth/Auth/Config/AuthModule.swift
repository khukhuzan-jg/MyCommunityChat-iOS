//
//  AuthModule.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import Foundation

public extension Bundle {
    static var authBundle: Bundle {
        Bundle(for: AuthModule.self)
    }
}

public class AuthModule {
    public func awake() {}
}
