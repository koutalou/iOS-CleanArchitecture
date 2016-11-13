//
//  LoginAccountBuilder.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/13.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import UIKit

struct LoginAccountBuilder {
    func build() -> UINavigationController {
        let wireframe = LoginAccountWireframeImpl()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! ICATLoginAccountViewController
        let useCase = ICATLoginAccountUseCaseImpl(
            loginAccountRepository: ICATLoginAccountRepositoryImpl(
                dataStore: ICATLoginAccountDataStoreImpl()
            ),
            socialAccountRepository: ICATSocialAccountRepositoryImpl(
                dataStore: ICATSocialAccountDataStoreImpl()
            )
        )
        
        let presenter = ICATLoginAccountPresenterImpl(useCase: useCase, viewInput: viewController, wireframe: wireframe)
        viewController.inject(presenter: presenter, wireframe: wireframe)
        wireframe.viewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
