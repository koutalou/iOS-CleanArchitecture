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
    private let loginAccountRepository: ICATLoginAccountRepository
    private let socialAccountRepository: ICATSocialAccountRepository
    private let timelineRepository: ICATTimelineRepository

    public init(loginAccountRepository: ICATLoginAccountRepository, socialAccountRepository: ICATSocialAccountRepository, timelineRepository: ICATTimelineRepository) {
        self.loginAccountRepository = loginAccountRepository
        self.socialAccountRepository = socialAccountRepository
        self.timelineRepository = timelineRepository
    }
    
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
