//
//  ViewModel.swift
//  Breweries Test App
//
//  Created by Dmytro Nechuyev on 09.06.2021.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var breveriesRes = [Brewery]()
    @Published var searchRes = [Brewery]()
    @Published var search = false
    var endOfData = false
    var breweriesJSON = [Brewery]()
    var breweriesDb = [Brewery]()
    var saveToDb = [Brewery]()
    var prevLoad = ""
    
    
    init(){
        appStart()
    }
    
    func appStart(page: Int = 1) {
        
        BreweryRequest().allBreweries(page: page) { result in
            
            switch result {
            
            case.success(let allBreweries):
                DispatchQueue.main.async {
                    
                    if allBreweries == [] {
                        self.endOfData = true
                        return
                    }
                    for json in allBreweries {
                        var x = 0
                        for db in self.getAllBreweriesDb() {
                            if json.id == db.id {
                                x = 1
                            }
                        }
                        if x == 0 {
                            self.saveToDb.append(json)
                        }
                    }
                    self.saveBrewery()
                    if self.prevLoad == "DB" {
                        self.breveriesRes = [Brewery]()
                    }
                    self.breveriesRes.append(contentsOf: allBreweries)
                    self.prevLoad = "JSON"
                }
                
            case.failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                    
                    self.getTwentyBreweriesDb(fetchOffset: page)
                    
                    if self.breweriesDb == [] {
                        self.endOfData = true
                        return
                    }
                    if self.prevLoad == "JSON" {
                        self.breveriesRes = [Brewery]()
                    }
                    self.breveriesRes.append(contentsOf: self.breweriesDb)
                    self.prevLoad = "DB"
                }
            }
        }
        
    }
    
    func searchBrewery(query: String) {
        if query == "" {
            search = false
            return
        }
        breweriesDb = [Brewery]()

        BreweryRequest().search(query: query) { result in
            
            switch result {
            
            case.success(let searchBreweries):
                
                DispatchQueue.main.async {
                    
                    for json in searchBreweries {
                        var x = 0
                        for db in self.getAllBreweriesDb() {
                            if json.id == db.id {
                                x = 1
                            }
                        }
                        if x == 0 {
                            self.saveToDb.append(json)
                        }
                    }
                    self.saveBrewery()
                    self.searchRes = searchBreweries
                }
                
            case.failure(let error):

                DispatchQueue.main.async {
                    
                    print("Error: \(error.localizedDescription)")
                    
                    self.searchDb(query: query)
                    self.searchRes = self.breweriesDb

                }
            }
        }
    }
    
    
    func getTwentyBreweriesDb(fetchOffset: Int = 0) {
        let CountFetchOffset = fetchOffset * 20
        let dbResponse = CoreDataController.shared.getTwentyBreweries(fetchOffset: CountFetchOffset).map(BrewaryDb.init)
        breweriesDb = breweriesDbToBrewery(breweriesDb: dbResponse)
    }
    
    func getAllBreweriesDb() -> [Brewery] {
        let dbResponse = CoreDataController.shared.getAllBreweries().map(BrewaryDb.init)
        let result = breweriesDbToBrewery(breweriesDb: dbResponse)
        return result
    }
    
    func searchDb(query: String) {
        let dbResponse = CoreDataController.shared.search(query: query).map(BrewaryDb.init)
        breweriesDb = breweriesDbToBrewery(breweriesDb: dbResponse)
    }
    
    func breweriesDbToBrewery(breweriesDb: [BrewaryDb]) -> [Brewery] {
        
        var result = [Brewery]()
        
        for breweryDb in breweriesDb {
            let brewery = Brewery(id: Int(breweryDb.id), name: breweryDb.name, brewery_type: nil, street: breweryDb.street, address_2: nil, address_3: nil, city: breweryDb.city, state: breweryDb.state, country_province: nil, postal_code: nil, country: breweryDb.country, longitude: breweryDb.longitude, latitude: breweryDb.latitude, phone: breweryDb.phone, website_url: breweryDb.website_url, updated_at: nil, created_at: nil)
            result.append(brewery)
        }
        
        return result
    }
    
    
    func saveBrewery() {
            
        let database = BreweriesEntity(context: CoreDataController.shared.viewContext)
        
        for brewary in saveToDb {
            
            guard let id = brewary.id else {
                continue
            }
            
            database.id = Int16(id)
            database.name = brewary.name
            database.city = brewary.city
            database.country = brewary.country
            database.latitude = brewary.latitude
            database.longitude = brewary.longitude
            database.phone = brewary.phone
            database.state = brewary.state
            database.street = brewary.street
            database.website_url = brewary.website_url
            
            CoreDataController.shared.save()
        }
    }
    
    func comparison() {
        
    }
        
    
}

struct BrewaryDb {
    
    let brewariesEntity: BreweriesEntity
    
    var id: Int16 {
        return brewariesEntity.id
    }
    
    var city: String {
        return brewariesEntity.name ?? ""
    }
    
    var country: String {
        return brewariesEntity.country ?? ""
    }

    var latitude: String {
        return brewariesEntity.latitude ?? ""
    }
    
    var longitude: String {
        return brewariesEntity.longitude ?? ""
    }
    
    var name: String {
        return brewariesEntity.name ?? ""
    }
    
    var phone: String {
        return brewariesEntity.phone ?? ""
    }
    
    var state: String {
        return brewariesEntity.state ?? ""
    }
    
    var street: String {
        return brewariesEntity.street ?? ""
    }
    
    var website_url: String {
        return brewariesEntity.website_url ?? ""
    }
}
