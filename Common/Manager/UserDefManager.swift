//
//  UserDefManager.swift
//  WonderBox
//
//  Created by link on 2023/2/23.
//

import Foundation

struct UserDefManager {
    
    private init() {}
    
    /// 保存对象
    static func setObject<T:Encodable>(key: String, object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            set(key: key, value: data)
        } catch {
            print(error)
        }
    }
    /// 读取对象
    static func getObject<T: Decodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
        }
        return nil
    }
    /// 保存对象数组
    static func setObjectArray<T:Encodable>(key: String, objectArray: [T]) {
        do {
            let data = try JSONEncoder().encode(objectArray)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    /// 读取对象数组
    static func getObjectArray<T: Decodable>(key: String) -> [T] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print(error)
        }
        return []
    }
    
    /// -----------------------------------------
    /// 保存数据
    static func set(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /// 读取字符串
    static func getString(key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    /// 读取整数
    static func getInt(key: String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
    /// 读取小数
    static func getDouble(key: String) -> Double {
        return UserDefaults.standard.double(forKey: key)
    }
    /// 读取布尔值
    static func getBool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    /// 读取字符串数组
    static func getStringArray(key: String) -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    /// 删除数据
    static func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
