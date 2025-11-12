//
//  CaptureAPI.swift
//
//
//  Created by Mitch Flindell on 28/6/2023.
//

import Alamofire
import Foundation
import OrttoSDKCore

struct CaptureAPI {
    static func fetchWidgets(_ body: WidgetsGetRequest, completion: @escaping (WidgetsResponse) -> Void) {
        guard let url = URL(string: "\(Ortto.shared.apiEndpoint!)/-/widgets/get") else { return }

        Ortto.log().debug("WebViewController@fetchWidgets.url: \(url)")

        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json"),
        ]

        let dateFormatter = DateFormatter()
        // date format example: 2023-07-17T15:30:00.652Z
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: WidgetsResponse.self, decoder: decoder) { response in
        switch response.result {
        case .success(let widgetsResponse):
            completion(widgetsResponse)

        case .failure(let error):
            let status = "\(response.response?.statusCode ?? -1)"
            let bodyString: String = {
                guard let data = response.data, !data.isEmpty else { return "<empty>" }
                return String(data: data, encoding: .utf8) ?? "<non-utf8 body: \(data.count) bytes>"
            }()
            let urlString = response.request?.url?.absoluteString ?? "<unknown url>"
            print("❌ Widgets request failed")
            print("URL: \(urlString)")
            print("Status: \(status)")
            print("Error: \(error)")                  // AFError with full context
            print("Body: \(bodyString)")

            completion(WidgetsResponse.default)
            }
                                                                           }
    }
}
