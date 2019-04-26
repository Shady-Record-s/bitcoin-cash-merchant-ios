//
//  PaymentInputPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/14.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class PaymentInputPresenter {
    
    var getRateInteractor: GetRateInteractor?
    var router: PaymentInputRouter?
    weak var viewDelegate: PaymentInputViewController?
    
    var selectedCurrency: StoreCurrency
    var currentRawAmount: String = "0"
    
    init() {
        selectedCurrency = UserManager.shared.selectedCurrency
    }
    
    func viewDidLoad() {
        setupCurrency()
    }
    
    func viewWillAppear() {
        let newCurrency = UserManager.shared.selectedCurrency
        
        if newCurrency != selectedCurrency {
            selectedCurrency = newCurrency
            setupCurrency()
        }
    }
    
    func didSetAmount(_ rawAmount: String) {
        currentRawAmount = rawAmount
        setupAmount()
    }
    
    func didPushValid(_ rawAmount: String) {
        // TODO: Calculate amount of Satoshis
        // Create payment request
        let destination = UserManager.shared.destination
        guard let address = try? destination.toCashAddress() else {
            // TODO: Handle the error here with a message
            print("cash address")
            return
        }
        
        guard let amountInCurrency = Double(rawAmount) else {
            // TODO: Handle the error here with a message
            print("amount in currency")
            return
        }
        
        guard let rate = getRateInteractor?.getRate(withCurrency: selectedCurrency) else {
            // TODO: Handle the error here with a message
            print("get rate")
            return
        }
        
        // TODO: Calcul du montant en satoshis
        //
        let amountInSatoshis = rate.rate > 0  ? (amountInCurrency / rate.rate).toSatoshis() : 0
        
        let pr = PaymentRequest(toAddress: address, amountInSatoshis: Int64(amountInSatoshis), amountInCurrency: amountInCurrency)
        router?.transitToPaymentDetail(pr)
    }
}

extension PaymentInputPresenter {
    
    fileprivate func setupCurrency() {
        viewDelegate?.onSetComma(selectedCurrency.hasComma())
        setupAmount()
    }
    
    fileprivate func setupAmount() {
        // TODO: Manage the rate here
        let amount = currentRawAmount.toFormat(selectedCurrency.ticker, symbol: selectedCurrency.symbol, strict: true)
        viewDelegate?.onSetAmount(amount)
    }
}