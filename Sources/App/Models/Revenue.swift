//
//  Revenue.swift
//
//
//  Created by Tran Viet Anh on 03/03/2024.
//

import Fluent
import Vapor

final class Revenue: Model, Content {
    static let schema = "revenue"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "year")
    var year: Int

    @Field(key: "month")
    var month: Int
    
    @Field(key: "day")
    var day: Int
    
    @Field(key: "revenue")
    var revenue: Double

    init(id: UUID? = nil, name: String, year: Int, month: Int, day: Int, revenue: Double) {
        self.id = id
        self.name = name
        self.year = year
        self.month = month
        self.day = day
        self.revenue = revenue
    }
    init() {
        
    }

}
