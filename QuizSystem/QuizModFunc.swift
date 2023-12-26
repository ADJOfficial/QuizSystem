//
//  QuizModFunc.swift
//  QuizSystem
//
//  Created by ADJ on 26/12/2023.
//

import Foundation

struct Quiz: Hashable , Codable {

    var id: Int = 0
    var question: String
    var optionA: String
    var optionB: String
    var optionC: String
    var optionD: String
    var correctAnswer: String
}
//
class ViewModel: ObservableObject {

    @Published var crs: [Quiz] = []

    func fetchApiData() {
        guard let url = URL(string: "http://localhost:7862/mcqs")

        else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in

            guard let data = data , error == nil

            else {
                return
            }

            // Convert to JSON

            do{
                let cars = try JSONDecoder().decode([Quiz].self, from: data)
                DispatchQueue.main.async {
                    self?.crs = cars
                }
            }
            catch{
                print("Error While Getting Data")
            }
        }
        task.resume()
    }
}
