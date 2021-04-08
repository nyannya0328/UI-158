//
//  DownLoadTaskModel.swift
//  UI-158
//
//  Created by にゃんにゃん丸 on 2021/04/08.
//

import SwiftUI

class DownLoadTaskModel: NSObject, ObservableObject,URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate {
  
    
    
    @Published var url : URL!
    
    @Published var alertMsg = ""
    @Published var showAlert = false
    
    @Published var downLoadProgress : CGFloat = 0
    
    @Published var downloadTaskSession : URLSessionDownloadTask!
    
    
    @Published var showDownloadProsess = false
    
    func startDownload(urlstring : String){
        
        guard let vaildURL = URL(string: urlstring) else {
            self.reportError(error: "Invailed Error")
            
            return
        }
        
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if FileManager.default.fileExists(atPath: directoryPath.appendingPathComponent(vaildURL.lastPathComponent).path){
            
            print("Yes Found")
            let controller = UIDocumentInteractionController(url: directoryPath.appendingPathComponent(vaildURL.lastPathComponent))
            
            controller.delegate = self
            controller.presentPreview(animated: true)
            
        }
        
        else{
            
            print("No file found")
            
            downLoadProgress = 0
            
            withAnimation{showDownloadProsess = true}
            
            let session = URLSession(configuration: .default,delegate: self,delegateQueue: nil)
            downloadTaskSession = session.downloadTask(with: vaildURL)
            downloadTaskSession.resume()
        }
        
        
        
       
        
        
    }
    
    func reportError(error : String){
        
        alertMsg = error
        showAlert.toggle()
        
        
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let url = downloadTask.originalRequest?.url else {
            
            DispatchQueue.main.async {
                self.reportError(error: "Something what wrong place try again later")
            }
            
            return
        }
        
        let directroyPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let destinationURL = directroyPath.appendingPathComponent(url.lastPathComponent)
        
        try? FileManager.default.removeItem(at: destinationURL)
        
        do{
            
            try FileManager.default.copyItem(at: location, to: destinationURL)
            
            DispatchQueue.main.async {
                withAnimation{self.showDownloadProsess = false}
                
                let controller = UIDocumentInteractionController(url: destinationURL)
                
                controller.delegate = self
                controller.presentPreview(animated: true)
            }
            
            
        }
        
        catch{
            
            DispatchQueue.main.async {
                self.reportError(error: "Pleace try again later")
            }
        }
        
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        
        
        DispatchQueue.main.async {

            self.downLoadProgress = progress
        }

    }
    
    func cancelTask(){
        
        if let task = downloadTaskSession,task.state == .running{
            
            downloadTaskSession.cancel()
            withAnimation{
                
                self.showDownloadProsess = false
            }
        }
        
    }
    
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error{
            
            DispatchQueue.main.async {
                withAnimation{
                    
                    self.showDownloadProsess = false
                    self.reportError(error: error.localizedDescription)
                }
            }
            
        }
    }
   
}

