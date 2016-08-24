//
//  SMarkRenderer.swift
//  SMark
//
//  Created by LawLincoln on 16/8/23.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import Foundation
import SMark

//MARK:- Renderer
public final class Renderer {
    private let kMPRendererNestingLevel = 6
    private lazy var tocRegex: NSRegularExpression? = {
        let pattern = "<p.*?>\\s*\\[TOC\\]\\s*</p>"
        let reg = try? NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        print("init regex")
        return reg
    }()
}

//MARK: Generate HTML from markdown
public extension Renderer {
    
    func html(from markdown: String, extensions: hoedown_extensions, smartypants: Bool, htmlRenderer: UnsafePointer<hoedown_renderer>, tocRenderer: UnsafePointer<hoedown_renderer>? = nil, frontMatter: String? = nil) -> String {
        guard let data = markdown.dataUsingEncoding(NSUTF8StringEncoding) else { return "" }
        var result = render(with: htmlRenderer, extensions: extensions, max: Int.max, data: data, smartypants: smartypants)
        
        if let toc = tocRenderer, let r = result, let t = render(with: toc, extensions: extensions, max: kMPRendererNestingLevel, data: data) {
            let mutalbeString = NSMutableString(string: r)
            _ = tocRegex?.replaceMatchesInString(mutalbeString, options: NSMatchingOptions.init(rawValue: 0), range: NSMakeRange(0, r.characters.count), withTemplate: t)
            result = mutalbeString as String
        }
        if let front = frontMatter, let r = result {
            result = "\(front)\n\(r)"
        }
        return result ?? ""
    }
    
    private func render(with renderer:UnsafePointer<hoedown_renderer>, extensions: hoedown_extensions, max level: Int, data: NSData, smartypants: Bool? = nil ) -> String? {
        let document = hoedown_document_new(renderer, extensions, Int.max)
        var ob = hoedown_buffer_new(64)
        hoedown_document_render(document, ob, UnsafePointer<UInt8>(data.bytes), data.length)
        if smartypants == true {
            let ib = ob
            ob = hoedown_buffer_new(64)
            hoedown_html_smartypants(ob, ib.memory.data, ib.memory.size)
            hoedown_buffer_free(ib)
        }
        let result = String(CString: UnsafePointer<CChar>(hoedown_buffer_cstr(ob)), encoding: NSUTF8StringEncoding)
        hoedown_document_free(document)
        hoedown_buffer_free(ob)
        return result
    }
}