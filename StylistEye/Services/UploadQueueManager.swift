//
//  UploadQueueManager.swift
//  StylistEye
//
//  Created by Martin Stachon on 07.06.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher
import UIKit

// TODO a smarter way to extend NetworkExecutable with constrained generic or something
protocol UploadQueueItem {
  
  func executeQueueItem(handler: @escaping ((Bool, UploadPhotoResponseDTO?) -> Void) )
  
  var image: UIImage { get }
  
  var imageData: Foundation.Data { get }
  
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
  
  // this must be larger than Alamofire timeout
  static let timeout = 2*60
  
  fileprivate init() {
  }
  
  public func push(item: UploadQueueItem, atTop: Bool = false) {
    
    let operation = BlockOperation {
      print("Starting upload. In queue: \(self.queue.operationCount)")
      let s = DispatchSemaphore(value: 0)
      item.executeQueueItem() {
        success, photo in
        // do stuff with the response.
        
        if success {
          print("Upload successfull")
          
          if let imagePath = photo?.photo?.image {
            // save photo in cache
            ImageCache.default.store(item.image, original: item.imageData, forKey: imagePath)
          }
          
        } else {
          // reschedule
          print("Upload failed - rescheduling")
          self.push(item: item, atTop: true)
        }
        
        s.signal()
      }
      
      // the timeout here is really an extra safety measure – the request itself should time out and end up firing the completion handler.
      let result = s.wait(timeout: .now() + .seconds(UploadQueueManager.timeout+10))
      switch result {
      case .success:
        print("dispatch success")
      case .timedOut:
        print("dispatch timeout")
        self.push(item: item, atTop: true)
      }
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
    print("Upload enqueued. In queue: \(self.queue.operationCount)")
  }
  
}
