//
//  RWLock.swift
//  
//
//  Created by Pavel Skaldin on 4/8/21.
//

import Foundation

/**
 I am a wrapper around pthread_rwlock.
 
 Kindly borrowed from @jamone via https://stackoverflow.com/questions/24157834/are-swift-variables-atomic
 */
public class RWLock {
    private var rwLock = pthread_rwlock_t()

    public init() {
        guard pthread_rwlock_init(&rwLock, nil) == 0 else {
            preconditionFailure("Unable to initialize RWLock")
        }
    }

    deinit {
        pthread_rwlock_destroy(&rwLock)
    }

    public func writeLock() {
        pthread_rwlock_wrlock(&rwLock)
    }
    
    public func tryWriteLock() {
        pthread_rwlock_trywrlock(&rwLock)
    }

    public func readLock() {
        pthread_rwlock_rdlock(&rwLock)
    }
    
    public func tryReadLock() {
        pthread_rwlock_tryrdlock(&rwLock)
    }

    public func unlock() {
        pthread_rwlock_unlock(&rwLock)
    }
    
    public func readProtected(_ aBlock: ()->Void) {
        readLock()
        defer { unlock() }
        aBlock()
    }
    
    public func writeProtected(_ aBlock: ()->Void) {
        writeLock()
        defer { unlock() }
        aBlock()
    }
    
}
