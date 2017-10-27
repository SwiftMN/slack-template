//
//  SlashCommandValidator.swift
//  App
//

import HTTP

final class SlashCommandValidator: Middleware {
    
    private let verificationToken: String
    
    init(verificationToken: String) {
        self.verificationToken = verificationToken
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let token = try request.formValue(key: .token)
        guard self.verificationToken == token else {
            throw Abort(.unauthorized, reason: "Invalid token")
        }
        return try next.respond(to: request)
    }
}


