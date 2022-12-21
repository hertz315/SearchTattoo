//
//  Api.swift
//  SearchTattoo
//
//  Created by Hertz on 12/21/22.
//

import Foundation
import Combine

enum SearchTattooAPI {
    
    static let applicationID = "9odWdyRbmXNg5h0KxUseFDvZUgi1HCSwMNV5hHya"
    static let apiKey = "OsyNPnlFG7xM56EnB5ho7pETiXlYkxhvXbOHw3UU"
    
    // 전처리 컴파일 되기 전에 실행된다
    // MARK: - 전처리
#if DEBUG // 디버그
    static let baseURL = "https://parseapi.back4app.com/classes/Tattooist"
    static let imageString = ".png"
#else // 릴리즈
    static let baseURL = "https://parseapi.back4app.com/classes/Tattooist"
    static let imageString = ".png"
#endif
    
    
    static func fetchTattooShopList() -> AnyPublisher<[TattooShop], ApiError> {
        
        // MARK: - URLRequest 만들기
        // https://parseapi.back4app.com/classes/User
        let urlString = baseURL
        
        // URL 만들기
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowUrl).eraseToAnyPublisher()
        }
        
        // URLRequest생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue(applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // MARK: - URLSession으로 API를 호출하기
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                // 응답값이 HTTPURLResponse 응답값이 없다면 에러던지기
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                // 만약 상태 응답값 코드가 200~299 사이가 아니라면 에러던지기❗️
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }

                return data
            }
            // Data -> 디코드
            .decode(type: Tattooist.self, decoder: JSONDecoder()) // Tattooist
            .compactMap { $0.results } // [TattooShopResponse]?
            // MARK: - 📍이부분이 도저희 이해가 가지 않습니다 어떻게 배열이 리턴되나요?
            .map { $0.map {TattooShop($0)} } // TattooShopResponse -> TattooShop
            // mapError로 에러 타입을 변경한다 ⭐️any Error -> SearchTattooAPI.ApiError⭐️
            .mapError { error -> ApiError in
                // dataTaskPublisher 형태의 에러를 커스텀 Error 타입으로 변경📌
                if let err = error as? ApiError {
                    return err
                }
                // 디코딩할때 발생핤수 있는 에러를 커스텀 Error 타입으로 변경📌
                if error is DecodingError {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
            }
            .eraseToAnyPublisher()
    }
    
    
}


// MARK: - API Error 정의
extension SearchTattooAPI {
    /// API에러타입 정의
    // MARK: - API에러타입 정의
    enum ApiError: Error {
        case passingError
        case noContent
        case notAllowUrl
        case unAuthorized
        case jsonEncodingError
        case decodingError
        case userNotCreated
        case unKnown(_ error: Error?)
        case badStatus(code: Int)
        
        
        // 에러타입 설명 String
        var info: String {
            switch self {
            case .passingError:
                return "파싱에러입니다"
            case .noContent:
                return "컨텐츠가 없는 에러입니다"
            case .unAuthorized:
                return "인증되지 않은 사용자 입니다"
            case .unKnown(let error):
                return "알수 없는 에러 입니다: \(String(describing: error))"
            case .badStatus(code: let code):
                return "상태코드 에러입니다 에러 상태코드 : \(code)"
            case .notAllowUrl:
                return "올바른 url이 아닙니다"
            case .jsonEncodingError:
                return "유효한 Json형식이 아닙니다"
            case .decodingError:
                return "디코딩에러입니다"
            case .userNotCreated:
                return "유저 생성이 안됬습니다(오브젝트 아이디가 없습니다)"
            }
        }
        
    }
}
