//
//  RestSLRequest.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts
import Social
import RxSwift
import ObjectMapper
import RealmSwift

struct Context: MapContext {
}

struct RestSLRequest {

    func getUserTimeline(_ account: ACAccount, screenName: String)  -> Observable<[TimelineEntity]> {
        let url: String = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        
        let request: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, url: URL(string: url), parameters: ["screen_name": screenName])
        request.account = account

        return fetchTimelines(request)
    }
    
    func getHomeTimeline(_ account: ACAccount) -> Observable<[TimelineEntity]> {
//        let realm = try! Realm()
//        let preloadRowTimelineModels: Array<TimelineEntity>? = realm.objects(TimelineEntity) as? Array<TimelineEntity>
//        if (preloadRowTimelineModels != nil && preloadRowTimelineModels!.count > 0) {
//            callback(preloadRowTimelineModels, AppError.noError)
//        }
        
        let url: String = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let request: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, url: URL(string: url), parameters: nil)
        request.account = account
        
        return fetchTimelines(request)
    }
    
    func fetchTimelines(_ request: SLRequest) -> Observable<[TimelineEntity]> {
        return Observable.create({ (observer) -> Disposable in
            request.perform(handler: { (responseData, urlResponse, error) in
                guard
                    let responseData = responseData,
                    let optionalJsonResponse = try? JSONSerialization.jsonObject(with: responseData,
                                                                                 options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<[String: Any]>,
                    let jsonResponse = optionalJsonResponse else {
                        observer.onError(AppError.generic)
                        return
                }
                
                let context = Context()
                let mapper = Mapper<TimelineEntity>(context: context)
                guard let rowTimelines = mapper.mapArray(JSONArray: jsonResponse) else {
                    observer.onError(AppError.generic)
                    return
                }
                
                observer.onNext(rowTimelines)
                observer.onCompleted()
            })
            
            return Disposables.create()
        })
    }
}
