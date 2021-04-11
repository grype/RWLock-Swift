//
//  RWLockedPropertyWrapper.swift
//  
//
//  Created by Pavel Skaldin on 4/8/21.
//

import Foundation

/**
 I am a property wrapper that holds its value behind a RWLock
 
 Kindly borrowed from @jamone via https://stackoverflow.com/questions/24157834/are-swift-variables-atomic
 */
@propertyWrapper
public class RWLocked<Value> {

    private var value: Value
    
    private let lock = RWLock()

    public init(wrappedValue aValue: Value) {
        value = aValue
    }

    public var wrappedValue: Value {
        get {
            lock.readLock()
            defer { lock.unlock() }
            return value
        }
        set {
            lock.writeLock()
            defer { lock.unlock() }
            value = newValue
        }
    }
    
    public func mutate(_ closure: (inout Value) -> Void) {
        lock.writeLock()
        closure(&value)
        lock.unlock()
    }
}
