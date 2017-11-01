//
//  JSONAPIProvider.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import Foundation
import Moya
import Result

typealias ServiceResult<Object> = Result<Object, DataError>
typealias ServiceCompletion<Object> = ((ServiceResult<Object>) -> Void)

// This provider automatically serializes response to a format suitable for mapping with ObjectMapper
class JSONAPIProvider<Target: JSONAPITargetType>: MoyaProvider<Target> {
  typealias JSONAPIResult = Result<JSONAPIResponse, DataError>
  typealias JSONAPICompletion = (_ result: JSONAPIResult) -> Void

  let networkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { state in
    switch state {
    case .began:
      NetworkActivityIndicator.sharedIndicator.visible = true
    case .ended:
      NetworkActivityIndicator.sharedIndicator.visible = false
    }
  })

  // This function returns serialized response
  @discardableResult
  func callAPI(_ target: Target, completion: @escaping JSONAPICompletion) -> Cancellable {
    debugPrint("JSON API Started request to path: \(target.path), method: \(target.method)")

    return self.request(target, queue: nil) { result in
      DispatchQueue(label: "Parsing").async {
        switch result {
        case .success(let response):
          let jsonAPIResponse = JSONAPIResponse(response)
          DispatchQueue.main.async {
            if let login = jsonAPIResponse.login {
              ProfileService.instance.validateLoginResponseData(data: login)
            }
            if let error = jsonAPIResponse.error {
              return completion(.failure(error))
            } else {
              return completion(.success(jsonAPIResponse))
            }
          }
        case .failure(let error):
          DispatchQueue.main.async {
            debugPrint("Moya finished with error: \(error.errorDescription ?? "")")
            return completion(.failure(.moyaError(error)))
          }
        }
      }
    }
  }

  // Override Moya provider initialization(append BearerTokenPlugin)
  override init(
    endpointClosure: @escaping JSONAPIProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
    requestClosure: @escaping JSONAPIProvider<Target>.RequestClosure = MoyaProvider.defaultRequestMapping,
    stubClosure: @escaping JSONAPIProvider<Target>.StubClosure = MoyaProvider.neverStub,
    manager: Manager = JSONAPIProvider<Target>.defaultAlamofireManager(),
    plugins: [PluginType] = [],
    trackInflights: Bool = false
    ) {
    var plugins = plugins
    plugins.append(networkActivityPlugin)
    plugins.append(NetworkLoggerPlugin(verbose: true))
    super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)

  }

}
