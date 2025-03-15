//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/29/24.
//

import Foundation
import os

extension String {

    public func logInfo() {
        if #available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *) {
            Logger().info("\(self)")
        } else {
            os_log("%@", type: .info, self)
        }
    }
}
