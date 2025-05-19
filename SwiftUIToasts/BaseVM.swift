//
//  BaseVM.swift
//  SwiftUIToasts
//
//  Created by Anushka Samarasinghe on 2025-04-20.
//

import Foundation
import SwiftUI

class BaseVM: ObservableObject {

    static let shared = BaseVM()
}

//MARK:- Toasts
extension BaseVM {
    
    func showSuccessToaster(message:String? = nil){
        Toaster.shared.showToast(toastType: .success, toastTitle: message)
    }
    
    func showWarningToaster(message:String? = nil){
        Toaster.shared.showToast(toastType: .warning, toastTitle: message)
    }
    
    func showErrorToaster(message:String? = nil){
        Toaster.shared.showToast(toastType: .error, toastTitle: message)
    }
    
    func showCustomToaster(icon: Image? = nil,
                           message:String? = nil,
                           tint: Color? = nil,
                           isButtonAvailable: Bool = false,
                           buttonTitle: String? = nil,
                           buttonColor: Color? = nil,
                           buttonAction: (() -> Void)? = nil){
        Toaster.shared.showToast(toastType: .custom,
                                 toastIcon: icon,
                                 toastTitle: message,
                                 toastTint: tint,
                                 isButtonAvailable: isButtonAvailable,
                                 buttonTitle: buttonTitle,
                                 buttonColor: buttonColor,
                                 buttonAction: buttonAction)
    }

}
