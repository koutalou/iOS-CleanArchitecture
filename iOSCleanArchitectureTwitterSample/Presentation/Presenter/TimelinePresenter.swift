//
//  TimelinePresenter.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift

enum TimelineStatus {
    case none
    case notAuthorized
    case loading
    case normal
    case error
}

protocol TimelinePresenter {
    func loadTimelines()
    func tapPersonButton()
}

class TimelinePresenterImpl: TimelinePresenter {
    
    weak var viewInput: TimelineViewInput?
    var wireframe: TimelineWireframe?
    var useCase: TimelineUseCase
    
    private let disposeBag = DisposeBag()

    public required init(useCase: TimelineUseCase, viewInput: TimelineViewInput, wireframe: TimelineWireframe) {
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
        
        viewInput?.changedStatus(TimelineStatus.loading)
    }
    
    func tapPersonButton() {
        wireframe?.showLogin()
    }
}

// MARK: Private
extension TimelinePresenterImpl {
    fileprivate func loadedTimelinesModel(timelines: TimelinesModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewInput?.setTimelinesModel(timelines)
            let isNoData: Bool = timelines.timelines.count == 0
            self?.viewInput?.changedStatus(isNoData ? TimelineStatus.none : TimelineStatus.normal)
        }
    }
    
    fileprivate func errorHandling(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let error = error as? AppError else {
                self?.viewInput?.changedStatus(TimelineStatus.error)
                return
            }
            switch error {
            case .notAuthorized:
                self?.viewInput?.changedStatus(TimelineStatus.notAuthorized)
                self?.wireframe?.showLogin()
            default:
                self?.viewInput?.changedStatus(TimelineStatus.error)
            }
        }
    }
}
