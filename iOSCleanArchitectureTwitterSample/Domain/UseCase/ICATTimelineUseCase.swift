//
//  ICATTimelineUseCase.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import SwiftTask
import Accounts

protocol ICATTimelineUseCaseOutput: class {
    func loadTimelines(timelinesModel: ICATTimelinesModel)
    func notAuthorizedOrNoAccount()
    func loadTimelinesError(error: ICATError)
}

class ICATTimelineUseCase: NSObject {
    weak var output: ICATTimelineUseCaseOutput?

    lazy var loginAccountRepository: ICATLoginAccountRepository = ICATLoginAccountRepository()
    lazy var socialAccountRepository: ICATSocialAccountRepository = ICATSocialAccountRepository()
    lazy var timelineRepository: ICATTimelineRepository = ICATTimelineRepository()

    func loadTimelines() {
        var twitterAccountIdentifier: String?
        
        loginAccountRepository.getSelectedTwitterAccountTask().success { (identifier) -> Task<Void, Array<ACAccount>?, ICATError> in
            twitterAccountIdentifier = identifier
            return self.socialAccountRepository.getTwitterAccountsTask()
        }
        .success { (accounts) -> Void in
            guard let selectAccount = accounts?.filter({$0.identifier == twitterAccountIdentifier}).first else {
                // No data
                self.output?.notAuthorizedOrNoAccount()
                return
            }
            self.timelineRepository.getTwitterTimelineTask(selectAccount).success{ timelines -> Void in
                // Translate
                let timelinesModel = ICATTimelineTranslater.generateTimelines(timelines!)
                self.output?.loadTimelines(timelinesModel)
            }.failure{ (error, isCancelled) -> Void in
                self.output?.loadTimelinesError(error ?? ICATError.Generic)
            }
        }
        .failure { (error, isCancelled) -> Void in
            self.output?.loadTimelinesError(error ?? ICATError.Generic)
        }
    }
}
