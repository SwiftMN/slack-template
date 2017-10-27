//
//  ListMRCommand.swift
//  App
//

import Vapor
import Console
import HTTP

final class ScheduledCommand: Command {
    
    private var config: Config?
    
    public let id = "scheduledCommand"
    public let help = [
        "This command will run every day at 8am Central.",
        "You can update or disable it by altering",
        "    Sources/App/Setup/Config+Setup.swift",
        "    Config/droplet.json",
        "    cloud.yml",
        "For more information, see: https://docs.vapor.codes/2.0/vapor/commands/"
    ]
    public let console: ConsoleProtocol
    
    public init(console: ConsoleProtocol) {
        self.console = console
    }
    
    public func run(arguments: [String]) throws {
        console.print("Running scheduledCommand with arguments: \(arguments)")
        guard
            let config = config,
            let slackUrl = config["slack", "webhooks", "scheduledCommand"]?.string
        else {
            print("ScheduledCommand failed to run")
            throw Abort(.internalServerError, reason: "Failed to instantiate config and slack webhook")
        }
        do {
            let client = try config.resolveClient()
            let message = SlackMessage(text: "Good morning! This is a scheduled task. See `Sources/App/Commands/ScheduledCommand.swift` for more details.")
            let _ = try client.sendMessage(message, to: slackUrl)
        } catch {
            console.print("ScheduledCommand failed to post a message to: \(slackUrl)")
        }
    }
}

extension ScheduledCommand: ConfigInitializable {
    public convenience init(config: Config) throws {
        let console = try config.resolveConsole()
        self.init(console: console)
        self.config = config
    }
}
