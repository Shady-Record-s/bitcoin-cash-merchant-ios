//
//  PaymentRequestBuilder.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class PaymentRequestBuilder {
    
    func provide(_ pr: PaymentRequest, requestDelegate: PaymentRequestPresenterDelegate) -> UIViewController {
        let viewController = PaymentRequestViewController()
        
        let waitTransactionInteractor = WaitTransactionInteractor()
        let router = PaymentRequestRouter(viewController)
        
        let presenter = PaymentRequestPresenter(pr)
        
        waitTransactionInteractor.presenter = presenter
        presenter.waitTransactionInteractor = waitTransactionInteractor
        presenter.viewDelegate = viewController
        presenter.requestDelegate = requestDelegate
        presenter.router = router
        
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        return viewController
    }
}
