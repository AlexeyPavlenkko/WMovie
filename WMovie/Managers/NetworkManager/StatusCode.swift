//
//  StatusCode.swift
//  WMovie
//
//  Created by Алексей Павленко on 03.10.2022.
//

import Foundation

/// This is a list of Hypertext Transfer Protocol (HTTP) response status codes.
/// It includes codes from IETF internet standards, other IETF RFCs, other specifications, and some additional commonly used codes.
/// The first digit of the status code specifies one of five classes of response; an HTTP client must recognise these five classes at a minimum.
enum HTTPStatusCode: Int {
    
    /// The response class representation of status codes, these get grouped by their first digit.
    enum ResponseType {
        /// - informational: This class of status code indicates a provisional response, consisting only of the Status-Line and optional headers, and is terminated by an empty line.
        case informational
        /// - success: This class of status codes indicates the action requested by the client was received, understood, accepted, and processed successfully.
        case success
        /// - redirection: This class of status code indicates the client must take additional action to complete the request.
        case redirection
        /// - clientError: This class of status code is intended for situations in which the client seems to have erred.
        case clientError
        /// - serverError: This class of status code indicates the server failed to fulfill an apparently valid request.
        case serverError
        /// - undefined: The class of the status code cannot be resolved.
        case undefined
    }
    
    // Informational - 1xx
    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102
    
    // Success - 2xx
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case IMUsed = 226
    
    // Redirection - 3xx
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case switchProxy = 306
    case temporaryRedirect = 307
    case permenantRedirect = 308
    
    // Client Error - 4xx
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case URITooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case teapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case noResponse = 444
    case unavailableForLegalReasons = 451
    case SSLCertificateError = 495
    case SSLCertificateRequired = 496
    case HTTPRequestSentToHTTPSPort = 497
    case clientClosedRequest = 499
    
    // Server Error - 5xx
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
    
    case undefined = 9999
    
    /// The class (or group) which the status code belongs to.
    var responseType: ResponseType {
        switch self.rawValue {
        case 100..<200: return .informational
        case 200..<300: return .success
        case 300..<400: return .redirection
        case 400..<500: return .clientError
        case 500..<600: return .serverError
        default:        return .undefined
        }
    }
    
