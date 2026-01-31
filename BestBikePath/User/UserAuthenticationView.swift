//
//  ContentView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import AsyncButton
import SwiftUI
import SwiftData

struct UserAuthenticationView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var email: String = ""
    @State private var emailVerificationCode: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var displayName: String = ""
    @State private var areTermsAccepted = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var mode: Mode = .idle
    @FocusState private var focusedField: Field?

    @State private var generator = UINotificationFeedbackGenerator()
    @State private var showingErrorAlert = false
    @State private var localizedError: AnyLocalizedError?

    enum Field {
        case username, verificationCode, password, passwordConfirmation, name, termsAcceptance
    }

    enum Mode {
        case idle, emailVerify, signIn, signUp
    }

    var body: some View {
        ScrollView {
            VStack {
                TextField("Email", text: $email)
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit(performButtonAction)
                    .padding()
                    .background(.background.secondary, in: .rect)
                    .cornerRadius(12)
                    .onChange(of: email) {
                        if mode != .idle {
                            mode = .idle
                            errorMessage = nil
                        }
                    }

                if [.emailVerify].contains(mode) {
                    TextField("Verification Code", text: $emailVerificationCode)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .verificationCode)
                        .submitLabel(.next)
                        .onSubmit(performButtonAction)
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
                                performButtonAction()
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
                        .onSubmit(performButtonAction)
                        .padding()
                        .background(.background.secondary, in: .rect)
                        .cornerRadius(12)
                }

                if [.signUp].contains(mode) {
                    TextField("Name", text: $displayName)
                        .textContentType(.name)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit(performButtonAction)
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
            AsyncButton(action: buttonAction) {
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(role: .cancel) {
                    appModel.cleanMap()
                    appModel.presentedSheetItem = .communityPathSearch
                }
            }
        }
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
        if isLoading { return false }
        switch mode {
        case .idle:
            return !email.isEmpty
        case .signIn:
            let hasEmail = !email.isEmpty
            let hasPassword = !password.isEmpty
            return hasEmail && hasPassword
        case .emailVerify:
            let hasEmail = !email.isEmpty
            let hasCode = !emailVerificationCode.isEmpty
            return hasEmail && hasCode
        case .signUp:
            let hasEmail = !email.isEmpty
            let hasPassword = !password.isEmpty
            let passwordsMatch = password == passwordConfirmation
            let hasName = !displayName.isEmpty
            let accepted = areTermsAccepted
            return hasEmail && hasPassword && passwordsMatch && hasName && accepted
        }
    }

    private func performButtonAction() {
        guard isButtonValid else {
            return
        }
        Task {
            generator.prepare()
            do {
                try await buttonAction()
                generator.notificationOccurred(.success)
            } catch {
                generator.notificationOccurred(.error)
                let localizedError = error as? LocalizedError ?? UnlocalizedError(error: error)
                self.localizedError = AnyLocalizedError(erasing: localizedError)
                showingErrorAlert = true
            }
        }
    }

    private func buttonAction() async throws {
        guard isButtonValid else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        errorMessage = nil

        switch mode {
        case .idle:
            let userExists: Bool
            do {
                userExists = try await appModel.userSource.checkUserExists(email: email)
            } catch let error as FirebaseUserSource.InvalidEmail {
                errorMessage = error.failureReason
                return
            }
            if userExists {
                mode = .signIn
                focusedField = .password
            } else {
                try await appModel.userSource.sendEmailVerificationCode(email: email)
                mode = .emailVerify
                focusedField = .verificationCode
            }
        case .emailVerify:
            if try await appModel.userSource.checkEmailVerificationCode(email: email, code: emailVerificationCode) {
                mode = .signUp
            } else {
                errorMessage = "That verification code is not correct."
            }
        case .signIn:
            do {
                try await appModel.userSource.signIn(email: email, password: password)
                appModel.presentedSheetItem = .communityPathSearch
            } catch {
                errorMessage = "That password is not correct."
            }
        case .signUp:
            try await appModel.userSource.createUser(
                email: email,
                password: password,
                displayName: displayName,
                emailVerificationCode: emailVerificationCode
            )
            appModel.presentedSheetItem = .communityPathSearch
        }
    }
}

#Preview {
    @Previewable @State var appModel = BestBikePathModel()

    NavigationStack {
        UserAuthenticationView()
    }
    .modelContainer(for: UserModel.self, inMemory: true)
    .environment(appModel)
}
