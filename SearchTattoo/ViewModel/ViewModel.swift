//
//  HomeVM.swift
//  SearchTattoo
//
//  Created by Hertz on 12/19/22.
//

// 타투샵 클릭시 지도 이동 로직
// 0. HomeVM -> 선택된
// 1. 홈뷰 -> 어노테이션 아이템 클릭
// 2. 아이템 클릭 -> 선택된 리젼 알기
// 3. region 변경

// 타투 가로 목록 조회 로직
// 1. 정보 가져오기 API
// 2.



import Foundation
import Combine
import CoreLocation
import MapKit
import _MapKit_SwiftUI

class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - MapKit Properties
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5343925,
                                                                              longitude: 126.973326),
                                               span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @Published var trackingMode: MapUserTrackingMode = MapUserTrackingMode.none
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var currentLocation: CLLocation?
    @Published var location: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
 
    
    // MARK: - 타투샵 배열
    @Published var tattooShops : [TattooShop] = []
    
    // MARK: - 디테일 모달 상태
    @Published var isShowContactView: Bool = false
    
    // MARK: - 카카오톡 모달상태
    @Published var isShowKakaSafariView: Bool = false
    
    // MARK: - 인스타그램 모달 상태
    @Published var isInstaSafariView: Bool = false
    
    // MARK: - 찌거기 청소기⭐️
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    override init() {
        super.init()
        //CLLocationManager의 delegate 설정
        locationManager.delegate = self
        //manager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //위치 정보 승인 요청
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        self.fetchTattooShopList()
    }
    
    // MARK: - 타투샵리스트 패치
    func fetchTattooShopList() {
        SearchTattooAPI.fetchTattooShopList()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else  { return }
                switch completion {
                case .finished:
                    print("VM : 패치완료 : 스트림끊킴⭐️")
                case .failure(let failure):
                    self.handleError(failure)
                }
            } receiveValue: { tattooShopList in
                self.tattooShops = tattooShopList
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - 로케이션 상태
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "❗️notDetermined"
        case .authorizedWhenInUse: return "❗️authorizedWhenInUse"
        case .authorizedAlways: return "❗️authorizedAlways"
        case .restricted: return "❗️restricted"
        case .denied: return "❗️denied"
        default: return "❗️unknown"
        }
    }
    
    //위치 정보는 주기적으로 업데이트 되므로 이를 중단하기 위한 함수
    func stopUpdatingLocation() {
        locationManager.stopUpdatingHeading()
    }
    
    //위치 정보가 업데이트 될 때 호출되는 delegate 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        self.currentLocation = firstLocation
        
        self.currentLocation.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
            currentLocation = $0
        }
        
        
        print(#function, firstLocation)
        manager.stopUpdatingLocation()
    }
    
    //위치허용 상태가 변경할시 호출되는 함수
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        
    }
    
    // 에러와 함께 실패할때
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - Helpers
extension ViewModel {
    
    // 첫번째 아이템 인지 여부 확인
    func isFirstItem(_ tattooShopItem: TattooShop) -> Bool {
        guard let firstItem = self.tattooShops.first else { return false }
        return tattooShopItem.id == firstItem.id
    }
    
    // 마지막 아이템 인지 여부 확인
    func isLastItem(_ tattooShopItem: TattooShop) -> Bool {
        guard let lastItem = self.tattooShops.last else {return false }
        return tattooShopItem.id == lastItem.id
    }
    
    // 현재위치 가져오기
    func updateCurrentLocation(){
        /// 사용자가 허용권한을 누리지 않으면 허용권한설정하라고 띄우기
        if self.locationStatus == .denied {
            self.locationManager.requestWhenInUseAuthorization()
        }
        print("⭐️ locationStatus: \(self.statusString)❗️")
        guard let currentLocation = currentLocation else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let updatedMKCoordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        DispatchQueue.main.async {
            self.region = updatedMKCoordinateRegion
        }
    }
    
    // MARK: - API 에러처리
    /// - Parameter err: API 에러
    func handleError(_ err: Error) {
        
        if err is SearchTattooAPI.ApiError {
            let apiError = err as! SearchTattooAPI.ApiError
            
            print("handleError: err \(apiError.info)")
            
            switch apiError {
            case .notAllowUrl:
                print("url 에러")
            case .decodingError:
                print("디코딩 에러")
            case .noContent:
                print("콘텐츠 없음")
            case .passingError:
                print("파싱에러")
            case .unAuthorized:
                print("사용자 인증안됨")
            default:
                print("그밖에 에러")
            }
        }
    }
    
}
