//
//  File.swift
//  
//
//  Created by Scott Lydon on 5/7/24.
//

import Foundation

public enum MimeType: String {
    /// Used for JSON-formatted data, common in web services and RESTful APIs. Example: Sending user data to a server.
    case json = "application/json"

    /// Used for sending form data in key-value pairs, typical in HTML forms. Example: Submitting login credentials.
    case formUrlEncoded = "application/x-www-form-urlencoded"

    /// Used for multipart form data, suitable for uploading files. Example: Uploading an image along with metadata.
    case formData = "multipart/form-data"

    /// Used for transmitting plain text. Example: Sending raw text for a simple message.
    case textPlain = "text/plain"

    /// Used for binary data transfers where the file type is not specified. Example: Downloading an application or tool.
    case octetStream = "application/octet-stream"

    /// Used for XML data. Example: Integrating with legacy systems that require XML.
    case xml = "application/xml"

    /// Used for GraphQL queries. Example: Fetching specific data from a GraphQL API.
    case graphql = "application/graphql"

    /// Used for JavaScript resources. Example: Loading a JavaScript framework or library.
    case javascript = "application/javascript"

    /// Used for PDF documents. Example: Downloading a report or brochure in PDF format.
    case pdf = "application/pdf"

    /// Used for JPEG images. Example: Displaying user profile pictures.
    case jpeg = "image/jpeg"

    /// Used for PNG images. Example: Displaying transparent images for web graphics.
    case png = "image/png"

    /// Used for GIF images. Example: Embedding animated GIFs in a webpage.
    case gif = "image/gif"

    /// Used for MP3 audio files. Example: Streaming music or a podcast.
    case mp3 = "audio/mpeg"

    /// Used for OGG audio files. Example: Providing browser-compatible game sounds.
    case ogg = "audio/ogg"

    /// Used for MP4 video files. Example: Streaming a movie or video clip.
    case mp4 = "video/mp4"

    /// Used for QuickTime video files. Example: Editing or displaying video content in Apple environments.
    case quicktime = "video/quicktime"

    /// Used for transmitting SQL data. Example: Sending a database query from a client to a server.
    case sql = "application/sql"

    /// Used for JSON-based linked data (JSON-LD). Example: Enhancing SEO and linking data for web crawlers.
    case jsonLD = "application/ld+json"
}
