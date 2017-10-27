//
//  Request+Slack.swift
//  App
//

import Vapor
import HTTP

extension Request {
    
    /// Pull the value for the given `key` from the formURLEncoded body
    /// return BadRequest error if missing
    func formValue(key: SlashCommandKey) throws -> String {
        return try formValue(string: key.rawValue)
    }
    
    /// Pull the value for the given `string` from the formURLEncoded body
    /// return BadRequest error if missing
    func formValue(string: String) throws -> String {
        guard
            let data = formURLEncoded,
            let value = data[string]?.string
        else {
            throw Abort(.badRequest, reason: "Missing value for key: \(string)")
        }
        return value
    }
    
    /// Easily respond to a request from Slack.
    /// Calling on a background thread is recommended
    /// especially if you respond to a request multiple times.
    func respond(with message: SlackMessageProtocol & JSONRepresentable) throws -> HTTP.Response {
        let responseUrl = try formValue(key: .responseUrl)
        return try EngineClient.factory.sendMessage(message, to: responseUrl)
    }

}
