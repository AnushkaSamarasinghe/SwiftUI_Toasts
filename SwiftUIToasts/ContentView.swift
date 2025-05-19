//
//  ContentView.swift
//  SwiftUIToasts
//
//  Created by Anushka Samarasinghe on 2025-04-16.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = BaseVM()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Toaster Examples") {
                    Button {
                        vm.showSuccessToaster()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Success")
                        }
                        .foregroundStyle(.green)
                    }
                    
                    Button {
                        vm.showWarningToaster()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Warning")
                        }
                        .foregroundStyle(.yellow)
                    }
                    
                    Button {
                        vm.showErrorToaster()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Error")
                        }
                        .foregroundStyle(.red)
                    }
                    
                    Button {
                        vm.showCustomToaster(icon: Image(systemName: "gear"), message: "This is an informational message")
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "info.circle.fill")
                            Text("Info")
                        }
                        .foregroundStyle(.blue)
                    }
                    
                    Button {
                        vm.showCustomToaster(icon: Image(systemName: "hand.tap.fill"),
                                             message: "with custom button",
                                             tint: .black,
                                             isButtonAvailable: true,
                                             buttonTitle: "Click Me",
                                             buttonColor: .black,
                                             buttonAction: {
                                                    print("Button Clicked")
                                            })
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "hand.tap.fill")
                            Text("with custom Button")
                        }
                        .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("SwiftUI Toaster")
        }
        .withToastsMod()
    }
}


#Preview {
        ContentView()
}
