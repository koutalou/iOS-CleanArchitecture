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

protocol ICATTimelinePresenter {
    func loadTimelines()
    func tapPersonButton()
}

class ICATTimelinePresenterImpl: ICATTimelinePresenter {
    
    weak var viewInput: ICATTimelineViewInput?
    var wireframe: TimelineWireframe?
    var useCase: ICATTimelineUseCase
    
    private let disposeBag = DisposeBag()

    public required init(useCase: ICATTimelineUseCase, viewInput: ICATTimelineViewInput, wireframe: TimelineWireframe) {
        self.useCase = useCase
        self.viewInput = viewInput
        self.wireframe = wireframe
    }
    
    func loadTimelines() {
        useCase.loadTimelines()
            .subscribe(
                onNext: { [weak self] timelines in
                    self?.loadedTimelinesModel(timelines: timelines)
                }, onError: { [weak self] error in
                    self?.errorHandling(error: error)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        viewInput?.changedStatus(ICATTimelineStatus.loading)
    }
    
    func tapPersonButton() {
        wireframe?.showLogin()
    }
}

// MARK: Private
extension ICATTimelinePresenterImpl {
    fileprivate func loadedTimelinesModel(timelines: ICATTimelinesModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewInput?.setTimelinesModel(timelines)
            let isNoData: Bool = timelines.timelines.count == 0
            self?.viewInput?.changedStatus(isNoData ? ICATTimelineStatus.none : ICATTimelineStatus.normal)
        }
    }
    
    fileprivate func errorHandling(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let error = error as? ICATError else {
                self?.viewInput?.changedStatus(ICATTimelineStatus.error)
                return
            }
            switch error {
            case .notAuthorized:
                self?.viewInput?.changedStatus(ICATTimelineStatus.notAuthorized)
                self?.wireframe?.showLogin()
            default:
                self?.viewInput?.changedStatus(ICATTimelineStatus.error)
            }
        }
    }
}
