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
    func getTimeline(account: ACAccount, callback: (Array<ICATTimelineEntity>?, ICATError) -> Void) {
        
        let realm = try! Realm()
        let preloadRowTimelineModels: Array<ICATTimelineEntity>? = realm.objects(ICATTimelineEntity) as? Array<ICATTimelineEntity>
        if (preloadRowTimelineModels != nil && preloadRowTimelineModels!.count > 0) {
            callback(preloadRowTimelineModels, ICATError.NoError)
        }
        
        let url: String = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let request: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: NSURL(string: url), parameters: nil)
        
        request.account = account
        request.performRequestWithHandler { (responseData, urlResponse, error) -> Void in
            
            let statusCode = urlResponse.statusCode;
            if (statusCode < 200 || statusCode >= 300) {
                callback(nil, ICATError.Network)
                return
            }
            do {
                let array = try NSJSONSerialization.JSONObjectWithData(responseData!,
                    options: NSJSONReadingOptions.MutableContainers) as! NSArray
                guard let rowTimelines:[ICATTimelineEntity] = Mapper<ICATTimelineEntity>().mapArray(array) else {
                    // Can not convert
                    callback(nil, ICATError.Generic)
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
                
                callback(rowTimelines, ICATError.NoError)
            } catch {
                callback(nil, ICATError.Generic)
            }
        }
    }
}