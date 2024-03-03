//
//  CreateRevenue.swift
//
//
//  Created by Tran Viet Anh on 03/03/2024.
//
import Fluent
import Vapor
extension Revenue{
    struct CreateRevenue: AsyncMigration {
            func prepare(on database: Database) async throws {
                try await database.schema("revenue")
                    .id()
                    .field("name", .string, .required)
                    .field("year", .int, .required)
                    .field("month", .int, .required)
                    .field("day", .int, .required)
                    .field("revenue", .double, .required)
                    .unique(on: "year","month","day")
                    .create()
            }

            func revert(on database: Database) async throws {
                try await database.schema("revenue").delete()
            }
    }
}
