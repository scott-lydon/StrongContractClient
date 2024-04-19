//
//  File.swift
//  
//
//  Created by Scott Lydon on 4/7/24.
//

#if canImport(NIO)
import Foundation
import NIO


extension ByteBuffer {
    public var data: Data { .init(buffer: self) }
}
#endif
