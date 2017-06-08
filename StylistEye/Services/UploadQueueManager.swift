//
//  UploadQueueManager.swift
//  StylistEye
//
//  Created by Martin Stachon on 07.06.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

// TODO a smarter way to extend NetworkExecutable with constrained generic or something
protocol UploadQueueItem {
  
  func executeQueueItem(handler: @escaping ((Bool) -> Void) )
  
}

class UploadQueueManager {
  
  static let main = UploadQueueManager()
  
  // simple array does not provide optimal performance, but we expect
  // only a few item in the queue
  // not needed in current implementation
  //fileprivate var tasks = [UploadQueueItem]()
  
  fileprivate var queue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  // this must be larger than Alamofire timeout, which is 60 by default
  let timeout = 120
  
  fileprivate init() {
  }
  
  public func push(item: UploadQueueItem, atTop: Bool = false) {
    
    let operation = BlockOperation {
      let s = DispatchSemaphore(value: 0)
      item.executeQueueItem() {
        success in
        // do stuff with the response.
        
        if success {
          print("Upload successfull")
        } else {
          // reschedule
          print("Upload failed - rescheduling")
          self.push(item: item, atTop: true)
        }
        
        s.signal()
      }
      
      // the timeout here is really an extra safety measure – the request itself should time out and end up firing the completion handler.
      _ = s.wait(timeout: .now() + .seconds(self.timeout))
    }
    
    if atTop {
      queue.isSuspended = true
      
      // make other operations depend on this one to ensure it executes first
      for op in queue.operations {
        if !op.isExecuting { // shouldnt be executing anyway
          op.addDependency(operation)
        }
      }
      
      queue.isSuspended = false
    }
    
    queue.addOperation(operation)
    print("Upload enqueued")
  }
  
}
