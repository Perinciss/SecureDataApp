//
//  ContentView.swift
//  SecureDataApp
//
//  Created by Kevin Heryanto on 07/09/2566 BE.
//

import SwiftUI
import CryptoKit



struct ContentView: View {
    @State var inputdata = ""
    @State var text: String = UserDefaults.standard.string(forKey: "Data_Encrypted") ?? ""
    @State var text1: String = UserDefaults.standard.string(forKey: "Data_Decrypted") ?? ""
    
    let key = SymmetricKey(size: .bits256)
    
    var body: some View {
        Form {
            Section(header: Text("Input Data")){
                TextField("Masukkan Data", text: $inputdata)
            }
            
            Section(header: Text("Encrypt & Save Data")){
                Button("Encrypt & Save Data"){
                    if let encrypted = encryptData(data: inputdata.data(using: .utf8)!, key: key){
                        UserDefaults.standard.set(encrypted, forKey: "Data_Encrypted")
                        text = String(decoding: encrypted, as: UTF8.self)
                    }
                    
                }
            }
            Section(header: Text("Data Tersimpan & Terenkripsi")){
                Text(text)
            }
            Section(header: Text("Decrypt Data")){
                Button("Decrypt Data"){
                    if let data = UserDefaults.standard.data(forKey: "Data_Encrypted"){
                        if let decryptedData = decryptData(encryptedData: data, key: key) {
                            text1 = String(data: decryptedData, encoding: .utf8) ?? "Ga Masop"
                        }
                        
                    }
                    }
                }
                Section(header: Text("Data Terdecrypt")){
                    Text(text1)
                    
                }
                .padding()
            }
        }
    }
    
    func encryptData(data: Data, key: SymmetricKey) -> Data? {
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            print("Encryption failed: \(error)")
            return nil
        }
    }
    
    func decryptData(encryptedData: Data, key: SymmetricKey) -> Data? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return decryptedData
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
