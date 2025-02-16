//
//  ContentView.swift
//  Wallet
//
//

import SwiftUI

struct ContentView: View {
    @State private var showTerms = false
    @State private var holderName: String = ""
    @State private var bank: String = ""
    @State private var type: CardType = .visa
    @State private var number: String = ""
    @State private var validity: Date = Date()
    @State private var secureCode: String = ""
    @State private var color: Color = Colors.blue
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("SIGNITURE")
                {
                    TextField("Card Holder Name", text: $holderName)
                    TextField("Bank", text: $bank)
                    // https://sarunw.com/posts/swiftui-picker-enum/
                    Picker("Card Type", selection: $type) {
                        ForEach(CardType.allCases, id: \.self) { type in // \.self uniquily identify each data member
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }.pickerStyle(.automatic)
                }
                
                
                Section("Details") {
                    TextField("Card Number", text: $number)
                    TextField("Secure Code", text: $secureCode)
                    DatePicker(
                        "Valid Through",
                        selection: $validity,
                        displayedComponents: [.date]
                    ) // We can add more attribute here like [.hourAndMinute, ...]
                    .datePickerStyle(.compact) // Change the style here (e.g., .compact, .graphical)
                    //.labelsHidden() // Hide labels for the wheel style
                    
                    
                    
                }
                // https://stackoverflow.com/questions/60521454/swift-color-picker-for-user
                // https://www.youtube.com/watch?v=cvlNnyDi6o8
                Section("Card Color") {
                    HStack(spacing: 40) {
                        ForEach(Colors.all, id: \.self) { color in
                            colorCircle(color: color, isSelected: self.color == color)
                                .onTapGesture {
                                    self.color = color
                                }
                        }
                    }
                    .padding()
                    
                    
                    
                }
                
                Section() {
                    Button("Add Card to Wallet") {
                        showTerms = true
                    }
                    
                }
            }
            .navigationTitle("Add Card")
            .sheet(isPresented: $showTerms) {
                // card view: https://www.hackingwithswift.com/books/ios-swiftui/designing-a-single-card-view
                let card = CardDetails(holderName: holderName, bank: bank, type: type, number: number, validity: validity, secureCode: secureCode, color: color)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-render-a-gradient
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [card.color, .black]), startPoint: .leading, endPoint: .trailing
                            )
                        )
                    
                    VStack (alignment: .leading, spacing: 10){
                        HStack {
                            Text(card.bank.uppercased())
                                .tracking(2)
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(card.type.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        Text(card.holderName)
                            .bold(true)
                            .tracking(1.3)
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("Valid Thru: \(CardDetails.dateFormatter.string(from: validity))")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            
                            
                            Text("Secure code: \(secureCode)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        
                        Text("\(formatNumber(card.number))")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        
                        
                        
                    }
                    .padding(20)
                    .frame(width: 337.5, height: 212.5)
                }
                .padding(20)
                .presentationDetents([.height(262.5)])
            }
            
        }
    }
    
    func formatNumber(_ string: String) -> String {
        var formatted = string
        if string.count > 3 {
            formatted.insert(" ", at: formatted.index(formatted.startIndex, offsetBy: 4))
        }
        if string.count > 8 {
            formatted.insert(" ", at: formatted.index(formatted.startIndex, offsetBy: 9))
        }
        if string.count > 13 {
            formatted.insert(" ", at: formatted.index(formatted.startIndex, offsetBy: 14))
        }
        
        return formatted
    }
    
    @ViewBuilder
    private func colorCircle(color: Color, isSelected: Bool) -> some View {
        Circle()
            .fill(color)
            .frame(width: 30, height: 30)
            .opacity(1)
            .overlay(
                Circle()
                    .fill(color)
                    .opacity(isSelected ? 1 : 0.1)
                    .shadow(radius: isSelected ? 4 : 0)
                    .frame(width: isSelected ? 40 : 30, height: isSelected ? 40 : 30)
            )
    }
                
    

    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
