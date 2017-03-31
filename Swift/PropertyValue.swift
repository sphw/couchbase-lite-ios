//
//  PropertyValue.swift
//  CouchbaseLite
//
//  Created by Pasin Suriyentrakorn on 3/30/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation

public final class PropertyValue {
    let _value: Any?
    
    public init (_ value: Any?) {
        _value = value
    }
    
    public var value: Any? {
        return _value
    }
    
    public var bool: Bool {
        if let v = _value as? Bool {
            return v
        }
        return false
    }
    
    public var int: Int {
        if let v = _value as? Int {
            return v
        } else if let v = _value as? NSNumber {
            return v.intValue
        }
        return 0
    }
    
    public var float: Float {
        if let v = _value as? Float {
            return v
        } else if let v = _value as? NSNumber {
            return v.floatValue
        }
        return 0.0
    }
    
    public var double: Double {
        if let v = _value as? Double {
            return v
        } else if let v = _value as? NSNumber {
            return v.doubleValue
        }
        return 0.0
    }
    
    public var string: String? {
        return _value as? String
    }
    
    public var date: Date? {
        return _value as? Date
    }
    
    public var blob: Blob? {
        return _value as? Blob
    }
    
    public var subdocument: Subdocument? {
        return _value as? Subdocument
    }
    
    public subscript(key: String) -> PropertyValue {
        get {
            if let props = _value as? Properties {
                return props[key]
            }
            return PropertyValue(nil)
        }
        set {
            if let props = _value as? Properties {
                _ = props.setValue(key, newValue.value)
            }
            // TODO: 
            // Should we throw an error or have an error property if 
            // the _value is not a Properties?
        }
    }
    
    public subscript(index: Int) -> PropertyValue {
        get {
            if let a = _value as? Array<Any> {
                return PropertyValue(a.count > index ? a[index]: nil)
            }
            return PropertyValue(nil)
        }
    }
}

extension PropertyValue: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral,
    ExpressibleByBooleanLiteral, ExpressibleByFloatLiteral, ExpressibleByArrayLiteral,
    ExpressibleByDictionaryLiteral, ExpressibleByNilLiteral
{
    // MARK: Integer
    public convenience init(integerLiteral value: Int) {
        self.init(value)
    }
    
    // MARK: String
    public convenience init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public convenience init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public convenience init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    // MARK: Boolean
    public convenience init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
    
    // MARK: Float
    public convenience init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
    
    // MARK: Array
    public convenience init(arrayLiteral elements: Any...) {
        self.init(elements)
    }
    
    // MARK: Dictionary
    public convenience init(dictionaryLiteral elements: (String, Any)...) {
        var dict = [String: Any](minimumCapacity: elements.count)
        for e in elements {
            dict[e.0] = e.1
        }
        self.init(dict)
    }
    
    // MARK: Nil
    public convenience init(nilLiteral: ()) {
        self.init(nil)
    }
}
