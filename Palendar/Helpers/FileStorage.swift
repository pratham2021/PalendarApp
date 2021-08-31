//
//  FileStorage.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/15/21.
//

import Foundation
import FirebaseStorage
import Firebase
import JGProgressHUD

class FileStorage {
    
    let storage = Storage.storage()
    
    func uploadImage(_ image:UIImage, directory:String, completion: @escaping (_ documentLink:String?) -> Void) {
        
        let storageRef = storage.reference(forURL: "gs://palendar-d3cc8.appspot.com").child(directory)
        
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        var task:StorageUploadTask!
        
        // Storing the image into the directory we specified.
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
            
            task.removeAllObservers()
            
            if error != nil {
                print("error uploading image to firebase storage: \(error!.localizedDescription)")
                return
            }
            else {
                // Getting a download url
                storageRef.downloadURL { (url, error) in
                
                    guard let downloadUrl = url else {
                        completion(nil)
                        return
                    }
                    
                    completion(downloadUrl.absoluteString)
                }
            }
        })
        
        task.observe(.progress) { (snapshot) in
            
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            
            print(progress)
        }
    }
    
    func downloadImage(imageUrl:String, completion: @escaping (_ image:UIImage?) -> Void) {
        let globalFunctions = GlobalFunctions()
        let imageFileName = globalFunctions.fileNameFrom(fileUrl: imageUrl)
        
        if fileExistsAtPath(path: imageFileName) {
            // It is saved on the device
            
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                completion(contentsOfFile)
            }
            else {
                completion(UIImage(named: "avatar")!)
            }
        }
        else {
            // Download from Firebase
            
            if imageUrl != "" {
                
                let documentURL = URL(string: imageUrl)
                
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: documentURL!)
                    
                    if data != nil {
                        // Save locally
                        FileStorage().saveFileLocally(fileData: data!, fileName: imageFileName)
                        
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data)!)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
                
            }
        }
    }
    
    func saveFileLocally(fileData:NSData, fileName:String) {
        let docURL = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docURL, atomically: true)
    }
    
    func fileInDocumentsDirectory(fileName:String) -> String {
        return getDocumentsURL().appendingPathComponent(fileName).path
    }
    
    func getDocumentsURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func fileExistsAtPath(path:String) -> Bool {
        return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
    }
}
