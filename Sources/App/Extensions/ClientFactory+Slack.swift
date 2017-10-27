//
//  ClientFactory+Slack.swift
//  App
//

import HTTP
import Vapor

extension ClientFactoryProtocol {
    func sendMessage(_ message: SlackMessageProtocol & JSONRepresentable, to slackUrl: String) throws -> HTTP.Response {
        let body = try message.makeJSON()
        return try post(
            slackUrl,
            query: [:],
            [HeaderKey.contentType: "application/json"],
            body
        )
    }
}
