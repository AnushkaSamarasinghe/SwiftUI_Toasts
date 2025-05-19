//
//  Toasts.swift
//  SwiftUIToasts
//
//  Created by Anushka Samarasinghe on 2025-04-16.
//

import Foundation
import SwiftUI
import Observation

//MARK: - TOAST TYPES

enum ToastTypes: String, CaseIterable {
    case success
    case warning
    case error
    case custom
    
    var icon: Image {
        switch self {
        case .success:
            return Image(systemName: "checkmark")
        case .warning:
            return Image(systemName: "exclamationmark.triangle")
        case .error:
            return Image(systemName: "xmark")
        case .custom:
            return Image(systemName: "")
        }
    }
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        case .custom:
            return ""
        }
    }
    
    var color: Color {
        switch self {
        case .success:
            return .green
        case .warning:
            return .yellow
        case .error:
            return .red
        case .custom:
            return .accentColor
        }
    }
    
}

//MARK: - TOASTER

@Observable
class Toaster {
    static let sharedToastsData = ToastsData()
    static let shared = Toaster()
    
    func showToast(toastType: ToastTypes,
                   toastIcon: Image? = nil,
                   toastTitle: String? = nil,
                   toastTint: Color? = nil,
                   isButtonAvailable: Bool = false,
                   buttonTitle: String? = nil,
                   buttonColor: Color? = nil,
                   buttonAction: (() -> Void)? = nil) {
        
        Self.sharedToastsData.add(.init { [self] id in
            ToasterView(toastType: toastType,
                        toastsData: Self.sharedToastsData,
                        toastIcon: toastIcon,
                        toastTitle: toastTitle,
                        toastTint: toastTint,
                        isButtonAvailable: isButtonAvailable,
                        buttonTitle: buttonTitle,
                        buttonColor: buttonColor,
                        buttonAction: buttonAction,
                        id: id)
        })
    }
    
