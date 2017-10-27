//
//  SlashCommandController.swift
//  App
//

import Vapor
import HTTP

final class SlashCommandController {

    func say(_ request: Request) throws -> ResponseRepresentable {
        
        guard let text = try? request.formValue(key: .text) else {
            return """
            Hi there!
            If you add some text to the command, I'll say it to everyone. Like this:
            `/say Good news, everyone!`
            """
        }

        background {
            // send the message to everyone in the channel on a background thread
            let message = SlackMessage(text: text)
            let _ = try? request.respond(with: message)
        }
        return ""
    }
    
}
