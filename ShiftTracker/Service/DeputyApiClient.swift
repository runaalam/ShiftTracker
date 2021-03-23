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
                return Constants.Url_Base + Constants.Url_Shift_Start
            case .shiftEnd:
                return Constants.Url_Base + Constants.Url_Shift_End
            case .previousShifts:
                return Constants.Url_Base + Constants.Url_Previus_Shifts
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
    
    ///Service method to get all previous shift records
    class func requestForGetPreviusShifts(completionHandler: @escaping ( _ previuosShifts:[ShiftRecordViewModel]?,_ error: Error?) -> Void) {
        let url = Endpoints.previousShifts.url
        let bodyText = ""
        var displayShiftList : [ShiftRecordViewModel] = []
        taskForRequest(url: url, httpMethod: HTTPMethod.get.rawValue, responseType: PreviousShifts.self, body: bodyText, completion: {responseData, error in
            if let shifts = responseData {
                for shift in shifts {
                    let displayShift = ShiftRecordViewModel(id: shift.id, url: URL(string: shift.image)!, date: shift.start, start: shift.start, end: shift.end)
                    displayShiftList.append(displayShift)
                }
            }
            completionHandler(displayShiftList, error)
        })
    }
    
    /// Generic HTTP Request Methods that works for Get and Post request
    class func taskForRequest<ResponseType: Decodable>(url: URL, httpMethod: String, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
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

            do {
                let responseObject = try JSONDecoder().decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    print("========== 1 ============")
                    print(responseObject)
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        print("=========== 2 ===========")
                        print(errorResponse)
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("=========== 3 ===========")
                        print(error)
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