    /// Custom toast View
    @ViewBuilder
    func ToasterView(toastType: ToastTypes,
                     toastsData: ToastsData,
                     toastIcon: Image? = nil,
                     toastTitle: String? = nil,
                     toastTint: Color? = nil,
                     isButtonAvailable: Bool = false,
                     buttonTitle: String? = nil,
                     buttonColor: Color? = nil,
                     buttonAction: (() -> Void)? = nil,
                     id: String) -> some View {
        HStack(spacing: 12) {
            let symbolImage = (toastType == .custom ? (toastIcon ?? Image("")) : (toastType.icon))
            
            symbolImage
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(toastType == .custom ? (toastTint ?? toastType.color) : (toastTint == nil ? toastType.color : toastTint ?? Color.clear))
            
            let title = (toastType == .custom ? (toastTitle ?? "") : (toastTitle == nil ? toastType.title : toastTitle ?? ""))
            
            Text(title)
                .font(.callout)
            
            if isButtonAvailable {
                Button {
                    toastsData.delete(id)
                } label: {
                    Text(buttonTitle ?? "N/A")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            Capsule()
                                .fill((buttonColor ?? .green).opacity(0.4))
                                .fill(.ultraThinMaterial)
                                .background(
                                    Capsule()
                                        .fill(.ultraThinMaterial)
                                        .blur(radius: 4)
                                )
                                .shadow(color: .gray.opacity(0.08), radius: 3, x: -1, y: -3)
                                .shadow(color: .gray.opacity(0.08), radius: 2, x: 1, y: 3)
                                .blur(radius: 0.4)
                        )
                }
            } else {
                if toastType == .custom {
                    Spacer(minLength: 0)
                    Button {
                        toastsData.delete(id)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
        .foregroundStyle(Color.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .blur(radius: 4)
                )
                .shadow(color: .gray.opacity(0.4), radius: 3, x: -1, y: -3)
                .shadow(color: .gray.opacity(0.4), radius: 3, x: 1, y: 3)
                .blur(radius: 0.4)
        )
        .padding(.horizontal, 15)
    }
    
}

//MARK: - TOASTS DATA

@Observable
class ToastsData {
    fileprivate var toasts: [Toast] = []
    
    /// Adds toast to the Context
    func add(_ toast: Toast) {
        withAnimation(.bouncy) {
            toasts.append(toast)
        }
    }
    
    /// Removes toast from the Context
    func delete(_ id: String) {
        @Bindable var bindable = self
        if let toast = $bindable.toasts.first(where: { $0.id == id }) {
            toast.wrappedValue.isDeleting.toggle()
        }
        
        withAnimation(.bouncy) {
            toasts.removeAll(where: { $0.id == id })
        }
    }
}

//MARK: - TOAST IDENTIFIER

struct Toast: Identifiable {
    private(set) var id: String = UUID().uuidString
    var content: AnyView
    
    init(@ViewBuilder content: @escaping (String) -> some View) {
        self.content = .init(content(id))
    }
    
    /// View Properties
    var offsetY: CGFloat = 0
    var isDeleting: Bool = false
}

//MARK: - TOAST VIEW

fileprivate struct ToastsView: View {
    /// View Properties
    @State private var isExpanded: Bool = false
    @State private var height: CGFloat = .zero
    @State private var autoDismissTime: TimeInterval = 3   /// 3 Seconds
    
    @Bindable var toastsBindable = Toaster.sharedToastsData
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            if isExpanded {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isExpanded = false
                    }
            }
            
            let layout = isExpanded ? AnyLayout(VStackLayout(spacing: 10)) : AnyLayout(ZStackLayout())
            
            layout {
                ForEach($toastsBindable.toasts) { $toast in
                    let index = (toasts.count - 1) - (toasts.firstIndex(where: { $0.id == toast.id }) ?? 0)
                    
                    toast.content
                        .offset(x: toast.offsetY)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let yOffset = value.translation.height < 0 ? value.translation.height : 0
                                    toast.offsetY = yOffset
                                }.onEnded { value in
                                    let yOffset = value.translation.height + (value.velocity.height * 2)
                                    
                                    if -yOffset < 200 {
                                        /// Remove Toast
                                        if index < toasts.count {
                                            toastsBindable.delete(toast.id)
                                        }
                                    } else {
                                        /// Reset Toast to it's initial Position
                                        withAnimation(.bouncy) {
                                            toast.offsetY = 0
                                        }
                                    }
                                }
                        )
                        .visualEffect { [isExpanded] content, proxy in
                            content
                                .scaleEffect(isExpanded ? 1 : scale(index), anchor: .bottom)
                                .offset(y: isExpanded ? 0 : offsetY(index))
                        }
                        .zIndex(toast.isDeleting ? 0 : 1000)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: isExpanded ? .scale(scale: 0.8).combined(with: .opacity) : .move(edge: .bottom).combined(with: .opacity)
                        ))
                        .task(id: !isExpanded) {
                            if !isExpanded {
                                if index < toasts.count {
                                    await dismissAfterDelayIfNotExpanded(toastId: toast.id)
                                }
                            }
                        }
                }
            }
            .padding(.bottom, 10)
            .onTapGesture {
                if toasts.count > 1 {
                    isExpanded.toggle()
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .animation(.bouncy, value: isExpanded)
        .onChange(of: toasts.isEmpty) { oldValue, newValue in
            if newValue {
                isExpanded = false
            }
        }
    }
    
    nonisolated private func offsetY(_ index: Int) -> CGFloat {
        let offset = min(CGFloat(index) * 15, 30)
        
        return -offset
    }
    
    nonisolated private func scale(_ index: Int) -> CGFloat {
        let scale = min(CGFloat(index) * 0.1, 1)
        
        return 1 - scale
    }
    
    private func dismissAfterDelayIfNotExpanded(toastId: String) async {
        do {
            try await Task.sleep(nanoseconds: UInt64(autoDismissTime) * 1_000_000_000)
            guard !isExpanded, toasts.contains(where: { $0.id == toastId }) else {
                return
            }
            toastsBindable.delete(toastId)
        } catch {
            debugPrint("Dismiss task for \(toastId) failed: \(CancellationError.self)")
        }
    }
    
    var toasts: [Toast] {
        Toaster.sharedToastsData.toasts
    }
}

//MARK: - TOAST VIEW MODIFIER

extension View {
    func withToastsMod() -> some View {
        modifier(ToastsViewModifier())
    }
}

struct ToastsViewModifier: ViewModifier {
    /// View Properties
    @State private var overlayWindow: UIWindow?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                    let window = PassthroughWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    /// View Controller
                    let rootController = UIHostingController(rootView: ToastsView())
                    rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
                    rootController.view.backgroundColor = .clear
                    window.rootViewController = rootController
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009
                    
                    overlayWindow = window
                }
            }
            .ignoresSafeArea(.all)
    }
}

/// A Pass through UIWindow, which is placed above the Entire SwiftUI Window and works like a universal toasts
fileprivate class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event),
              let rootView = rootViewController?.view
        else { return nil }
        
        if #available(iOS 18, *) {
            for subview in rootView.subviews.reversed() {
                /// Finding if any of rootview's is receving hit test
                let pointInSubView = subview.convert(point, from: rootView)
                if subview.hitTest(pointInSubView, with: event) != nil {
                    return hitView
                }
            }
            
            return nil
        } else {
            return hitView == rootView ? nil : hitView
        }
    }
}

#Preview {
    ContentView()
}
