//
//  JavaScriptConfiguration.swift
//  CodeEditorView
//
//  Created by Copilot on 2025/11/28.
//

import Foundation
import RegexBuilder


private let javaScriptReservedIdentifiers = [
  // Keywords
  "break", "case", "catch", "continue", "debugger", "default", "delete", "do", "else", "finally",
  "for", "function", "if", "in", "instanceof", "new", "return", "switch", "this", "throw", "try",
  "typeof", "var", "void", "while", "with",
  // ES6+ keywords
  "class", "const", "export", "extends", "import", "let", "super", "yield", "async", "await",
  "static",
  // Literals
  "true", "false", "null", "undefined", "NaN", "Infinity",
  // Future reserved words
  "enum", "implements", "interface", "package", "private", "protected", "public"
]

private let javaScriptReservedOperators = [
  ".", ",", ":", ";", "=", "@", "?", "!", "&", "|", "^", "~", "+", "-", "*", "/", "%", "<", ">",
  "=>", "...", "++", "--", "**", "==", "!=", "===", "!==", "<=", ">=", "&&", "||", "??", "?.",
  "+=", "-=", "*=", "/=", "%=", "**=", "<<=", ">>=", ">>>=", "&=", "|=", "^=", "&&=", "||=", "??="
]

extension LanguageConfiguration {

  /// Language configuration for JavaScript
  ///
  public static func javaScript(_ languageService: LanguageService? = nil) -> LanguageConfiguration {
    let numberRegex: Regex<Substring> = Regex {
      optNegation
      ChoiceOf {
        Regex { /0[bB]/; binaryLit }
        Regex { /0[oO]/; octalLit }
        Regex { /0[xX]/; hexalLit }
        Regex { decimalLit; "."; decimalLit; Optionally { exponentLit } }
        Regex { decimalLit; exponentLit }
        Regex { "."; decimalLit; Optionally { exponentLit } }
        decimalLit
      }
      Optionally { /n/ }  // BigInt suffix
    }
    let plainIdentifierRegex: Regex<Substring> = Regex {
      ChoiceOf {
        identifierHeadCharacters
        "$"
      }
      ZeroOrMore {
        ChoiceOf {
          identifierCharacters
          "$"
        }
      }
    }
    let identifierRegex = plainIdentifierRegex
    let operatorRegex = Regex {
      ChoiceOf {

        Regex {
          operatorHeadCharacters
          ZeroOrMore {
            operatorCharacters
          }
        }

        Regex {
          "."
          OneOrMore {
            CharacterClass(operatorCharacters, .anyOf("."))
          }
        }
      }
    }
    return LanguageConfiguration(name: "JavaScript",
                                 supportsSquareBrackets: true,
                                 supportsCurlyBrackets: true,
                                 stringRegex: /\"(?:\\\"|[^\"\n])*\"|'(?:\\'|[^'\n])*'|`(?:\\`|[^`])*`/,
                                 characterRegex: nil,
                                 numberRegex: numberRegex,
                                 singleLineComment: "//",
                                 nestedComment: (open: "/*", close: "*/"),
                                 identifierRegex: identifierRegex,
                                 operatorRegex: operatorRegex,
                                 reservedIdentifiers: javaScriptReservedIdentifiers,
                                 reservedOperators: javaScriptReservedOperators,
                                 languageService: languageService)
  }
}
