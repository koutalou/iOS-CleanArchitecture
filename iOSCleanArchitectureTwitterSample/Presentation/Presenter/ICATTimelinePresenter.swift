//
//  ICATTimelinePresenter.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift

enum ICATTimelineStatus {
    case none
    case notAuthorized
    case loading
    case normal
    case error
}

class ICATTimelinePresenter {
    
    weak var viewInput: ICATTimelineViewInput?
    var usecase: ICATTimelineUseCase = ICATTimelineUseCase()
    
    private let disposeBag = DisposeBag()

    func loadTimelines() {
        usecase.loadTimelines()
            .subscribe(
                onNext: { [weak self] timelines in
                    self?.loadedTimelinesModel(timelines: timelines)
                }, onError: { [weak self] error in
                    self?.errorHandling(error: error)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        viewInput?.changedStatus(ICATTimelineStatus.loading)
    }
    
    private func loadedTimelinesModel(timelines: ICATTimelinesModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewInput?.setTimelinesModel(timelines)
            let isNoData: Bool = timelines.timelines.count == 0
            self?.viewInput?.changedStatus(isNoData ? ICATTimelineStatus.none : ICATTimelineStatus.normal)
        }
    }
    
    private func errorHandling(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let error = error as? ICATError else {
                self?.viewInput?.changedStatus(ICATTimelineStatus.error)
                return
            }
            switch error {
            case .notAuthorized:
                self?.viewInput?.changedStatus(ICATTimelineStatus.notAuthorized)
            default:
                self?.viewInput?.changedStatus(ICATTimelineStatus.error)
            }
        }
    }
}
