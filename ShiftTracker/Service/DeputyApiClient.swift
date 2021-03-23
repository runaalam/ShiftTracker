//
//  DeputyApiClient.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import Foundation

class DeputyApiClient {
    
    ///URL Endpoint
    enum Endpoints {
        case shiftStart
        case shiftEnd
        case previousShifts
        
        var stringValue: String {
            switch self {
            case .shiftStart:
                return Constants.URL_BASE + Constants.URL_SHIFT_START
            case .shiftEnd:
                return Constants.URL_BASE + Constants.URL_SHIFT_END
            case .previousShifts:
                return Constants.URL_BASE + Constants.URL_PREVIOUS_SHIFTS
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    ///Methods Used in Deputy Api
    enum HTTPMethod: String {
          case get = "GET"
          case post = "POST"
    }
    
    ///Service method for shift post that communicate generic HTTP Request Method for Deputy Api
    class func requestForPostShift(shiftUrl: URL, shift: Shift, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let bodyText = shift.createJsonData()
       
        taskForRequest(url: shiftUrl, httpMethod: HTTPMethod.post.rawValue, responseType: String.self, body: bodyText){ response, error in
            
            if let response = response {
                if response == Constants.MESSAGE_SHIFT_STARTED || response == Constants.MESSAGE_SHIFT_ENDED {
                    completionHandler(true, nil)
                }
            } else {
                print("=========  POST Request Error ===========")
                print(error as Any)
                completionHandler(false, error)
            }
        }
    }
    
    ///Service method to get all previous shift records
    class func requestForGetPreviusShifts(completionHandler: @escaping ( _ previuosShifts:[ShiftRecord]?,_ error: Error?) -> Void) {
        let url = Endpoints.previousShifts.url
        let bodyText = ""
       
        taskForRequest(url: url, httpMethod: HTTPMethod.get.rawValue, responseType: PreviousShifts.self, body: bodyText, completion: {responseData, error in
            if let shifts = responseData {
                completionHandler(shifts, error)
            } else {
                completionHandler([], error)
            }
            
        })
    }
    
    /// Generic HTTP Request Method that works for Get and Post request
    class func taskForRequest<ResponseType: Decodable>(url: URL, httpMethod: String, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = body.data(using: .utf8)
        request.addValue(Constants.HEADER_CONTENT_TYPE, forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.HEADER_AUTHORISATION, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        print("=========== Decoding error ===========")
                        print(errorResponse)
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("=========== Error ===========")
                        print(error)
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
