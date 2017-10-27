# SwiftMN Slack App Template

## About SwiftMN

SwiftMN is a Swift user group in Minneapolis, Minnesota.  
You can meet us in person and join our meetup at [swift.mn](http://swift.mn)  
You can talk to us on Slack and see this template in action at [slack.swift.mn](http://swift.mn)  
You can email us directly at [info@swift.mn](mailto:info@swift.mn)  

You can also contribute to this template! Pull requests, issues, feature requests, and feedback of any kind is welcome.

## About this template

### Features

* Incoming Webhooks API
    * Easily send messages of all types into Slack including attachments
* Slash Commands API
    * Incoming slash commands are automatically validated via Middleware
    * Extensions and private functions make responding to slash commands easy
* Easily schedule commands
    * Want to make an API request and post a message with the result every morning? No problem!

### Roadmap

* Real Time Messaging API (bot message handling)
* Interactive Messages
* Better message construction and format debugging



## Getting Started

To create a new Slack App with Vapor, simply specify this template when creating your vapor app.

    vapor new MySlackApp --template=SwiftMN/slack-template

## Setup and Usage

### Incoming Webhooks

If you set up an incoming webhook for your Slack App, simply copy the url into `Config/slack.json` under the `webhooks` section. It should look something like this:

    "webhooks": {
        "scheduledCommand": "https://hooks.slack.com/services/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"
    }

Then to call the webhook, you simply grab the url out of config, and make the request:

    guard let webhook = config["slack", "webhooks", "scheduledCommand"]?.string else {
        throw Abort(.internalServerError, reason: "Could not find scheduledCommand webhook")
    }
    let message = SlackMessage(text: "Good news, everyone!")
    let _ = try client.sendMessage(message, to: webhook)

### Slash Commands

Responding to slash commands is super easy. There are 3 steps you need to take for every slash command that you want to add. For this example we'll add a command `/say` that sends a message with whatever text the user entered.

1. Add a Slash Command in your Slack App configuration, and set the "Request URL" to `<your_domain>/slashCommand/say`.
2. Add a route for `say` to `Sources/App/Routes/Routes.swift`

        route.post("say", handler: slashCommand.say)

3. Add a function in `SlashCommandController` to handle the command

        func say(_ request: Request) throws -> ResponseRepresentable { 
            return "ok"
        }

That's it! That is a fully functional slash command. However, it doesn't actually do what we want it to. Let's update our `say` function to send a message back to the slack group.

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
        
        // This will be shown to the user that entered the slash command
        return "Coming right up!"
    }

Most of the time you should send messages on a background thread so the slash command doesn't timeout and show the user an error even thought it actually worked. Slack has a short timeout for slash commands.

### Scheduled Commands

Vapor allows you to build commands that can be run in the terminal. These commands can then be scheduled using cron expressions. This is super handy if you want to have your bot automatically do something every day, every hour, or every whatever you can do with cron.

Let's say we want our bot to say "Good Morning" every day at 8am CST. First, you'll need to follow the steps in the `Incoming Webhooks` section above so we can easily send a message into Slack. Then we need to do a few steps to build and configure our command.

1. Create a `Command` class. This template already has a `ScheduledCommand` for you to copy, but you should read the [documentation](https://docs.vapor.codes/2.0/vapor/commands/), too.
2. Call `addConfigurable` in `Sources/App/Setup/Config+Setup.swift`

        addConfigurable(command: ScheduledCommand.init, name: "scheduledCommand")

3. Add your Command id to `Config/droplet.json`

        "//": "Choose which commands this application can run",
        "//": "prepare: Supplied by the Fluent provider. Prepares the database (configure in fluent.json)",
        "commands": [
            "prepare",
            "scheduledCommand"
        ]

4. Set up a cron schedule in `cloud.yml` (Xcode can't see this file, BTW)

        type: "vapor"
        swift_version: "4.0.0"
        cronjobs:     
        production:
            scheduledCommand:
                time: "0 14 * * *"
                command: "scheduledCommand"



