//
//  SlashCommandKey.swift
//  App
//

import Foundation

/// keys used to fetch data from a slash command request body
/// See Request+Slack.swift for more details
enum SlashCommandKey: String {
    case text
    case token
    case command
    case responseUrl = "response_url"
    case userName = "user_name"
    case userId = "user_id"
    case triggerId = "trigger_id"
    case teamId = "team_id"
    case channelId = "channel_id"
    case channelName = "channel_name"
    case teamDomain = "team_domain"
}

