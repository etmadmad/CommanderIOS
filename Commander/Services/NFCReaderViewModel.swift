import Foundation
import SwiftUI
import CoreNFC
import Combine

class NFCDetectViewModel: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    @Published var bombDefused: Bool = false
    private var session: NFCTagReaderSession?
    private var timerCancellable: AnyCancellable?
    
    private var defuseProgress = 0
    private var defuseTimeRequired = 0
    private var bombCode: String = ""
    

    @Published var status: String = "Nessun dato"

    var onBombDefused: (() -> Void)?
     
     func startScan(expectedBombCode: String, defuseTime: Int) {
         guard NFCTagReaderSession.readingAvailable else {
             status = "NFC not available on this device"
             return
         }
         
         status = "Listening..."
         session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
         session?.alertMessage = "Tap your device on the NFC tag for \(defuseTime) seconds"
         session?.begin()
         print("NFC SESSION - started")
         
    
         DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(defuseTime)) {
             DispatchQueue.main.async {
                 self.onBombDefused?()
             }
         }
     }
    
    
    // MARK: - Delegate
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let first = tags.first else { return }
        
        var uidHex: String?
        switch first {
        case .miFare(let mifare):
            uidHex = mifare.identifier.map { String(format: "%02x", $0) }.joined()
        case .iso7816(let isoTag):
            uidHex = isoTag.identifier.map { String(format: "%02x", $0) }.joined()
        case .iso15693(let tag):
            uidHex = tag.identifier.map { String(format: "%02x", $0) }.joined()
        default:
            session.invalidate(errorMessage: "NFC tag not supported on this device")
            return
        }
        
        guard let detected = uidHex else { return }
        
        
        if detected.lowercased() == bombCode {
            print("correct UID: \(detected)")
            startDefuseTimer(session: session)
        } else {
            print("UID doesn't match")
            session.invalidate(errorMessage: "Bomb Exploded💥")
        }
    }
    
    private func startDefuseTimer(session: NFCTagReaderSession) {
        timerCancellable?.cancel()
        defuseProgress = 0
        
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.defuseProgress += 1
                session.alertMessage = "Defusing in progress... \(self.defuseProgress)/\(self.defuseTimeRequired)"
                session.alertMessage = "Defusing in progress... \(self.defuseProgress)/\(self.defuseTimeRequired)"
                
                if self.defuseProgress >= self.defuseTimeRequired {
                    self.bombDefused = true
                    session.alertMessage = "Bomba Defused!"
                    session.invalidate()
                    self.timerCancellable?.cancel()
                }
            }
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("NFC SESSION - open")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("NFC SESSION - closed: \(error.localizedDescription)")
        timerCancellable?.cancel()
    }
}
