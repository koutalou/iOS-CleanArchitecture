//
//  TimelineUseCase.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

protocol TimelineUseCaseOutput {
    func loadTimelines() -> Observable<TimelinesModel>
}

struct TimelineUseCase: TimelineUseCaseOutput {
    private let loginAccountRepository: LoginAccountRepository
    private let socialAccountRepository: SocialAccountRepository
    private let timelineRepository: TimelineRepository

    public init(loginAccountRepository: LoginAccountRepository, socialAccountRepository: SocialAccountRepository, timelineRepository: TimelineRepository) {
        self.loginAccountRepository = loginAccountRepository
        self.socialAccountRepository = socialAccountRepository
        self.timelineRepository = timelineRepository
    }
    
    func loadTimelines() -> Observable<TimelinesModel> {
        let login = loginAccountRepository.getSelectedTwitterAccountTask()
        let accounts = socialAccountRepository.getTwitterAccountsTask()
        
        return Observable.combineLatest(login, accounts) { ($0, $1) }
            .flatMap { (identifier, accounts) -> Observable<TimelinesModel> in
                guard let identifier = identifier, let selectAccount = accounts.filter({$0.identifier.isEqual(to: identifier)}).first else {
                    return Observable.error(AppError.notAuthorized)
                }
                return self.timelineRepository.getTwitterTimelineTask(selectAccount)
                    .map(translator: TimelineTranslater())
        }
    }
}
