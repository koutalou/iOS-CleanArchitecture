//
//  TimelineBuilder.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/13.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import UIKit

struct HomeTimelineBuilder {
    func build() -> UIViewController {
        let wireframe = HomeTimelineWireframeImpl()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Timeline") as! TimelineViewController
        let useCase = TimelineUseCaseImpl(
            loginAccountRepository: LoginAccountRepositoryImpl(
                dataStore: LoginAccountDataStoreImpl()
            ),
            socialAccountRepository: SocialAccountRepositoryImpl(
                dataStore: SocialAccountDataStoreImpl()
            ),
            timelineRepository: TimelineRepositoryImpl(
                dataStore: TimelineDataStoreImpl()
            )
        )
    
        let presenter = HomeTimelinePresenterImpl(useCase: useCase, viewInput: viewController, wireframe: wireframe, observer: SharedObserver.instance)
        viewController.inject(presenter: presenter)
        wireframe.viewController = viewController
        
        return viewController
    }
}

struct UserTimelineBuilder {
    private var screenName: String
    
    init(screenName: String) {
        self.screenName = screenName
    }
    
    func build() -> UIViewController {
        let wireframe = UserTimelineWireframeImpl()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Timeline") as! TimelineViewController
        let useCase = TimelineUseCaseImpl(
            loginAccountRepository: LoginAccountRepositoryImpl(
                dataStore: LoginAccountDataStoreImpl()
            ),
            socialAccountRepository: SocialAccountRepositoryImpl(
                dataStore: SocialAccountDataStoreImpl()
            ),
            timelineRepository: TimelineRepositoryImpl(
                dataStore: TimelineDataStoreImpl()
            )
        )
        
        let presenter = UserTimelinePresenterImpl(useCase: useCase, viewInput: viewController, wireframe: wireframe, screenName: screenName)
        viewController.inject(presenter: presenter)
        wireframe.viewController = viewController
        
        return viewController
    }
}
