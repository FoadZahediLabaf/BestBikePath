//
//  ContentView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import SwiftUI
import SwiftData

struct AuthenticationView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var username: String = ""
    @State private var verificationCode: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var name: String = ""
    @State private var areTermsAccepted = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var mode: Mode = .idle
    @FocusState private var focusedField: Field?

    enum Field {
        case username, verificationCode, password, passwordConfirmation, name, termsAcceptance
    }

    enum Mode {
        case idle, emailVerify, signIn, signUp
    }

    var body: some View {
        ScrollView {
            VStack {
                TextField("Email", text: $username)
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

                if [.emailVerify].contains(mode) {
                    TextField("Verification Code", text: $verificationCode)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .verificationCode)
                        .submitLabel(.next)
                        .onSubmit(buttonAction)
                        .padding()
                        .background(.background.secondary, in: .rect)
                        .cornerRadius(12)
                }

                if [.signIn, .signUp].contains(mode) {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            switch mode {
                            case .idle, .emailVerify:
                                break
                            case .signIn:
                                buttonAction()
                            case .signUp:
                                focusedField = .passwordConfirmation
                            }
                        }
                        .padding()
                        .background(.background.secondary, in: .rect)
                        .cornerRadius(12)
                }

                if [.signUp].contains(mode) {
                    SecureField("Password Confirmation", text: $passwordConfirmation)
                        .textContentType(.password)
                        .focused($focusedField, equals: .passwordConfirmation)
                        .submitLabel(.go)
                        .onSubmit(buttonAction)
                        .padding()
                        .background(.background.secondary, in: .rect)
                        .cornerRadius(12)
                }

                if [.signUp].contains(mode) {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit(buttonAction)
                        .padding()
                        .background(.background.secondary, in: .rect)
                        .cornerRadius(12)
                        .padding(.top)

                    Toggle(isOn: $areTermsAccepted) {
                        HStack(spacing: 4) {
                            Text("Accept")
                            Link("Terms", destination: URL(string: "https://bbp.com/terms)")!)
                            Text("and")
                            Link("Conditions", destination: URL(string: "https://bbp.com/conditions)")!)
                        }
                    }
                        .padding()
                        .background(.background.secondary, in: .rect)
                        .cornerRadius(12)
                        .padding(.top)
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
                        .onTapGesture {
                            focusedField = .none
                        }
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

                    buttonTitle

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

    private var buttonTitle: Text {
        switch mode {
        case .idle:
            Text("Continue")
        case .signIn:
            Text("Sign In")
        case .emailVerify:
            Text("Verify")
        case .signUp:
            Text("Sign Up")
        }
    }


    private var infoMessage: String? {
        switch mode {
        case .idle:
            "Enter your email to login or create an account."
        case .signIn:
            "Enter your password to login to your account."
        case .emailVerify:
            "Check your email inbox and enter the verification code to create an account."
        case .signUp:
            "Fill out the form to create an account."
        }
    }



    private var isButtonValid: Bool {
        switch mode {
        case .idle:
            !username.isEmpty && !isLoading
        case .signIn:
            !username.isEmpty && !password.isEmpty && !isLoading
        case .emailVerify:
            !username.isEmpty && !verificationCode.isEmpty && !isLoading
        case .signUp:
            !username.isEmpty && !password.isEmpty && password == passwordConfirmation && !name.isEmpty && areTermsAccepted && !isLoading
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
                if try await appModel.authenticationSource.userExists(email: username) {
                    mode = .signIn
                    focusedField = .password
                } else {
                    mode = .emailVerify
                    focusedField = .verificationCode
                }
            case .emailVerify:
                mode = .signUp
            case .signIn:
                do {
                    try await appModel.authenticationSource.signIn(email: username, password: password)
                } catch {
                    errorMessage = "Wrong password for this email."
                }
            case .signUp:
                try await appModel.authenticationSource.createUser(email: username, password: password)
            }
        }
    }


}

#Preview {
    @Previewable @State var appModel = BestBikePathModel()

    NavigationStack {
        AuthenticationView()
    }
    .modelContainer(for: User.self, inMemory: true)
    .environment(appModel)
}
