//
//  API.swift
//  FlickrSearch
//
//  Created by Sidney de Koning on 07/09/2017.
//  Copyright © 2017 Sidney de Koning. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

enum APIError: String, Error {
    case noEndpoint = "Incorrect endpoint"
    case noData = "ERROR: no data"
    case jsonConversionFailed = "ERROR: conversion from JSON failed"
}

public enum Result<T> {
    case success(T)
    case error(Error)
}

public protocol API {
    associatedtype DecodableType: Decodable
    var host: URL? { get }
    var endPoint: Endpoint { get }
    var method: HTTPMethod { get }
	var headers: [String: String]? { get }
}

extension API {
    
    func call(completion: @escaping (Result<DecodableType>) -> ()) throws {
        
        guard let url: URL = self.url(self.endPoint) else {
            throw APIError.noEndpoint
        }

		print(url.absoluteString)
        
        var request: URLRequest = URLRequest(url: url as URL)
        request.httpMethod = method.rawValue

		if let headers = self.headers {
			for (field, value) in headers {
                
				request.setValue(value, forHTTPHeaderField: field)
			}
		}
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

			if let data = data {
				let jsonString = String(data: data, encoding: .utf8)
				self.debugInformation(response: response, responseString: jsonString)
			}

            do {
				guard let data = data else {
					throw APIError.noData
				}

                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(DecodableType.self, from: data)

                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error as APIError {
                print(error.rawValue)
                
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            } catch let error as NSError {
                print("failed to convert data \(error)")
                print(error.debugDescription)
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Helper method to convert enpoint to URL to call
    fileprivate func url(_ route: Endpoint) -> URL? {
        let clean = self.host?.appendingPathComponent(route.path).absoluteString.replacingOccurrences(of: "%3F", with: "?")
        return URL(string: clean ?? "")
    }
    
    // MARK: - Print debug information to the screen about request and response
    func debugInformation(request: URLRequest?) {
        
//        debugPrint("=> \(self.endpoint.path) - \(self.method) - \(self.endpoint.baseURL.absoluteString)")
//
//        if let parameters = self.parameters {
//            debugPrint("=> \(self.endpoint) - Params: " + parameters.debugDescription)
//        }
//
//        debugPrint("=> \(self.endpoint.path)")
//        debugPrint()
    }
    
    func debugInformation(response: URLResponse?, responseString: String?) {

		guard let url: URL = self.url(self.endPoint) else { return }

        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {

            debugPrint()
            debugPrint("<= \(self.method) - \(url) - Response: \(httpResponse.statusCode)")
            //debugPrint("<= \(url) - Body: " + (responseString ?? ""))
            debugPrint()
        }
    }
}
