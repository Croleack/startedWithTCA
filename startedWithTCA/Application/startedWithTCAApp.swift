//
//  startedWithTCAApp.swift
//  startedWithTCA
//
//  Created by Enzhe Gaysina on 24.01.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct startedWithTCAApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
	   CounterFeature()
		  ._printChanges()
    }
    
    var body: some Scene {
	   WindowGroup {
		  CounterView(
			 store: startedWithTCAApp.store
		  )
	   }
    }
}
