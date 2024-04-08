//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/7/24.
//

import Foundation
import NIO

extension ByteBuffer {
    var data: Data { .init(buffer: self) }
}
