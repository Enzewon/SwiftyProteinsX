//
//  Request.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 3/29/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation
import Alamofire

class Request {
    
    var token: String?
    var key: String
    var secret: String
    
    init(withKey key: String, andSecret secret: String) {
        self.key = key
        self.secret = secret
    }
    
    public func basicRequest() {
        
        let bearer = ((self.key + ":" + self.secret).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url! as URL)
        
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials&client_id=\(self.key)&client_secret=\(self.secret)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    self.token = (dic["access_token"] as? String)!
                }
                catch (let error) {
                    print(error)
                }
            }
        }
        
        task.resume()
        
    }
    
    public func getUser(token access_token: String, about user: String, addUser: @escaping ([String: Any]?, Error?) -> Void) {
        
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(user.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)?access_token=\(access_token)")
        let request = URLRequest(url: url! as URL)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        addUser(dic, nil)
                    }
                }
                catch (let error) {
                    print(error)
                }
            }
            addUser(nil, error)
        }
        task.resume()
        
    }
    
    public func downloadLigandPDB(withName name: String, completion: @escaping (String?, Bool) -> Void) {
        
        let urlString = URL(string: "https://files.rcsb.org/ligands/download/\(name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)_ideal.pdb")
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(name).pdb")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if let url = urlString {
            Alamofire.download(url, to: destination).response { response in
                if response.error == nil {
                    if let url = response.destinationURL?.path {
                        do {
                            let data = try String(contentsOfFile: url)
                            if data.range(of: "<title>404 Not Found</title>") != nil {
                                completion(nil, true)
                            } else {
                                completion(data, false)
                            }
                        } catch {
                            print("Unexpected problem")
                        }
                    }
                } else {
                    completion(nil, true)
                }
            }
        }
    }
    
    deinit {
        print("Deinit Request")
    }
    
}
