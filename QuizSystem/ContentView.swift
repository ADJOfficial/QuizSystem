//
//  ContentView.swift
//  CheckScroll
//
//  Created by ADJ on 19/12/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var selectedOption: Int?
    @State private var correctAnswers: Int = 0
    @State private var isFetchingData = false
    @State private var currentIndex = 0 // Track the current question index
    @State private var quizCompleted = false // Track if the quiz is completed

    var body: some View {
        NavigationView {
            VStack {
                Button("Start Quiz") {
                    isFetchingData = true
                    viewModel.fetchApiData()
                }
                .padding()
                .font(.title)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(30)

                if isFetchingData {
                    if currentIndex < viewModel.crs.count {
                        let currentQuestion = viewModel.crs[currentIndex]

                        List {
                            VStack {
                                Text(currentQuestion.question)
                                Group {
                                    Toggle(isOn: Binding(
                                            get: { self.selectedOption == 1 },
                                            set: { if $0 { self.selectedOption = 1 } }
                                    )) {
                                        Text(currentQuestion.optionA)
                                    }
                                    Toggle(isOn: Binding(
                                        get: { self.selectedOption == 2 },
                                        set: { if $0 { self.selectedOption = 2 } }
                                    )) {
                                        Text(currentQuestion.optionB)
                                    }
                                    Toggle(isOn: Binding(
                                        get: { self.selectedOption == 3 },
                                        set: { if $0 { self.selectedOption = 3 } }
                                    )) {
                                        Text(currentQuestion.optionC)
                                    }
                                    Toggle(isOn: Binding(
                                        get: { self.selectedOption == 4 },
                                        set: { if $0 { self.selectedOption = 4 } }
                                    )) {
                                        Text(currentQuestion.optionD)
                                    }
                                }
                            }

                            Button("Next Question") {
                                // Check the selected option and update the logic accordingly
                                if let selectedOption = selectedOption, selectedOption == Int(currentQuestion.correctAnswer) {
                                    correctAnswers += 1
                                }

                                // Increment the index to move to the next question
                                currentIndex += 1
                                // Reset the selected option for the next question
                                selectedOption = nil

                                // Check if all questions are completed
                                if currentIndex >= viewModel.crs.count {
                                    quizCompleted = true
                                }
                            }
                            .padding()
                            .font(.title)
                            .foregroundColor(.white)
                            .background(Color.yellow)
                            .cornerRadius(30)
                        }
                        .navigationTitle("Quiz")
                        .onAppear {
                            if isFetchingData {
                                viewModel.fetchApiData()
                            }
                        }
                    } else if quizCompleted {
                        NavigationLink(destination: ResultView(totalQuestions: viewModel.crs.count, correctAnswer: correctAnswers)) {
                            Text("Quiz completed!")
                        }
                    }
                }
            }
        }
    }
}

struct ResultView: View {
    let totalQuestions: Int
    let correctAnswer: Int
    var body: some View {
        VStack {
            Text("Quiz Results")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("Total Questions: \(totalQuestions)")
            Text("Correct Answers: \(correctAnswer)")
            Text("Percentage: \(Double(correctAnswer) / Double(totalQuestions) * 100, specifier: "%.2f")%")
            
            Spacer()
        }
        .navigationBarTitle("Results", displayMode: .inline)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}













// MongoDB Queries
//{
//  "id": 2,
//  "question": "YoYo Honey Singh is a Famous",
//  "optionA": "Actor",
//  "optionB": "Clerk",
//  "optionC": "Brand",
//  "optionD": "Officier",
//  "correctAnswer": "Brand"
//}
