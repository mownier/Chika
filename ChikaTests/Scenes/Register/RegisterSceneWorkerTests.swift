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
        XCTAssertTrue(worker.service.auth is AuthRemoteServiceProvider)
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
        let auth = AuthRemoteServiceMock()
        let person = PersonRemoteServiceProvider()
        let service = RegisterScene.Worker.Service(auth: auth, person: person)
        let output = RegisterSceneWorkerOutputMock(exp: exp)
        let worker = RegisterScene.Worker(service: service)
        auth.isOK = false
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
        let auth = AuthRemoteServiceMock()
        let person = PersonRemoteServiceMock()
        let service = RegisterScene.Worker.Service(auth: auth, person: person)
        let output = RegisterSceneWorkerOutputMock(exp: exp)
        let worker = RegisterScene.Worker(service: service)
        auth.isOK = true
        person.isOK = true
        output.ok = { }
        output.err =  { _ in XCTFail() }
        worker.output = output
        worker.register(email: "me@me.com", pass: "12345")
        wait(for: [exp], timeout: 2.0)
    }
    
    // CONTEXT: Register function should return error from the
    // person remote service given that it produces an error
    func testRegisterD() {
        let exp = expectation(description: "testRegisterC")
        let auth = AuthRemoteServiceMock()
        let person = PersonRemoteServiceMock()
        let service = RegisterScene.Worker.Service(auth: auth, person: person)
        let output = RegisterSceneWorkerOutputMock(exp: exp)
        let worker = RegisterScene.Worker(service: service)
        auth.isOK = true
        person.isOK = false
        output.ok = { XCTFail() }
        output.err =  { error in
            XCTAssertTrue(error is ServiceError)
            let msg = (error as! ServiceError).message
            XCTAssertEqual(msg, "Person Remote Service Error")
        }
        worker.output = output
        worker.register(email: "me@me.com", pass: "12345")
        wait(for: [exp], timeout: 2.0)
    }
}
