//
//  Properties.swift
//  CouchbaseLite
//
//  Created by Jens Alfke on 2/9/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation

/** Properties defines a JSON-compatible object, much like a Dictionory but with
 type-safe accessors. It is implemented by classes Document and Subdocument. */
public class Properties {
    /** All of the properties contained in this object. */
    public var properties : [String:Any]? {
        get {return convertProperties(_impl.properties, isGetter: true)}
        set {_impl.properties = convertProperties(newValue, isGetter: false)}
    }

    /** Gets an property's value as an object. Returns types NSNull, Number, String, Array, 
     Dictionary, and Blob, based on the underlying data type; or nil if the property doesn't
     exist. */
    public func getValue(_ key: String) -> Any? {
        return convertValue(_impl.object(forKey: key), isGetter: true)
    }
    
    public func getBool(_ key: String) -> Bool {
        return _impl.boolean(forKey: key)
    }
    
    public func getInt(_ key: String) -> Int {
        return _impl.integer(forKey: key)
    }
    
    public func getFloat(_ key: String) -> Float {
        return _impl.float(forKey: key)
    }
    
    public func getDouble(_ key: String) -> Double {
        return _impl.double(forKey: key)
    }
    
    public func getString(_ key: String) -> String? {
        return _impl.string(forKey: key)
    }
    
    public func getDate(_ key: String) -> Date? {
        return _impl.date(forKey: key)
    }
    
    public func getBlob(_ key: String) -> Blob? {
        return _impl.blob(forKey: key)
    }
    
    public func getSubdocument(_ key: String) -> Subdocument? {
        return getValue(key) as? Subdocument
    }
    
    /** Sets a property value by key.
     Allowed value types are NSNull, Number, String, Array, Dictionary, Date,
     Subdocument, and Blob. Arrays and Dictionaries must contain only the above types.
     Setting a nil value will remove the property.
     
     Note:
     * A Date object will be converted to an ISO-8601 format string.
     * When setting a subdocument, the subdocument will be set by reference. However,
     if the subdocument has already been set to another key either on the same or different
     document, the value of the subdocument will be copied instead. */
    public func setValue(_ key: String, _ value: Any?) -> Self {
        _impl.setObject(convertValue(value, isGetter: false), forKey: key)
        return self
    }

    /** Tests whether a property exists or not.
     This can be less expensive than calling property(key):, because it does not have to allocate an
     object for the property value. */
    public func contains(_ key: String) -> Bool {
        return _impl.containsObject(forKey: key)
    }
    

    /** Gets an property's value as an object. Returns types NSNull, Number, String, Array,
     Dictionary, and Blob, based on the underlying data type; or nil if the property doesn't
     exist. */
    public subscript(key: String) -> PropertyValue {
        get {return PropertyValue(getValue(key))}
        set {_ = setValue(key, newValue.value)}
    }
    
    // MARK: Internal

    init(_ impl: CBLProperties) {
        _impl = impl
    }

    let _impl: CBLProperties
    
    func convertProperties(_ properties: [String: Any]?, isGetter: Bool) -> [String: Any]? {
        if let props = properties {
            var result: [String: Any] = [:]
            for (key, value) in props {
                result[key] = convertValue(value, isGetter: isGetter)
            }
            return result
        }
        return nil
    }
    
    func convertValue(_ value: Any?, isGetter: Bool) -> Any? {
        switch value {
        case let subdoc as Subdocument:
            return isGetter ? subdoc : subdoc._subdocimpl
        case let implSubdoc as CBLSubdocument:
            if isGetter {
                if let subdoc = implSubdoc.swiftSubdocument {
                    return subdoc
                }
                return Subdocument(implSubdoc)
            }
            return implSubdoc
        case let array as [Any]:
            var result: [Any] = [];
            for v in array {
                result.append(convertValue(v, isGetter: isGetter)!)
            }
            return result
        default:
            return value
        }
    }
}

public typealias Blob = CBLBlob
