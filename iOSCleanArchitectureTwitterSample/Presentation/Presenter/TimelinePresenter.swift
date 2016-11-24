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

// MARK: - Interface
protocol TimelinePresenter {
    func loadCondition()
    func loadTimelines()
    func selectCell(timeline: TimelineViewModel)
    func tapPersonButton()
}


// MARK: - Implementation / Home
class HomeTimelinePresenterImpl: TimelinePresenter {
    
    weak var viewInput: TimelineViewInput?
    let wireframe: TimelineWireframe
    let useCase: TimelineUseCase

    fileprivate let observer: SelectPersonObserver
    fileprivate let disposeBag = DisposeBag()

    public required init(useCase: TimelineUseCase, viewInput: TimelineViewInput, wireframe: TimelineWireframe, observer: SelectPersonObserver) {
        self.useCase = useCase
        self.viewInput = viewInput
        self.wireframe = wireframe
        self.observer = observer
        
        bindObserver()
    }
    
    func loadCondition() {
        viewInput?.setCondition(isSelectable: true)
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
    
    func selectCell(timeline: TimelineViewModel) {
        wireframe.showUserTimeline(screenName: timeline.screenName)
    }
    
    func tapPersonButton() {
        wireframe.showLogin()
    }
}

// MARK: Private
extension HomeTimelinePresenterImpl {
    fileprivate func bindObserver() {
        observer.selectPersonObserver
            .subscribe { [weak self] _ in
                DispatchQueue.main.async {
                    self?.loadTimelines()
                }
            }
        .addDisposableTo(disposeBag)
    }

    
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
                self?.wireframe.showLogin()
            default:
                self?.viewInput?.changedStatus(TimelineStatus.error)
            }
        }
    }
}

// MARK: - Implementation / User
class UserTimelinePresenterImpl: TimelinePresenter {
    
    weak var viewInput: TimelineViewInput?
    let wireframe: TimelineWireframe
    let useCase: TimelineUseCase
    let screenName: String
    
    private let disposeBag = DisposeBag()
    
    public required init(useCase: TimelineUseCase, viewInput: TimelineViewInput, wireframe: TimelineWireframe, screenName: String) {
        self.useCase = useCase
        self.viewInput = viewInput
        self.wireframe = wireframe
        self.screenName = screenName
    }
    
    func loadCondition() {
        viewInput?.setCondition(isSelectable: false)
    }
    
    func loadTimelines() {
        useCase.loadTimelines(screenName: screenName)
            .subscribe(
                onNext: { [weak self] timelines in
                    self?.loadedTimelinesModel(timelines: timelines)
                }, onError: { [weak self] error in
                    self?.errorHandling(error: error)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        viewInput?.changedStatus(TimelineStatus.loading)
    }
    
    func selectCell(timeline: TimelineViewModel) {
        // Nothing to do
    }
    
    func tapPersonButton() {
        // Nothing to do
    }
}

// MARK: Private
extension UserTimelinePresenterImpl {
    fileprivate func loadedTimelinesModel(timelines: TimelinesModel) {
        DispatchQueue.main.async { [weak self] in
            if let firstTimeline = timelines.timelines.first {
                self?.viewInput?.setUserModel(firstTimeline)
            }
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
                self?.wireframe.showLogin()
            default:
                self?.viewInput?.changedStatus(TimelineStatus.error)
            }
        }
    }
}
