//
//  ICATTimelinePresenter.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

enum ICATTimelineStatus {
    case None
    case NotAuthorized
    case Loading
    case Normal
    case Error
}

class ICATTimelinePresenter: NSObject, ICATTimelineUseCaseOutput {
    weak var viewInput: ICATTimelineViewInput?
    var usecase: ICATTimelineUseCase = ICATTimelineUseCase()

    func loadTimelines() {
        usecase.output = self
        usecase.loadTimelines()
        viewInput?.changedStatus(ICATTimelineStatus.Loading)
    }
    
    // MARK: ICATTimelineUseCaseOutput
    
    func notAuthorizedOrNoAccount() {
        viewInput?.changedStatus(ICATTimelineStatus.NotAuthorized)
    }
    
    func loadTimelines(timelinesModel: ICATTimelinesModel) {
        dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
            self?.viewInput?.setTimelinesModel(timelinesModel)
            let isNoData: Bool = timelinesModel.timelines.count == 0
            self?.viewInput?.changedStatus(isNoData ? ICATTimelineStatus.None : ICATTimelineStatus.Normal)
        }
    }
    
    func loadTimelinesError(error: ICATError) {
        if (error == .NotAuthorized) {
            viewInput?.changedStatus(ICATTimelineStatus.NotAuthorized)
        } else {
            viewInput?.changedStatus(ICATTimelineStatus.Error)
        }
    }
}