    /// Default message which the status code provides.
    var message: String {
        switch self {
        case .continue:
            return "The server has received the request headers and the client should proceed to send the request body."
        case .switchingProtocols:
            return "The requester has asked the server to switch protocols and the server has agreed to do so."
        case .processing:
            return "This code indicates that the server has received and is processing the request, but no response is available yet."
        case .ok:
            return "Standard response for successful HTTP requests."
        case .created:
            return "The request has been fulfilled, resulting in the creation of a new resource."
        case .accepted:
            return "The request has been accepted for processing, but the processing has not been completed."
        case .nonAuthoritativeInformation:
            return "The server is a transforming proxy (e.g. a Web accelerator) that received a 200 OK from its origin, but is returning a modified version of the origin's response."
        case .noContent:
            return "The server successfully processed the request and is not returning any content."
        case .resetContent:
            return "The server successfully processed the request, but is not returning any content."
        case .partialContent:
            return "The server is delivering only part of the resource (byte serving) due to a range header sent by the client."
        case .multiStatus:
            return "The message body that follows is an XML message and can contain a number of separate response codes, depending on how many sub-requests were made."
        case .alreadyReported:
            return "The members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again."
        case .IMUsed:
            return "The server has fulfilled a request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance."
        case .multipleChoices:
            return "Indicates multiple options for the resource from which the client may choose"
        case .movedPermanently:
            return "This and all future requests should be directed to the given URL."
        case .found:
            return "The resource was found."
        case .seeOther:
            return "The response to the request can be found under another URI using a GET method."
        case .notModified:
            return "Indicates that the resource has not been modified since the version specified by the request headers If-Modified-Since or If-None-Match."
        case .useProxy:
            return "The requested resource is available only through a proxy, the address for which is provided in the response."
        case .switchProxy:
            return "No longer used. Originally meant \"Subsequent requests should use the specified proxy.\""
        case .temporaryRedirect:
            return "The request should be repeated with another URL."
        case .permenantRedirect:
            return "The request and all future requests should be repeated using another URI."
        case .badRequest:
            return "The server cannot or will not process the request due to an apparent client error."
        case .unauthorized:
            return "Similar to 403 Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided."
        case .paymentRequired:
            return "The content available on the server requires payment."
        case .forbidden:
            return "The request was a valid request, but the server is refusing to respond to it."
        case .notFound:
            return "The requested resource could not be found but may be available in the future."
        case .methodNotAllowed:
            return "A request method is not supported for the requested resource. e.g. a GET request on a form which requires data to be presented via POST"
        case .notAcceptable:
            return "The requested resource is capable of generating only content not acceptable according to the Accept headers sent in the request."
        case .proxyAuthenticationRequired:
            return "The client must first authenticate itself with the proxy."
        case .requestTimeout:
            return "The server timed out waiting for the request."
        case .conflict:
            return "Indicates that the request could not be processed because of conflict in the request, such as an edit conflict between multiple simultaneous updates."
        case .gone:
            return "Indicates that the resource requested is no longer available and will not be available again."
        case .lengthRequired:
            return "he request did not specify the length of its content, which is required by the requested resource."
        case .preconditionFailed:
            return "The server does not meet one of the preconditions that the requester put on the request."
        case .payloadTooLarge:
            return "The request is larger than the server is willing or able to process."
        case .URITooLong:
            return "The URL provided was too long for the server to process."
        case .unsupportedMediaType:
            return "The request entity has a media type which the server or resource does not support."
        case .rangeNotSatisfiable:
            return "The client has asked for a portion of the file (byte serving), but the server cannot supply that portion."
        case .expectationFailed:
            return "The server cannot meet the requirements of the Expect request-header field."
        case .teapot:
            return "This HTTP status is used as an Easter egg in some websites."
        case .misdirectedRequest:
            return "The request was directed at a server that is not able to produce a response."
        case .unprocessableEntity:
            return "The request was well-formed but was unable to be followed due to semantic errors."
        case .locked:
            return "The resource that is being accessed is locked."
        case .failedDependency:
            return "The request failed due to failure of a previous request (e.g., a PROPPATCH)."
        case .upgradeRequired:
            return "The client should switch to a different protocol such as TLS/1.0, given in the Upgrade header field."
        case .preconditionRequired:
            return "The origin server requires the request to be conditional."
        case .tooManyRequests:
            return "The user has sent too many requests in a given amount of time."
        case .requestHeaderFieldsTooLarge:
            return "The server is unwilling to process the request because either an individual header field, or all the header fields collectively, are too large."
        case .noResponse:
            return "The server has returned no information to the client and closed the connection."
        case .unavailableForLegalReasons:
            return "A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource."
        case .SSLCertificateError:
            return "An expansion of the 400 Bad Request response code, used when the client has provided an invalid client certificate."
        case .SSLCertificateRequired:
            return "An expansion of the 400 Bad Request response code, used when a client certificate is required but not provided."
        case .HTTPRequestSentToHTTPSPort:
            return "An expansion of the 400 Bad Request response code, used when the client has made a HTTP request to a port listening for HTTPS"
        case .clientClosedRequest:
            return "Used when the client has closed the request before the server could send a response."
        case .internalServerError:
            return "A generic error message, given when an unexpected condition was encountered and no more specific message is suitable."
        case .notImplemented:
            return "The server either does not recognize the request method, or it lacks the ability to fulfill the request."
        case .badGateway:
            return "The server was acting as a gateway or proxy and received an invalid response from the upstream server."
        case .serviceUnavailable:
            return "The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state."
        case .gatewayTimeout:
            return "The server was acting as a gateway or proxy and did not receive a timely response from the upstream server."
        case .HTTPVersionNotSupported:
            return "The server does not support the HTTP protocol version used in the request."
        case .variantAlsoNegotiates:
            return "Transparent content negotiation for the request results in a circular reference."
        case .insufficientStorage:
            return "The server is unable to store the representation needed to complete the request."
        case .loopDetected:
            return "The server detected an infinite loop while processing the request."
        case .notExtended:
            return "Further extensions to the request are required for the server to fulfill it."
        case .networkAuthenticationRequired:
            return "The client needs to authenticate to gain network access."
        case .undefined:
            return "Unknown error."
        }
    }
    
}

extension HTTPURLResponse {
    /// returns enum case of HTTPStatusCode which belongs to the current status code of HTTPURLResponse
    var status: HTTPStatusCode {
        return HTTPStatusCode(rawValue: statusCode) ?? .undefined
    }
    
    /// returns responseType the status of HTTPURLResponse represented in enum HTTPStatusCode
    var responseType: HTTPStatusCode.ResponseType {
        return self.status.responseType
    }
}
