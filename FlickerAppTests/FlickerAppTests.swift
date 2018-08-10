//
//  FlickerAppTests.swift
//  FlickerAppTests
//
//  Created by Ashwath R on 07/08/18.
//  Copyright © 2018 Ashwath R. All rights reserved.
//

import XCTest
@testable import FlickerApp

class FlickerAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testPaginationResults() {
        guard let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=kitten&id=29540344978") else { return }
        let promise = expectation(description: "Simple Request")
        URLSession.shared.dataTask(with: url) {
            data, reponse, err in
            guard let data = data else { return }
            do {
                if let respDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any] {
                    if let photoModel = respDict["photos"] as? [String:Any] {
                        if let photosArr = photoModel["photo"] as? [[String:Any]] {
                            let first = photosArr.first!
                            XCTAssertTrue(((first["title"] as? String) != nil), "Title present")
                            XCTAssertTrue(((first["id"] as? String) != nil), "Id present")
                            XCTAssertTrue(((first["farm"] as? Int) != nil), "Farm Id present")
                            XCTAssertTrue(((first["secret"] as? String) != nil), "Secret present")
                            XCTAssertTrue(((first["server"] as? String) != nil), "Server present")
                            promise.fulfill()
                        }
                    }
                }
            }
            catch let err {
                print(err.localizedDescription)
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchResults() {
        guard let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=kitten") else { return }
         let promise = expectation(description: "Simple Request")
        URLSession.shared.dataTask(with: url) {
            data, reponse, err in
            guard let data = data else { return }
            do {
                if let respDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any] {
                    if let photoModel = respDict["photos"] as? [String:Any] {
                        if let photosArr = photoModel["photo"] as? [[String:Any]] {
                            let first = photosArr.first!
                            XCTAssertTrue(((first["title"] as? String) != nil), "Title present")
                            XCTAssertTrue(((first["id"] as? String) != nil), "Id present")
                            XCTAssertTrue(((first["farm"] as? Int) != nil), "Farm Id present")
                            XCTAssertTrue(((first["secret"] as? String) != nil), "Secret present")
                            XCTAssertTrue(((first["server"] as? String) != nil), "Server present")
                            promise.fulfill()
                        }
                    }
                }
            }
            catch let err {
                print(err.localizedDescription)
            }
        }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
}
