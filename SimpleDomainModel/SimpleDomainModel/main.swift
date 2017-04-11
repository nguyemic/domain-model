//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

//1 USD = .5 GBP (2 USD = 1 GBP)
//
//1 USD = 1.5 EUR (2 USD = 3 EUR)
//
//1 USD = 1.25 CAN (4 USD = 5 CAN)
//


////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    let conversion: [String: Double] = ["USD": 1, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
    let toUSD = Money(amount: Int(Double(conversion[to]!) / 1 ), currency: "USD")
    let selfUSD: Money = Money(amount: Int(Double(self.amount) * conversion[to]! / 1 ), currency: "USD")
    return Money(amount: toUSD.amount / selfUSD.amount, currency: to)
  }
  	
  public func add(_ to: Money) -> Money {
    if self.currency != to.currency {
        let change = self.convert(to.currency)
        return Money(amount: (change.amount + to.amount), currency: to.currency)
    }
    return Money(amount: (self.amount + to.amount), currency: to.currency)
  }
    
    public func subtract(_ from: Money) -> Money {
        if self.currency != from.currency {
            let change = self.convert(from.currency)
            return Money(amount: (change.amount - from.amount), currency: from.currency)
        }
        return Money(amount: (self.amount - from.amount), currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let per): return Int(per * Double(hours))
    case .Salary(let income): return income
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Salary(let income): self.type = .Salary(Int(Double(income) + amt))
    case .Hourly(let rate): self.type = .Hourly(rate + amt)
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return self._job }
    set(value) {
        if self.age > 15{
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse }
    set(value) {
        if self.age >= 18 {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job?.title ?? "nil") spouse:\(self._spouse?.firstName ?? "nil")]"

  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
    self.members.append(spouse1)
    self.members.append(spouse2)
    
    if spouse1.age <= 21 && spouse2.age <= 21 { // Must have a family member that is >21 years old
        self.members.append(Person(firstName: "Legal", lastName: "Guardian", age: 22))
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    let member = child
    member.age = 0
    self.members.append(member)
    return true
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for person in members {
        if(person.job != nil) {
            income += person.job!.calculateIncome(2000)
        }
    }
    return income
  }
}





