import Fluent
import Vapor

struct RevenueController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("revenue")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":id") { todo in
            todo.delete(use: delete)
        }
//        todos.get("year", use: getByAllYear)
        todos.get("year", ":year", use: getByYear)
       todos.get("month", ":month", "year", ":year", use: getByMonthAndYear)
       todos.get("date", ":day", ":month", ":year", use: getByDate)
    }

    func index(req: Request) async throws -> [Revenue] {
        try await Revenue.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Revenue {
        let todo = try req.content.decode(Revenue.self)
        try await todo.save(on: req.db)
        return todo
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Revenue.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
    func getByYear(req: Request) async throws -> Double {
        let year = try req.parameters.require("year", as: Int.self)
        
        // Tính tổng doanh thu trực tiếp trong cơ sở dữ liệu
        let totalRevenue = try await Revenue.query(on: req.db)
            .filter(\.$year == year)
            .sum(\.$revenue)
        
        return totalRevenue ?? 0
    }


    func getByMonthAndYear(req: Request) async throws -> Double {
        let year = try req.parameters.require("year", as: Int.self)
        let month = try req.parameters.require("month", as: Int.self)
        

        
        let totalRevenue = try await Revenue.query(on: req.db)
            .filter(\.$year == year)
            .filter(\.$month == month)
            .sum(\.$revenue)
        
        return totalRevenue ?? 0
    }



    func getByDate(req: Request) async throws -> Double {
        let year = try req.parameters.require("year", as: Int.self)
        let month = try req.parameters.require("month", as: Int.self)
        let day = try req.parameters.require("day", as: Int.self)
        
        guard let revenue = try await Revenue.query(on: req.db)
            .filter(\.$year == year)
            .filter(\.$month == month)
            .filter(\.$day == day)
            .first()
        else {
            throw Abort(.notFound)
        }
        
        return revenue.revenue
    }}
struct YearRevenue: Content {
    var year: Int
    var revenue: Double
}
