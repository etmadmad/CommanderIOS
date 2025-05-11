import Foundation
import Security

struct KeychainService {
    
    static func savePassword(_ password: String, for account: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }

        // Elimina se esiste già
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account
        ] as CFDictionary
        SecItemDelete(query)

        // Aggiungi nuova entry
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecValueData: passwordData
        ] as CFDictionary

        let status = SecItemAdd(attributes, nil)
        return status == errSecSuccess
    }

    static func getPassword(for account: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let password = String(data: data, encoding: .utf8)
        else { return nil }

        return password
    }

    static func deletePassword(for account: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account
        ] as CFDictionary

        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
}

