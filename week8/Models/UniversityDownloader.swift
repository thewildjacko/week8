//
//  UniversityDownloader.swift
//  week8
//
//  Created by Jake Smolowe on 7/27/24.
//

import SwiftUI

class UniversityDownloader: NSObject, ObservableObject {
  enum State {
    case paused
    case downloading
    case failed
    case finished
    case waiting
  }
  
  @Published var downloadLocation: URL?
  @Published var downloadProgress: Float = 0
  
  private var downloadURL: URL?
  private var downloadTask: URLSessionDownloadTask?
  
  var state: State = .waiting
  var resumeData: Data?
  
  private lazy var session: URLSession =  {
    let configuration = URLSessionConfiguration.default
    
    return URLSession(configuration: configuration,
                      delegate: self,
                      delegateQueue: nil)
  }()
  
  func downloadUniversities(at url: URL) {
    downloadURL = url
    
    downloadTask = session.downloadTask(with: url)
    downloadTask?.resume()
    
    state = .downloading
  }
  
  func cancel() {
    state = .waiting
    
    downloadTask?.cancel()
    
    Task {
      await MainActor.run {
        downloadProgress = 0
      }
    }
  }
  
  func pause() {
    downloadTask?.cancel(byProducingResumeData: { data in
      Task {
        await MainActor.run {
          self.resumeData = data
          
          self.state = .paused
          self.downloadProgress = self.downloadProgress
        }
      }
    })
  }
  
  func resume() {
    guard let resumeData = resumeData else {
      return
    }
    
    downloadTask = session.downloadTask(withResumeData: resumeData)
    downloadTask?.resume()
    
    state = .downloading
  }
}

extension UniversityDownloader: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession,
                  downloadTask: URLSessionDownloadTask,
                  didWriteData bytesWritten: Int64,
                  totalBytesWritten: Int64,
                  totalBytesExpectedToWrite: Int64) {
    Task {
      await MainActor.run {
        downloadProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
      }
    }
  }
  
  func urlSession(_ session: URLSession, 
                  downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {
    let fileManager = FileManager.default
    
    guard let documentsPath = fileManager.urls(for: .documentDirectory,
                                               in: .userDomainMask).first,
          let lastPathComponent = downloadURL?.lastPathComponent
    else {
      Task {
        await MainActor.run {
          state = .failed
        }
      }
      
      return
    }
    
    let destinationURL = documentsPath.appendingPathComponent(lastPathComponent)
    
    do {
      if fileManager.fileExists(atPath: destinationURL.path) {
        try fileManager.removeItem(at: destinationURL)
      }
      
      try fileManager.copyItem(at: location, to: destinationURL)
      
      Task {
        await MainActor.run {
          downloadLocation = destinationURL
          
          state = .finished
        }
      }
    } catch {
      Task {
        await MainActor.run {
          state = .failed
        }
      }
    }
  }
  
  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  didCompleteWithError error: Error?) {
    Task {
      await MainActor.run {
        if let httpResponse = task.response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
          state = .failed
        }
      }
    }
  }
  
  
}
