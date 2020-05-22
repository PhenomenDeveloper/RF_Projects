import Foundation

/*
 Реализовать потокобезопасный словарь.
 1. Предусмотреть возможность чтения из нескольких потоков.
 2. Получение элемента по ключу (a["key"])
 3. Установка значения по ключу (a["key"] = 10)
 4. Получение всех ключей (allKeys)
 5. Получение всех значений (allValues)
 6. Удаление элемента по ключу (removeValue(forKey:))
 */

class ThreadSafeDictionary<String: Hashable, Value> {
    
    private var items: [String: Value] = [:]
    
    private var queue: DispatchQueue = DispatchQueue(label: "ThreadSafeDictionaryQueue", attributes: .concurrent)
    
    public var count: Int {
        queue.sync {
            return items.count
        }
    }
    
    public subscript(key: String) -> Value? {
        
        get {
            queue.sync {
                return items[key]
            }
        }
        
        set {
            queue.async(flags: .barrier) {
                self.items[key] = newValue
            }
        }
    }
    
    public func getAllKeys() -> [String]? {
        queue.sync(flags: .barrier) {
            return items.map {$0.key}
        }
    }
    
    public func getAllValues() -> [Value]? {
        queue.sync(flags: .barrier) {
            return items.map {$0.value}
        }
    }
    
    public func removeValueForKey(key: String) {
        queue.async(flags: .barrier) {
            self.items.removeValue(forKey: key)
        }
    }
}

var threadDict = ThreadSafeDictionary<String, Int>()

DispatchQueue.concurrentPerform(iterations: 100) { (i) in
    threadDict["\(i)"] = i
}

print("Элементов после добавления - \(threadDict.count) шт.")
threadDict.getAllKeys()
threadDict.getAllValues()

DispatchQueue.concurrentPerform(iterations: 90) { (i) in
    threadDict.removeValueForKey(key: "\(i)")
}

print("Элементов после удаления - \(threadDict.count) шт.")

if let elements = threadDict.getAllValues() {
    print("Оставшиеся элементы - \(elements)")
}



