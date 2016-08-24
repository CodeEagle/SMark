//
//  SMarkConfigurator.swift
//  SMark
//
//  Created by LawLincoln on 16/8/23.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import Foundation
import SMark

let UserDefault = NSUserDefaults.standardUserDefaults()

public final class Configurator {
    public var tags: [SMark.HTML.Tag] = [.none]
    public var extensions: [SMark.HTML.Extension] = [.none]
    public var codeBlockAccessory: SMark.CodeBlockAccessory = .none
    public var tocRenderEnable = false
    public var htmlTemplateName = "Default"
}

public struct SMark {
    
    public struct HTML {
        public enum Tag: UInt32 {
            case none, skipHTML, escape, hardWrap, useXHTML, useTaskList, blockcodeLineNumber, blockcodeInfomation
            static func flags(from tags: [Tag]) -> hoedown_html_flags {
                var raw: UInt32 = 0
                for tag in tags {  raw |=  1 << tag.rawValue }
                return hoedown_html_flags(raw)
            }
        }
        public enum Extension: UInt32 {
            case none, tables, fencedCode, footnotes, autolink, strikethrough, underline, highlight, quote,  superscript, math, noIntraEmphasis, spaceHeaders, mathExplicit, disableIndentedCode
            static func flags(from tags: [Extension]) -> hoedown_extensions {
                var raw: UInt32 = 0
                for tag in tags {  raw |= 1 << tag.rawValue }
                return hoedown_extensions(raw)
            }
        }
    }
    
    public enum CodeBlockAccessory: Int { case none, languageName, custom }
}


 