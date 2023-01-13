//
//  NetworkManager.swift
//  task_4
//
//  Created by Artem Sulzhenko on 30.12.2022.
//

import Foundation

class NetworkManager {

    static private let jsonUrlAtm = "https://belarusbank.by/api/atm"
    static private let jsonUrlInformationStands = "https://belarusbank.by/api/infobox"
    static private var jsonUrlBank = "https://belarusbank.by/api/filials_info"

    static var statusCodeAtm = 0
    static var statusCodeInformationStands = 0
    static var statusCodBank = 0

    static func fetchDataAtm(completion: @escaping ([ATM]) -> Void) {
        guard let url = URL(string: jsonUrlAtm) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse {
                statusCodeAtm = response.statusCode
            }

            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(ATMList.self, from: data) else { return }
            let ATMs = result

            DispatchQueue.main.async {
                completion(ATMs)
            }
        }.resume()
    }

    static func fetchDataInformationStand(completion: @escaping ([InformationStand]) -> Void) {
        guard let url = URL(string: jsonUrlInformationStands) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse {
                statusCodeInformationStands = response.statusCode
            }

            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(InformationStandList.self, from: data) else { return }
            let informationStands = result

            DispatchQueue.main.async {
                completion(informationStands)
            }
        }.resume()
    }

    static func fetchDataBank(completion: @escaping ([Bank]) -> Void) {
        guard let url = URL(string: jsonUrlBank) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse {
                statusCodBank = response.statusCode
            }

            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(BankList.self, from: data) else { return }
            let banks = result

            DispatchQueue.main.async {
                completion(banks)
            }
        }.resume()
    }
}
