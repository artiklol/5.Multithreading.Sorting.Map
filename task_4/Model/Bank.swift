//
//  Bank.swift
//  task_4
//
//  Created by Artem Sulzhenko on 10.01.2023.
//

import Foundation
import MapKit

class Bank: BelarusBank, Codable {
    override var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(gpsX) ?? 0,
                                      longitude: Double(gpsY) ?? 0)
    }
    override var cityB: String {
        return city
    }

    let filialId: String
//    let sapId: String
    let filialName: String
//    let cityType: String
    let city: String
//    let addressType: String
//    let address: String
//    let house: String
//    let nameTypePrev: String
//    let namePrev: String
//    let streetTypePrev: String
//    let streetPrev: String
//    let homeNumberPrev: String
//    let infoText: String
//    let infoWorktime: String
//    let infoBankBik: String
//    let infoBankUnp: String
    let gpsX: String
    let gpsY: String
//    let belNumberSchet: String
//    let foreignNumberSchet: String
//    let phoneInfo: String
//    let infoWeekendOneDay: String
//    let infoWeekendTwoDay: String
//    let infoWeekendThreeDay: String
//    let infoWeekendFourDay: String
//    let infoWeekendFiveDay: String
//    let infoWeekendSixDay: String
//    let infoWeekendSevenDay: String
//    let infoWeekendOneTime: String
//    let infoWeekendTwoTime: String
//    let infoWeekendThreeTime: String
//    let infoWeekendFourTime: String
//    let infoWeekendFiveTime: String
//    let infoWeekendSixTime: String
//    let infoWeekendSevenTime: String
//    let dopNum: String
//    let uslBroker: String
//    let uslBuySlitki: String
//    let uslCardInternet: String
//    let uslCennieBumagi: String
//    let uslCheckDoverVnebanka: String
//    let uslChekiGilie: String
//    let uslChekiImuschestvo: String
//    let uslClubBarhat: String
//    let uslClubKartblansh: String
//    let uslClubLedi: String
//    let uslClubNastart: String
//    let uslClubPersona: String
//    let uslClubSchodry: String
//    let uslClubSvoi: String
//    let uslClubZclass: String
//    let uslCoinsExchange: String
//    let uslDepositary: String
//    let uslDepDoverennosti: String
//    let uslDepScheta: String

    enum CodingKeys: String, CodingKey {
        case filialId = "filial_id"
//        case sapId = "sap_id"
        case filialName = "filial_name"
//        case cityType = "name_type"
        case city = "name"
//        case addressType = "street_type"
//        case address = "street"
//        case house = "home_number"
//        case nameTypePrev = "name_type_prev"
//        case namePrev = "name_prev"
//        case streetTypePrev = "street_type_prev"
//        case streetPrev = "street_prev"
//        case homeNumberPrev = "home_number_prev"
//        case infoText = "info_text"
//        case infoWorktime = "info_worktime"
//        case infoBankBik = "info_bank_bik"
//        case infoBankUnp = "info_bank_unp"
        case gpsX = "GPS_X"
        case gpsY = "GPS_Y"
//        case belNumberSchet = "bel_number_schet"
//        case foreignNumberSchet = "foreign_number_schet"
//        case phoneInfo = "phone_info"
//        case infoWeekendOneDay = "info_weekend1_day"
//        case infoWeekendTwoDay = "info_weekend2_day"
//        case infoWeekendThreeDay = "info_weekend3_day"
//        case infoWeekendFourDay = "info_weekend4_day"
//        case infoWeekendFiveDay = "info_weekend5_day"
//        case infoWeekendSixDay = "info_weekend6_day"
//        case infoWeekendSevenDay = "info_weekend7_day"
//        case infoWeekendOneTime = "info_weekend1_time"
//        case infoWeekendTwoTime = "info_weekend2_time"
//        case infoWeekendThreeTime = "info_weekend3_time"
//        case infoWeekendFourTime = "info_weekend4_time"
//        case infoWeekendFiveTime = "info_weekend5_time"
//        case infoWeekendSixTime = "info_weekend6_time"
//        case infoWeekendSevenTime = "info_weekend7_time"
//        case dopNum = "dop_num"
//        case uslBroker = "usl_broker"
//        case uslBuySlitki = "usl_buy_slitki"
//        case uslCardInternet = "usl_card_internet"
//        case uslCennieBumagi = "usl_cennie_bumagi"
//        case uslCheckDoverVnebanka = "usl_check_dover_vnebanka"
//        case uslChekiGilie = "usl_cheki_gilie"
//        case uslChekiImuschestvo = "usl_cheki_imuschestvo"
//        case uslClubBarhat = "usl_club_barhat"
//        case uslClubKartblansh = "usl_club_kartblansh"
//        case uslClubLedi = "usl_club_ledi"
//        case uslClubNastart = "usl_club_nastart"
//        case uslClubPersona = "usl_club_persona"
//        case uslClubSchodry = "usl_club_schodry"
//        case uslClubSvoi = "usl_club_svoi"
//        case uslClubZclass = "usl_club_zclass"
//        case uslCoinsExchange = "usl_coins_exchange"
//        case uslDepositary = "usl_depositariy"
//        case uslDepDoverennosti = "usl_dep_doverennosti"
//        case uslDepScheta = "usl_dep_scheta"
//        "usl_dep_viplati":"1",
//        "usl_docObligac_belarusbank":"1",
//        "usl_dover_upr":"0",
//        "usl_dover_upr_gos":"1",
//        "usl_drag_metal":"1",
//        "usl_ibank":"1",
//        "usl_inkasso_priem":"1",
//        "usl_inkasso_priem_deneg_bel":"1",
//        "usl_int_cards":"1",
//        "usl_izbiz_scheta_operacii":"1",
//        "usl_izbiz_scheta_otkr":"1",
//        "usl_kamni_brill":"0",
//        "usl_konversiya_foreign_val":"1",
//        "usl_loterei":"1",
//        "usl_mo_rb":"1",
//        "usl_operations_bezdokumentar_obligacii":"1",
//        "usl_operations_sber_sertif":"1",
//        "usl_oper_po_sch_otkr_v_rup":"1",
//        "usl_perechislenie_po_rekvizitam_kartochki":"1",
//        "usl_perechislenie_so_scheta_bez_kart":"1",
//        "usl_plategi":"1",
//        "usl_podlinnost_banknot":"1",
//        "usl_pogashenie_documentar_obligacii":"1",
//        "usl_popolnenieSchetaBezKart":"1",
//        "usl_popolnenieSchetaBynIspKarts":"1",
//        "usl_popolnenieSchetaUsdIspKarts":"1",
//        "usl_pov":"1",
//        "usl_priemDocPokupkaObl":"1",
//        "usl_priem_cennostei_na_hranenie":"1",
//        "usl_priem_cennostej_na_hranenie":"1",
//        "usl_priem_docs_fl_depozit_operations":"1",
//        "usl_priem_docs_vidacha_sopr_lgot_ipotech":"1",
//        "usl_priem_doc_na_kredits_overdrafts":"1",
//        "usl_priem_doc_na_lizing":"1",
//        "usl_priem_inkasso":"0",
//        "usl_priem_obl_mf":"1",
//        "usl_priem_platejei_byn_ip":"1",
//        "usl_priem_platejei_eur_ip":"1",
//        "usl_priem_vznosov_inostr_val_ot_strax_agentov":"1",
//        "usl_priem_zayvleniy_obsluzhivanie_derzhatelej":"1",
//        "usl_prodaga_monet":"1",
//        "usl_razmen_foreign_val":"1",
//        "usl_razm_prodazha_documentar_obligacii":"1",
//        "usl_rb_card":"1",
//        "usl_registration_val_dogovor":"1",
//        "usl_return_BynIspKarts":"1",
//        "usl_return_UsdIspKarts":"1",
//        "usl_rko":"0",
//        "usl_seif":"0",
//        "usl_soprov_kredit_v_tom_chisle_magnit":"1",
//        "usl_strahovanie_avto":"1",
//        "usl_strahovanie_avto_pogran":"0",
//        "usl_strahovanie_detei":"1",
//        "usl_strahovanie_dohod_pod_zaschitoy":"1",
//        "usl_strahovanie_express":"1",
//        "usl_strahovanie_finans_pod_zaschitoy":"0",
//        "usl_strahovanie_green_karta":"1",
//        "usl_strahovanie_home":"1",
//        "usl_strahovanie_kartochki":"1",
//        "usl_strahovanie_kasko":"1",
//        "usl_strahovanie_komplex":"1",
//        "usl_strahovanie_medicine_nerezident":"0",
//        "usl_strahovanie_perevozki":"1",
//        "usl_strahovanie_s_zabotoi_o_blizkih":"1",
//        "usl_strahovanie_timeAbroad":"1",
//        "usl_strahovanie_zashhita_ot_kleshha":"1",
//        "usl_strahovka_site":"1",
//        "usl_stroysber":"1",
//        "usl_stroysber_new":"1",
//        "usl_subsidiya_scheta":"1",
//        "usl_swift":"1",
//        "usl_vidach_spravok_po_kredit_overdr":"1",
//        "usl_viplata_vozm_po_incasso":"0",
//        "usl_vklad":"1",
//        "usl_vozvrat_nds":"0",
//        "usl_vydacha_nal_v_banke":"1",
//        "usl_vydacha_vypiski":"1",
//        "usl_vypllata_bel_rub":"1",
//        "usl_vzk":"1",
//        "usl_plategi_all":"0",
//        "usl_plategi_in_foreign_val":"1",
//        "usl_plategi_za_proezd_v_polzu_banka":"0",
//        "usl_plategi_minus_mobi":"0",
//        "usl_plategi_minus_internet":"0",
//        "usl_plategi_minus_mobi_internet_full":"1",
//        "usl_plategi_nal_minus_krome_kredit":"0",
//        "filial_num":"795",
//        "cbu_num":"113",
//        "otd_num":"999"
//

    }

//sapId: String, filialName: String, cityType: String, city: String, addressType: String,
//     address: String, house: String, nameTypePrev: String, namePrev: String, streetTypePrev: String,
//     streetPrev: String, homeNumberPrev: String, infoText: String, infoWorktime: String, infoBankBik: String,
//     infoBankUnp: String, 

    init(filialId: String, filialName: String, city: String, gpsX: String, gpsY: String) {
        self.filialId = filialId
//        self.sapId = sapId
        self.filialName = filialName
//        self.cityType = cityType
        self.city = city
//        self.addressType = addressType
//        self.address = address
//        self.house = house
//        self.nameTypePrev = nameTypePrev
//        self.namePrev = namePrev
//        self.streetTypePrev = streetTypePrev
//        self.streetPrev = streetPrev
//        self.homeNumberPrev = homeNumberPrev
//        self.infoText = infoText
//        self.infoWorktime = infoWorktime
//        self.infoBankBik = infoBankBik
//        self.infoBankUnp = infoBankUnp
        self.gpsX = gpsX
        self.gpsY = gpsY
    }

}

typealias BankList = [Bank]
