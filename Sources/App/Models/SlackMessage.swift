//
//  SlackMessage.swift
//  App
//

import Vapor

enum SlackMessageType: String {
    case ephemeral
    case inChannel = "in_channel"
}

protocol SlackMessageProtocol {
    var text: String { get }
    var attachments: [MessageAttachmentProtocol] { get }
    var responseType: SlackMessageType { get }
}

extension SlackMessageProtocol where Self: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("response_type", responseType.rawValue)
        try json.set("text", text)
        try json.set("attachments", attachments)
        return json
    }
}

struct SlackMessage: SlackMessageProtocol, JSONRepresentable {
    let text: String
    let attachments: [MessageAttachmentProtocol]
    let responseType: SlackMessageType
    
    init(text: String, attachments: [MessageAttachmentProtocol] = [], responseType: SlackMessageType = .inChannel) {
        self.text = text
        self.attachments = attachments
        self.responseType = responseType
    }
}

protocol MessageAttachmentProtocol {
    var fallback: String { get }
    var title: String { get }
    var title_link: String? { get }
    var author_name: String? { get }
    var author_icon: String? { get }
    var footer: String? { get }
    var footer_icon: String? { get }
    var color: String? { get }
}

extension MessageAttachmentProtocol where Self: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("fallback", fallback)
        try json.set("title", title)
        if let title_link = title_link {
            try json.set("title_link", title_link)
        }
        if let author_name = author_name {
            try json.set("author_name", author_name)
        }
        if let author_icon = author_icon {
            try json.set("author_icon", author_icon)
        }
        if let footer = footer {
            try json.set("footer", footer)
        }
        if let footer_icon = footer_icon {
            try json.set("footer_icon", footer_icon)
        }
        if let color = color {
            try json.set("color", color)
        }
        return json
    }
}

