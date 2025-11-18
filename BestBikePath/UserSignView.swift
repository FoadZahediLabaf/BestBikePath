//
//  ContentView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import SwiftUI
import SwiftData

struct UserSignView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var mode: Mode = .idle
    @FocusState private var focusedField: Field?

    enum Field {
        case username, password, passwordConfirmation
    }

    enum Mode {
        case idle, signin, signup
    }

    var body: some View {
        ScrollView {
            VStack {
                TextField("Username", text: $username)
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit(buttonAction)
                    .padding()
                    .background(.background.secondary, in: .rect)
                    .cornerRadius(12)
                    .onChange(of: username) {
                        if mode != .idle {
                            mode = .idle
                            errorMessage = nil
                        }
                    }

                if [.signin, .signup].contains(mode) {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            switch mode {
                            case .idle:
                                break
                            case .signin:
                                buttonAction()
                            case .signup:
                                focusedField = .passwordConfirmation
                            }
                        }
                        .padding()
                        .background(.background.secondary, in: .rect)
                        .cornerRadius(12)
                }

                if [.signup].contains(mode) {
                    SecureField("Password Confirmation", text: $passwordConfirmation)
                        .textContentType(.password)
                        .focused($focusedField, equals: .passwordConfirmation)
                        .submitLabel(.go)
                        .onSubmit(buttonAction)
                        .padding()
                        .background(.background.secondary, in: .rect)
                        .cornerRadius(12)
                }


                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.circle")
                        .font(.callout)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else if let infoMessage {
                    Label(infoMessage, systemImage: "questionmark.circle")
                        .id(infoMessage)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .animation(.default, value: errorMessage)
            .animation(.default, value: mode)
            .scenePadding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: buttonAction) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .controlSize(.regular)
                    }

                    Text(buttonTitle)

                    if isLoading {
                        ProgressView()
                            .controlSize(.regular)
                            .hidden()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonSizing(.flexible)
            .controlSize(.extraLarge)
            .fontWeight(.semibold)
            .disabled(!isButtonValid)
            .scenePadding(.horizontal)
            .animation(.default, value: isLoading)
            .animation(.default, value: isButtonValid)
        }
        .onAppear { focusedField = .username }
        .navigationTitle("Account")
    }

    private var buttonTitle: String {
        switch mode {
        case .idle:
            "Continue"
        case .signin:
            "Sign In"
        case .signup:
            "Sign Up"
        }
    }


    private var infoMessage: String? {
        switch mode {
        case .idle:
            "Insert your username in order to login or create an account"
        case .signin:
            "Insert your password in order to login toyour account"
        case .signup:
            "Insert your password in order to create an account"
        }
    }



    private var isButtonValid: Bool {
        switch mode {
        case .idle:
            !username.isEmpty && !isLoading
        case .signin:
            !username.isEmpty && !password.isEmpty && !isLoading
        case .signup:
            !username.isEmpty && !password.isEmpty && password == passwordConfirmation && !isLoading
        }
    }

    private func buttonAction() {
        Task { @MainActor in
            guard isButtonValid else {
                return
            }

            isLoading = true
            defer {
                isLoading = false
            }

            try? await Task.sleep(for: .seconds(1.2)) // 1s

            errorMessage = nil

            switch mode {
            case .idle:
                if appModel.checkUser(username: username) {
                    mode = .signin
                    focusedField = .password
                } else {
                    mode = .signup
                    focusedField = .password
                }
            case .signin:
                if appModel.loginUser(username: username, password: password) {

                } else {
                    errorMessage = "Wrong password for this username."
                }
            case .signup:
                appModel.registerUser(username: username, password: password)
            }
        }
    }


}

#Preview {
    @Previewable @State var appModel = BestBikePathModel()

    NavigationStack {
        UserSignView()
    }
    .modelContainer(for: User.self, inMemory: true)
    .environment(appModel)
}
