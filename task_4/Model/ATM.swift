//
//  ATM.swift
//  task_4
//
//  Created by Artem Sulzhenko on 10.01.2023.
//

import Foundation
import MapKit

class ATM: BelarusBank, Codable {

    override var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(gpsX) ?? 0,
                                      longitude: Double(gpsY) ?? 0)
    }
    override var cityB: String {
        return city
    }
    
    let id: String
    let area: Area
    let cityType: CityType
    let city: String
    let addressType: AddressType
    let address, house, installPlace, workTime: String
    let gpsX, gpsY, installPlaceFull, workTimeFull: String
    let atmType: ATMTypeEnum
    let atmError: ATMError
    let currency: ATMCurrency
    let cashIn, atmPrinter: ATMError

    enum CodingKeys: String, CodingKey {
        case id, area
        case cityType = "city_type"
        case city
        case addressType = "address_type"
        case address, house
        case installPlace = "install_place"
        case workTime = "work_time"
        case gpsX = "gps_x"
        case gpsY = "gps_y"
        case installPlaceFull = "install_place_full"
        case workTimeFull = "work_time_full"
        case atmType = "ATM_type"
        case atmError = "ATM_error"
        case currency
        case cashIn = "cash_in"
        case atmPrinter = "ATM_printer"
    }

    init(id: String, area: Area, cityType: CityType, city: String, addressType: AddressType, address: String, house: String, installPlace: String, workTime: String, gpsX: String, gpsY: String, installPlaceFull: String, workTimeFull: String, atmType: ATMTypeEnum, atmError: ATMError, currency: ATMCurrency, cashIn: ATMError, atmPrinter: ATMError) {
        self.id = id
        self.area = area
        self.cityType = cityType
        self.city = city
        self.addressType = addressType
        self.address = address
        self.house = house
        self.installPlace = installPlace
        self.workTime = workTime
        self.gpsX = gpsX
        self.gpsY = gpsY
        self.installPlaceFull = installPlaceFull
        self.workTimeFull = workTimeFull
        self.atmType = atmType
        self.atmError = atmError
        self.currency = currency
        self.cashIn = cashIn
        self.atmPrinter = atmPrinter
    }
}

enum AddressType: String, Codable {
    case addressType = " "
    case addressTypeStreet = "ул. "
    case empty = ""
    case purple = "-"
    case бР = "б-р"
    case бул = "бул."
    case др = "др."
    case мкр = "мкр."
    case пер = "пер."
    case пл = "пл."
    case пос = "пос."
    case пр = "пр."
    case радОбщПользЯ = "РАД общ. польз-я"
    case ст = "ст."
    case тракт = "тракт"
    case ул = "ул."
    case шоссе = "шоссе"
}

enum Area: String, Codable {
    case брестская = "Брестская"
    case витебская = "Витебская"
    case гомельская = "Гомельская"
    case гродненская = "Гродненская"
    case минск = "Минск"
    case минская = "Минская"
    case могилевская = "Могилевская"
}

enum ATMError: String, Codable {
    case да = "да"
    case нет = "нет"
}

enum ATMTypeEnum: String, Codable {
    case внешний = "Внешний"
    case внутренний = "Внутренний"
    case уличный = "Уличный"
}

enum CityType: String, Codable {
    case empty = ""
    case аг = "аг."
    case г = "г."
    case гП = "г.п."
    case гп = "гп"
    case д = "д."
    case кП = "к.п."
    case кп = "кп"
    case п = "п."
    case рН = "р-н"
    case рп = "рп"
    case сС = "с/с"
}

enum ATMCurrency: String, Codable {
    case byn = "BYN   "
    case bynUsd = "BYN   USD   "
    case empty = ""
}

typealias ATMList = [ATM]
