//
//  ICATTimelineUseCase.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

protocol ICATTimelineUseCaseOutput {
    func loadTimelines() -> Observable<ICATTimelinesModel>
}

struct ICATTimelineUseCase: ICATTimelineUseCaseOutput {
    let loginAccountRepository: ICATLoginAccountRepository = ICATLoginAccountRepository()
    let socialAccountRepository: ICATSocialAccountRepository = ICATSocialAccountRepository()
    let timelineRepository: ICATTimelineRepository = ICATTimelineRepository()

    func loadTimelines() -> Observable<ICATTimelinesModel> {
        let login = loginAccountRepository.getSelectedTwitterAccountTask()
        let accounts = socialAccountRepository.getTwitterAccountsTask()
        
        return Observable.combineLatest(login, accounts) { ($0, $1) }
            .flatMap { (identifier, accounts) -> Observable<ICATTimelinesModel> in
                guard let identifier = identifier, let selectAccount = accounts.filter({$0.identifier.isEqual(to: identifier)}).first else {
                    return Observable.error(ICATError.notAuthorized)
                }
                return self.timelineRepository.getTwitterTimelineTask(selectAccount)
                    .map(translator: ICATTimelineTranslater())
        }
    }
}
