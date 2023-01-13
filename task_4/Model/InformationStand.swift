//
//  InformationStand.swift
//  Test
//
//  Created by Artem Sulzhenko on 10.01.2023.
//

import Foundation
import MapKit

class InformationStand: BelarusBank, Codable {

    override var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(gpsX) ?? 0,
                                      longitude: Double(gpsY) ?? 0)
    }
    override var cityB: String {
        return city
    }

    let infoId: Int
    let area: Area
    let cityType: CityType
    let city: String
    let addressType: AddressType
    let address, house, installPlace, locationNameDesc: String
    let workTime, timeLong, gpsX, gpsY: String
    let currency: InformationStandCurrency
    let infType: ATMTypeEnum
    let cashInExist, cashIn, typeCashIn, infPrinter: ATMError
    let regionPlatej, popolneniePlatej, infStatus: ATMError

    enum CodingKeys: String, CodingKey {
        case infoId = "info_id"
        case area
        case cityType = "city_type"
        case city
        case addressType = "address_type"
        case address, house
        case installPlace = "install_place"
        case locationNameDesc = "location_name_desc"
        case workTime = "work_time"
        case timeLong = "time_long"
        case gpsX = "gps_x"
        case gpsY = "gps_y"
        case currency
        case infType = "inf_type"
        case cashInExist = "cash_in_exist"
        case cashIn = "cash_in"
        case typeCashIn = "type_cash_in"
        case infPrinter = "inf_printer"
        case regionPlatej = "region_platej"
        case popolneniePlatej = "popolnenie_platej"
        case infStatus = "inf_status"
    }

    init(infoId: Int, area: Area, cityType: CityType, city: String, addressType: AddressType, address: String,
         house: String, installPlace: String, locationNameDesc: String, workTime: String, timeLong: String,
         gpsX: String, gpsY: String, currency: InformationStandCurrency, infType: ATMTypeEnum, cashInExist: ATMError,
         cashIn: ATMError, typeCashIn: ATMError, infPrinter: ATMError, regionPlatej: ATMError,
         popolneniePlatej: ATMError, infStatus: ATMError) {
        self.infoId = infoId
        self.area = area
        self.cityType = cityType
        self.city = city
        self.addressType = addressType
        self.address = address
        self.house = house
        self.installPlace = installPlace
        self.locationNameDesc = locationNameDesc
        self.workTime = workTime
        self.timeLong = timeLong
        self.gpsX = gpsX
        self.gpsY = gpsY
        self.currency = currency
        self.infType = infType
        self.cashInExist = cashInExist
        self.cashIn = cashIn
        self.typeCashIn = typeCashIn
        self.infPrinter = infPrinter
        self.regionPlatej = regionPlatej
        self.popolneniePlatej = popolneniePlatej
        self.infStatus = infStatus
    }
}

enum InformationStandCurrency: String, Codable {
    case byn = "BYN,"
    case bynRub = "BYN,RUB,"
    case empty = ""
}

typealias InformationStandList = [InformationStand]
