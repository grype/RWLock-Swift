# RWLock

Swift wrapper around pthread_rwlock.

See [Read-Write Lock](https://en.wikipedia.org/wiki/Readers–writer_lock) for details.

Usage:

```swift
let lock = RWLock()
lock.readProtected {
    // do something concurrently with other reads and until write lock is acquired 
}
lock.writeProtected {
    // do something that requires exclusive access
}
```

Using propety wrapper:

```swift
class Foo {
    @RWLocked var items = [Any]()
    
    func add(_ item: Any) {
        items.append(item)
    }
    
    func removeAll() {
        items.removeAll()
    }
    
    func iterate() {
        items.forEach { 
            // do something with each item
        }
    }
    
}
```

Any modifications to `items` array will require write protection - this applies to methods `add(_:)` and `removeAll()`. In contrast, `iterate()`ing over the array requires read access. This means that you won't be able to `add(_:)` or `removeAll()` until iteration is complete, and you won't be able to `iterate()` until `add(_:)` or `removeAll()` had finished. 
