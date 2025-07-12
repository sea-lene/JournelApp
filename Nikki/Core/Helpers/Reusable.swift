//
//  Reusable.swift
//  Nikki
//
//  Created by Suhanee on 07/04/25.
//

import Foundation
import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
