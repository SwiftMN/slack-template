import Vapor

extension Droplet {
    func setupRoutes() throws {
        guard let verificationToken = config["slack", "token"]?.string else {
            // If you're running locally, make sure the file /Config/secrets/slack.json exists
            // /Config/slack.json is set up to use a `vapor cloud config` which is not available locally
            // If vapor cloud deploy is failing, make sure you have a `vapor cloud config` set up
            // `vapor cloud config modify SLACK_TOKEN=<slack_token>`
            throw Abort(.internalServerError, reason: "Startup failed due to missing Slack token")
        }
        let slashCommandValidator = SlashCommandValidator(verificationToken: verificationToken)
        
        /// Hello World
        get { _ in return "Hello World" }
        
        /// Slack Slash Commands
        /// In your slack app settings, set your "Request URL" to be <your_domain>/slashCommand/<command_route>
        /// For the route defined below, you would set it to /slashCommand/say
        grouped(slashCommandValidator).group("slashCommand") { route in
            let slashCommand = SlashCommandController()
            route.post("say", handler: slashCommand.say)
        }
    }
}
