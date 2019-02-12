//  
// Copyright (c) 2018 Loverde Co.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
 

import Foundation

public extension FileManager {

    public func createDirectory(_ directoryName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent(directoryName)
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
            return filePath
        } else {
            return nil
        }
    }

    public func saveFileToDirectory( _ sourceURL: URL, toPathURL: URL ) -> Bool {

        do {
            try FileManager.default.moveItem(at: sourceURL, to: toPathURL)
            return true
        } catch let error as NSError {
            print("Erro ao salvar o arquivo: \(error.localizedDescription)")
            return false
        }
    }

    #if os(iOS) || os(macOS)
    public func saveImageToDirectory( _ imageWithPath : String, imagem : UIImage ) -> Bool {

        let data = UIImagePNGRepresentation(imagem)

        let success = (try? data!.write(to: URL(fileURLWithPath: imageWithPath), options: [])) != nil

        //let success = NSFileManager.defaultManager().createFileAtPath(imageWithPath, contents: data, attributes: nil)

        if success {
            return true
        } else {
            NSLog("Unable to create directory")
            return false
        }
    }
    #endif

    public func retrieveFile( _ directoryAndFile: String ) -> URL {
        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent(directoryAndFile)
        return logsPath
    }

    public func removeFile( _ directoryAndFile: String ) -> Bool {
        do {
            try self.removeItem(atPath: directoryAndFile)
            return true
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
            return false
        }
    }

    public func retrieveAllFilesFromDirectory(directoryName: String) -> [String]? {
        let fileMngr = FileManager.default;
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        do {
            var filelist = try fileMngr.contentsOfDirectory(atPath: "\(docs)/\(directoryName)")
            if filelist.contains(".DS_Store") {
                filelist.remove(at: filelist.index(of: ".DS_Store")!)
            }
            return filelist
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return nil
        }
        //        let fileMngr = FileManager.default;
        //
        //        // Full path to documents directory
        //        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        //
        //        let final = try? fileMngr.contentsOfDirectory(atPath:docs)
        //        print(final!.debugDescription)
        //
        //
        //        // List all contents of directory and return as [String] OR nil if failed
        //        return try? fileMngr.contentsOfDirectory(atPath:"\(docs)/\(directoryName)")
    }

    public func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    public func convertToURL(path:String)-> URL?{
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        do {
            _ = try FileManager.default.contentsOfDirectory(atPath: "\(docs)/\(path)")
            return URL(fileURLWithPath: "\(docs)/\(path)", isDirectory: true)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
