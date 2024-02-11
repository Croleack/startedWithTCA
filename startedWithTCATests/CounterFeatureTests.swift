//
//  CounterFeatureTests.swift
//  startedWithTCATests
//
//  Created by Enzhe Gaysina on 05.02.2024.
//

@testable import startedWithTCA
import ComposableArchitecture
import XCTest


@MainActor
final class CounterFeatureTests: XCTestCase {
    func testCounter() async {
	   let store = TestStore(initialState: CounterFeature.State()) {
		  CounterFeature()
	   }
	   
	   await store.send(.incrementButtonTapped) {
		  $0.count = 1
	   }
	   await store.send(.decrementButtonTapped) {
		  $0.count = 0
	   }
    }
}
