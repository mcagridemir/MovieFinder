//
//  ServiceConnector.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Alamofire
import Moya

enum Services {
    case Get(UrlPrefix: String? = nil, page: Int? = nil)
}

class ServiceConnector: NSObject {
    
    static let shared = ServiceConnector()
    let connectivityGroup = DispatchGroup()
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    let endpointClosure = { (target: Services) -> Endpoint in
        
        print("baseURL:\(target.baseURL)\n path:\(target.path)")
        
        var url = "\(target.baseURL.absoluteString)\(target.path)"
        
        print("url:\(url)")
        
        let endpoint = Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        return endpoint.adding(newHTTPHeaderFields: [:])
    }
    
    func connect(_ target: Services) {
        self.connect(target, success: nil)
    }
    
    func connect(_ target: Services, success: ((_ target: Services, _ response: String) -> Void)?) {
        self.connect(target, success: success, error: nil)
    }
    
    func connect(_ target: Services, success: ((_ target: Services, _ response: String) -> Void)?, error: ((_ target: Services, _ error: MoyaError) -> Void)?) {
        
        let manager = ServerTrustManager(allHostsMustBeEvaluated: false,
                                         evaluators: [Globals.shared.BaseWebserviceUrl: DisabledTrustEvaluator()])
        
        let configuration = URLSessionConfiguration.af.default
        
        let session = Session(configuration: configuration, serverTrustManager: manager)
        
        var providerPlugin: [PluginType] = []
        providerPlugin = [NetworkLoggerPlugin()]
        configuration.timeoutIntervalForRequest = 10
        
        let provider = MoyaProvider<Services>(endpointClosure: endpointClosure, session: session, plugins: providerPlugin)
        
        let check = NetworkReachabilityManager(host: "https://www.google.com")
        if !(check?.isReachable ?? false) {
            connectivityGroup.enter()
        }
        
        connectivityGroup.notify(queue: .main) {
            provider.request(target) { result in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch result {
                case let .success(moyaResponse):
                    
                    let dataString = String(data: moyaResponse.data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    
                    if let ds = dataString {
                        if let body = moyaResponse.request?.httpBody {
                            let bodyString = String(decoding: body, as: UTF8.self)
                            print("[Request Body]: \(bodyString)")
                        }
                        print("[Request Header]: \(moyaResponse.request?.headers.dictionary)")
                        print("Response : ", ds)
                        
                        if let body = moyaResponse.request?.httpBody {
                            let bodyString = String(decoding: body, as: UTF8.self)
                            print("[Request Body]: \(bodyString)")
                        }
                        
                        let _ = moyaResponse.response!.allHeaderFields
                        
                        switch target {
                        default:
                            break
                        }
                        
                        if let s = success {
                            s(target, ds)
                        }
                    }
                    
                case let .failure(err):
                    print("Error : ", err.errorDescription!)
                    
                    Alert.warning(title: "", text: err.errorDescription ?? "Request Error")
                    
                    if err.errorDescription?.contains("offline") ?? false {
                        
                    }
                    if let e = error {
                        e(target, err)
                    }
                }
                
            }
        }
    }
}

extension Services: TargetType {
    var baseURL: URL {
        return URL(string: Globals.shared.BaseWebserviceUrl)!
    }

    var path: String {
        switch self {
        case let .Get(UrlPrefix, page):
            let urlPrefix = UrlPrefix?.filter {!$0.isWhitespace}
            if let page = page {
                return "?apikey=\(Globals.shared.apiKey)&s=\(urlPrefix ?? "")&page=\(page)"
            }
            return "?apikey=\(Globals.shared.apiKey)&i=\(urlPrefix ?? "")"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        switch self {
        case .Get(_, _):
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["accept": "text/plain"]
    }
}
