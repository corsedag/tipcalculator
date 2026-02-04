//
//  ContentView.swift
//  TipCalculator
//
//  Created by Shipyard IDE
//

import SwiftUI

struct ContentView: View {
    @State private var billAmount: String = ""
    @State private var tipPercentage: Double = 18
    @State private var numberOfPeople: Int = 1
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 18, 20, 24]
    
    var billValue: Double {
        Double(billAmount) ?? 0
    }
    
    var tipAmount: Double {
        billValue * (tipPercentage / 100)
    }
    
    var totalAmount: Double {
        billValue + tipAmount
    }
    
    var amountPerPerson: Double {
        guard numberOfPeople > 0 else { return totalAmount }
        return totalAmount / Double(numberOfPeople)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    Text("Tip Calculator")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 16)
                    
                    // Bill Amount
                    VStack(alignment: .leading, spacing: 12) {
                        Text("BILL AMOUNT")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.5))
                            .tracking(1)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$")
                                .font(.system(size: 32, weight: .light, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.6))
                            
                            TextField("0", text: $billAmount)
                                .font(.system(size: 56, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .keyboardType(.decimalPad)
                                .focused($amountIsFocused)
                                .accessibilityIdentifier("billAmountField")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // Tip Selection
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("TIP")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.5))
                                .tracking(1)
                            
                            Spacer()
                            
                            Text("\(Int(tipPercentage))%")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(tipPercentages, id: \.self) { pct in
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        tipPercentage = Double(pct)
                                    }
                                } label: {
                                    Text("\(pct)%")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(Int(tipPercentage) == pct ? .black : .white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Int(tipPercentage) == pct ? .white : Color.white.opacity(0.1))
                                        )
                                }
                                .accessibilityIdentifier("tip\(pct)Button")
                            }
                        }
                        
                        Slider(value: $tipPercentage, in: 0...30, step: 1)
                            .tint(.white)
                            .accessibilityIdentifier("tipSlider")
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // Split
                    VStack(spacing: 16) {
                        Text("SPLIT")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.5))
                            .tracking(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Button {
                                if numberOfPeople > 1 {
                                    withAnimation(.spring(response: 0.25)) {
                                        numberOfPeople -= 1
                                    }
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Circle().fill(Color.white.opacity(0.1)))
                            }
                            .accessibilityIdentifier("decreasePeople")
                            
                            Spacer()
                            
                            VStack(spacing: 2) {
                                Text("\(numberOfPeople)")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .contentTransition(.numericText())
                                
                                Text(numberOfPeople == 1 ? "person" : "people")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.5))
                            }
                            .accessibilityIdentifier("peopleStepper")
                            
                            Spacer()
                            
                            Button {
                                if numberOfPeople < 20 {
                                    withAnimation(.spring(response: 0.25)) {
                                        numberOfPeople += 1
                                    }
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .frame(width: 56, height: 56)
                                    .background(Circle().fill(.white))
                            }
                            .accessibilityIdentifier("increasePeople")
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // Summary
                    VStack(spacing: 20) {
                        HStack {
                            Text("Tip")
                                .font(.system(size: 16))
                                .foregroundColor(Color.white.opacity(0.6))
                            Spacer()
                            Text("$\(tipAmount, specifier: "%.2f")")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .accessibilityIdentifier("tipAmountLabel")
                        }
                        
                        HStack {
                            Text("Total")
                                .font(.system(size: 16))
                                .foregroundColor(Color.white.opacity(0.6))
                            Spacer()
                            Text("$\(totalAmount, specifier: "%.2f")")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .accessibilityIdentifier("totalLabel")
                        }
                        
                        if numberOfPeople > 1 {
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 1)
                                .padding(.vertical, 4)
                            
                            VStack(spacing: 6) {
                                Text("Each pays")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.white.opacity(0.5))
                                
                                Text("$\(amountPerPerson, specifier: "%.2f")")
                                    .font(.system(size: 44, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .accessibilityIdentifier("perPersonLabel")
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                    )
                    
                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onTapGesture {
            amountIsFocused = false
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}