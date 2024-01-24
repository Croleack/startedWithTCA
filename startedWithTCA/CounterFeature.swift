//
//  CounterFeature.swift
//  startedWithTCA
//
//  Created by Enzhe Gaysina on 24.01.2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature: Equatable {
    
    struct State:Equatable {
	   var count = 0
    }
    
    enum Action {
	   case decrementButtonTapped
	   case incrementButtonTapped
	   case resetButtonTapped
    }
    
    var body: some ReducerOf<Self> {
	   Reduce { state, action in
		  switch action {
		  case .decrementButtonTapped:
			 state.count -= 1
			 return .none
		  case .incrementButtonTapped:
			 state.count += 1
			 return .none
		  case .resetButtonTapped:
			 state.count = 0
			 return .none
		  }
	   }
    }
}


struct CounterView: View {
    
    let store: StoreOf<CounterFeature>
    
    var body: some View {
	   WithViewStore(self.store, observe: { $0 }) { viewStore in
		  VStack {
			 Text("\(viewStore.count)")
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
			 HStack {
				Button("-") {
				    viewStore.send(.decrementButtonTapped)
				}
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
				
				Button("Reset") {
				    viewStore.send(.resetButtonTapped)
				}
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
				
				Button("+") {
				    viewStore.send(.incrementButtonTapped)
				}
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
			 }
		  }
	   }
	   
    }
}

struct CounterPreview: PreviewProvider {
    static var previews: some View {
	   CounterView(
		  store: Store(initialState: CounterFeature.State()) {
			// CounterFeature()
		  }
	   )
    }
}
