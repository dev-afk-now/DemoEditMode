//
//  Debouncer.swift
//  DemoEditMode
//
//  Created by Nik Dub on 24.07.2024.
//

import Foundation

class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    
    init(delay: TimeInterval = 0.5, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }
 func debounce(action: @escaping (() -> Void)) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            action()
            self?.workItem = nil
        }
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
