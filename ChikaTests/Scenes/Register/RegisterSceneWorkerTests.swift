//
//  RegisterSceneWorkerTests.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import XCTest
@testable import Chika

class RegisterSceneWorkerTests: XCTestCase {
    
    // CONTEXT: Initialize with default values of service and output
    func testInitA() {
        let worker = RegisterScene.Worker()
        XCTAssertNil(worker.output)
        XCTAssertTrue(worker.service is AuthRemoteServiceProvider)
    }
    
    // CONTEXT: Register function has nil email and pass and it should
    // return with app error that email and pass must not be empty
    func testRegisterA() {
        let exp = expectation(description: "testRegisterA")
        let output = RegisterSceneWorkerOutputMock(exp: exp)
        let worker = RegisterScene.Worker()
        output.ok = { XCTFail() }
        output.err = { error in
            XCTAssertTrue(error is AppError)
            let msg = (error as! AppError).message
            XCTAssertEqual(msg, "email and pass must not be empty")
        }
        worker.output = output
        worker.register(email: nil, pass: nil)
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function should return error coming
    // from the service
    func testRegisterB() {
        let exp = expectation(description: "testRegisterB")
        let service = AuthRemoteServiceMock()
        let output = RegisterSceneWorkerOutputMock(exp: exp)
        let worker = RegisterScene.Worker(service: service)
        service.isOK = false
        output.ok = { XCTFail() }
        output.err =  { error in
            XCTAssertTrue(error is ServiceError)
            let msg = (error as! ServiceError).message
            XCTAssertEqual(msg, "Auth remote service forced error")
        }
        worker.output = output
        worker.register(email: "me@me.com", pass: "12345")
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function should return ok from the service
    func testRegisterC() {
        let exp = expectation(description: "testRegisterC")
        let mockService = AuthRemoteServiceMock()
        let output = RegisterSceneWorkerOutputMock(exp: exp)
        let worker = RegisterScene.Worker(service: mockService)
        output.ok = { }
        output.err =  { _ in XCTFail() }
        worker.output = output
        worker.register(email: "me@me.com", pass: "12345")
        wait(for: [exp], timeout: 2.0)
    }
}
