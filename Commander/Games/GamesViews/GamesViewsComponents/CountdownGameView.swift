import SwiftUI

struct CountdownView: View {
    @State private var remainingTime: Int
    @State private var progress: CGFloat
    @State private var timer: Timer?

    let totalTime: Int
    let endDate: Date

    init(totalTime: Int) {
        self.totalTime = totalTime
        self.endDate = Date().addingTimeInterval(TimeInterval(totalTime))
        _remainingTime = State(initialValue: totalTime)
        _progress = State(initialValue: totalTime > 0 ? 1.0 : 0.0)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.2)
                .foregroundColor(.green)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(hex: accentCustomColor))
                .rotationEffect(.degrees(-90))

            Text(formatTime(remainingTime))
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 200)
        
        .onAppear {
            startTimer()
        }
        
        .onDisappear {
            stopTimer()
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            updateRemainingTime()
        }
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateRemainingTime()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateRemainingTime() {
        let diff = Int(endDate.timeIntervalSinceNow)
        if diff > 0 {
            remainingTime = diff
            progress = CGFloat(remainingTime) / CGFloat(totalTime)
        } else {
            remainingTime = 0
            progress = 0.0
            stopTimer()
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        guard seconds > 0 else { return "00:00" }
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
