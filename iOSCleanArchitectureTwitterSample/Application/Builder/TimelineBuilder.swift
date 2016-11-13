//
//  TimelineBuilder.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/13.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import UIKit

struct TimelineBuilder {
    func build() -> UIViewController {
        let wireframe = TimelineWireframeImpl()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Timeline") as! TimelineViewController
        let useCase = TimelineUseCase(
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
    
        let presenter = TimelinePresenterImpl(useCase: useCase, viewInput: viewController, wireframe: wireframe)
        viewController.inject(presenter: presenter, wireframe: wireframe)
        wireframe.viewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
