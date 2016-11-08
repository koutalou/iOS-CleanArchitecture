//
//  ICATTimelinePresenter.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

enum ICATTimelineStatus {
    case none
    case notAuthorized
    case loading
    case normal
    case error
}

class ICATTimelinePresenter: NSObject, ICATTimelineUseCaseOutput {
    weak var viewInput: ICATTimelineViewInput?
    var usecase: ICATTimelineUseCase = ICATTimelineUseCase()

    func loadTimelines() {
        usecase.output = self
        usecase.loadTimelines()
        viewInput?.changedStatus(ICATTimelineStatus.loading)
    }
    
    // MARK: ICATTimelineUseCaseOutput
    
    func notAuthorizedOrNoAccount() {
        viewInput?.changedStatus(ICATTimelineStatus.notAuthorized)
    }
    
    func loadTimelines(_ timelinesModel: ICATTimelinesModel) {
        DispatchQueue.main.async { [weak self]() -> Void in
            self?.viewInput?.setTimelinesModel(timelinesModel)
            let isNoData: Bool = timelinesModel.timelines.count == 0
            self?.viewInput?.changedStatus(isNoData ? ICATTimelineStatus.none : ICATTimelineStatus.normal)
        }
    }
    
    func loadTimelinesError(_ error: ICATError) {
        if (error == .notAuthorized) {
            viewInput?.changedStatus(ICATTimelineStatus.notAuthorized)
        } else {
            viewInput?.changedStatus(ICATTimelineStatus.error)
        }
    }
}
