//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/7/24.
//

import Foundation
#if canImport(NIO)
import NIO


extension ByteBuffer {
    var data: Data { .init(buffer: self) }
}
#endif
