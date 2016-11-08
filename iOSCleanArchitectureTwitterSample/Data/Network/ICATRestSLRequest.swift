//
//  ICATRestSLRequest.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts
import Social
import ObjectMapper
import RealmSwift

class ICATRestSLRequest: NSObject {

    /*
     * TODO: Need to support pagenation
     * Add @params parameters: NSDictionary
     */
    func getTimeline(_ account: ACAccount, callback: @escaping (Array<ICATTimelineEntity>?, ICATError) -> Void) {
        
        let realm = try! Realm()
        let preloadRowTimelineModels: Array<ICATTimelineEntity>? = realm.objects(ICATTimelineEntity) as? Array<ICATTimelineEntity>
        if (preloadRowTimelineModels != nil && preloadRowTimelineModels!.count > 0) {
            callback(preloadRowTimelineModels, ICATError.noError)
        }
        
        let url: String = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let request: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, url: URL(string: url), parameters: nil)
        
        request.account = account
        request.perform { (responseData, urlResponse, error) -> Void in
            
            let statusCode = urlResponse?.statusCode;
            if (statusCode! < 200 || statusCode! >= 300) {
                callback(nil, ICATError.network)
                return
            }
            do {
                let array = try JSONSerialization.jsonObject(with: responseData!,
                    options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                guard let rowTimelines:[ICATTimelineEntity] = Mapper<ICATTimelineEntity>().mapArray(array) else {
                    // Can not convert
                    callback(nil, ICATError.generic)
                    return
                }
                
                let realm = try! Realm()
                try! realm.write {
                    // Replace all objects when fetched 1st page
                    realm.deleteAll()
                    rowTimelines.forEach({ rowTimelineModel -> () in
                        realm.add(rowTimelineModel)
                    })
                }
                
                callback(rowTimelines, ICATError.noError)
            } catch {
                callback(nil, ICATError.generic)
            }
        }
    }
}
