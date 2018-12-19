//
//  SpaceViewModel.swift
//  Finding Falcone
//
//  Created by myMac on 18/11/18.
//  Copyright © 2018 Love. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SpaceViewModel {
    
//    let planets: Observable<[Planet]>
    
    init() {
//        self.planets = Observable.of(getAllThePlanetsFromServer())
    }
    
    
    /*lazy var data: Driver<[Planet]> = {
        
        return Observable.just(getAllThePlanetsFromServer())
        
    }()*/
    
    typealias Completion = (_ success : Bool, _ errorMessage : String?, _ responseObject : Any?) -> Void
    
    func getAllThePlanetsFromServer() -> Observable<[Planet]> {
        
        guard let url = URL(string: APIURL.planets) else { return Observable.just([]) }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .asObservable()
            .retry(3)
            .catchError({ (error) -> Observable<Data> in
                print(error)
                return Observable.just("[]".data(using:.utf8)!)
            })
        .map(parse)
        
    }
    
    func parse(data: Data) -> [Planet] {
        
        do {
            let jsonObject = try JSONDecoder().decode([Planet].self, from: data)
            return jsonObject
        } catch {
            print(error)
            return []
        }
    }
    
}
