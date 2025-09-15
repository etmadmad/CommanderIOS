import Foundation
import CoreNFC

class NFCReaderViewModel: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var scannedText: String = "Nessun dato"
    private var session: NFCNDEFReaderSession?

    func startScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            scannedText = "❌ Questo device non supporta NFC"
            return
        }
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Avvicina l’iPhone al tag NFC"
        session?.begin()
    }

    // MARK: - Delegate
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.scannedText = "Errore: \(error.localizedDescription)"
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let text = String(data: record.payload, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.scannedText = text
                    }
                }
            }
        }
    }
}
