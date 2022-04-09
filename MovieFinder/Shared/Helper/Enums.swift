//
//  Enums.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation

enum LangCode: String {
    case en
}

enum CustomFont {
    case regular
    case medium
    case bold
    case light
    case semibold
    case thin
    case heavy
    case semiboldItalic
    case boldItalic
}

enum Error: String {
    case AuthError
    case EmptyData
    case ParseFailed
    case Failure
    case PaymentNotAuthorized
    case LoginAlreadyInUseException
    case InvalidPasswordException
    case OTP
}
