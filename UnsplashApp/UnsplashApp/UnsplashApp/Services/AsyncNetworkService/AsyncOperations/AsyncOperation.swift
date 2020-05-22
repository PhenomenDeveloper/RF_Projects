//
//  AsyncOperation.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    
    ///Состояния операции
    public enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    //Изменения состояний операции
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    
    ///Готова ли операция к запуску
    override open var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    ///Выполняется ли операция
    override open var isExecuting: Bool {
        return state == .executing
    }
    
    ///Закончено ли выполнение операции
    override open var isFinished: Bool {
        return state == .finished
    }
    
    ///Является ли операция конкурентной
    override open var isAsynchronous: Bool {
        return true
    }
    
    override open func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
    
    open override func cancel() {
        super.cancel()
        state = .finished
    }
}
