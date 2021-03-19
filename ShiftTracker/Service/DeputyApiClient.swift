//
//  DeputyApiClient.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import Foundation

class DeputyApiClient {
    
    enum Endpoints {
        case shiftStart
        case shiftEnd
        case previousShifts
        
        var stringValue: String {
            switch self {
            case .shiftStart:
                return Constants.Url_Base + Constants.Url_Shift_Start
            case .shiftEnd:
                return Constants.Url_Base + Constants.Url_Shift_End
            case .previousShifts:
                return Constants.Url_Previus_Shifts
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func requestForPostShift(shiftUrl: URL, shift: Shift, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let bodyText = shift.createJsonData()
       
        taskForPOSTRequest(url: shiftUrl, responseType: String.self, body: bodyText){ response, error in
            
            if let response = response {
                if response == Constants.Message_Shift_Started || response == Constants.Message_Shift_Ended {
                    completionHandler(true, nil)
                }
            } else {
                print("=========  POST Request Error ===========")
                print(error as Any)
                completionHandler(false, error)
            }
        }
    }
    
    // HTTP Request Methods
  
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
              DispatchQueue.main.async {
                  completion(nil, error)
              }
              return
            }
          
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        print(responseObject)
                        completion(responseObject, nil)
                    }
            } catch {
                  do {
                      let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                      DispatchQueue.main.async {
                          print(errorResponse)
                          completion(nil, errorResponse)
                      }
                  } catch {
                      DispatchQueue.main.async {
                          print(error)
                          completion(nil, error)
                      }
                  }
            }
        }
        task.resume()
      
        return task
        
    }
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        request.addValue(Constants.Header_Content_Type, forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.Header_Authorization, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        print(errorResponse)
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print(error)
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
