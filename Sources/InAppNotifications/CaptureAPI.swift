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
        guard let url = URL(string: "\(Ortto.shared.apiEndpoint!)/widgets/get") else { return }

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
                if let widgetsResponse = try? response.result.get() {
                    completion(widgetsResponse)
                } else {
                    completion(WidgetsResponse.default)
                }
            }
    }
}
