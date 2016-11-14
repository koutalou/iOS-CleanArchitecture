//
//  LoginAccountBuilder.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/13.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import UIKit

struct LoginAccountBuilder {
    func build() -> UIViewController {
        let wireframe = LoginAccountWireframeImpl()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginAccountViewController
        let useCase = LoginAccountUseCaseImpl(
            loginAccountRepository: LoginAccountRepositoryImpl(
                dataStore: LoginAccountDataStoreImpl()
            ),
            socialAccountRepository: SocialAccountRepositoryImpl(
                dataStore: SocialAccountDataStoreImpl()
            )
        )
        
        let presenter = LoginAccountPresenterImpl(useCase: useCase, viewInput: viewController, wireframe: wireframe, observer: SharedObserver.instance)
        viewController.inject(presenter: presenter)
        wireframe.viewController = viewController
        
        return viewController
    }
}
