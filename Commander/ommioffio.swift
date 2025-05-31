import SwiftUI
import Combine

class RegistrationViewModel: ObservableObject {
    enum Step {
        case name
        case email
        case confirmation
    }

    @Published var currentStep: Step = .name
    
    @Published var name: String = ""
    @Published var email: String = ""
    
    func nextStep() {
        switch currentStep {
        case .name:
            currentStep = .email
        case .email:
            currentStep = .confirmation
        case .confirmation:
            break
        }
    }
    
    func previousStep() {
        switch currentStep {
        case .email:
            currentStep = .name
        case .confirmation:
            currentStep = .email
        case .name:
            break
        }
    }
}
struct NameStepView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Step 1: Inserisci il tuo nome")
            TextField("Nome", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            
            Button("Avanti") {
                viewModel.nextStep()
            }.disabled(viewModel.name.isEmpty)
        }
    }
}


struct EmailStepView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Step 2: Inserisci la tua email")
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            HStack {
                Button("Indietro") {
                    viewModel.previousStep()
                }
                Spacer()
                Button("Avanti") {
                    viewModel.nextStep()
                }.disabled(viewModel.email.isEmpty)
            }
        }
    }
}


struct ConfirmationStepView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Conferma i tuoi dati")
                .font(.headline)
            Text("Nome: \(viewModel.name)")
            Text("Email: \(viewModel.email)")
            
            HStack {
                Button("Indietro") {
                    viewModel.previousStep()
                }
                Spacer()
                Button("Conferma Registrazione") {
                    // Azione finale, ad esempio invio dati
                    print("Registrazione completata!")
                }
            }
        }
    }
}


struct RegistrationFlowView: View {
    @StateObject var viewModel = RegistrationViewModel()

    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .name:
                NameStepView()
            case .email:
                EmailStepView()
            case .confirmation:
                ConfirmationStepView()
            }
        }
        .environmentObject(viewModel)
        .animation(.easeInOut, value: viewModel.currentStep)
        .padding()
    }
}



#Preview{
    RegistrationFlowView()
}
