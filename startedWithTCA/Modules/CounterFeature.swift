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
	   var fact: String?
	   var isLoading = false
	   var isTimerRunning = false
    }
    
    enum Action {
	   case decrementButtonTapped
	   case incrementButtonTapped
	   case resetButtonTapped
	   case factButtonTapped
	   case factResponse(fact: String)
	   case toggleTimer
	   case timerTick
	   case toggleTimerButtonTapped
    }
    
    enum CancelID { case timer }
    
    var body: some ReducerOf<Self> {
	   Reduce { state, action in
		  switch action {
		  case .decrementButtonTapped:
			 state.count -= 1
			 state.fact = nil
			 return .none
		  case .incrementButtonTapped:
			 state.count += 1
			 state.fact = nil
			 return .none
		  case .resetButtonTapped:
			 state.count = 0
			 state.fact = nil
			 return .none
		  case .factButtonTapped:
			 state.fact = nil
			 state.isLoading = true
			 return .run { [count = state.count] send in
				async {
				    do {
					   let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(count)")!)
					   let fact = String(decoding: data, as: UTF8.self)
					   
					   await send(.factResponse(fact: fact))
				    } catch {
					   // Handle error
					   print("Error fetching fact: \(error)")
				    }
				}
			 }
		  case .timerTick:
			 state.count += 1
			 state.fact = nil
			 return .none
			 
			 return .run { [count = state.count] send in
				let (data, _) = try await URLSession.shared
				    .data(from: URL(string: "http://numbersapi.com/\(count)")!)
				let fact = String(decoding: data, as: UTF8.self)
				
				await send(.factResponse(fact: fact))
			 }
		  case let .factResponse(fact):
			 state.isLoading = false
			 state.fact = fact
			 return .none
		  case .toggleTimer:
			 state.isTimerRunning.toggle()
			 return .run { send in
				while true {
				    try await Task.sleep(for: .seconds(1))
				    await send(.timerTick)
				}
			 }
		  case .timerTick:
			 state.count += 1
			 state.fact = nil
			 return .none
			 
		  case .toggleTimerButtonTapped:
			 state.isTimerRunning.toggle()
			 if state.isTimerRunning {
				return .run { send in
				    while true {
					   try await Task.sleep(for: .seconds(1))
					   await send(.timerTick)
				    }
				}
				.cancellable(id: CancelID.timer)
			 } else {
				return .cancel(id: CancelID.timer)
			 }
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
			 
			 Button(viewStore.isTimerRunning ? "Stop timer" : "Start timer") {
				viewStore.send(.toggleTimerButtonTapped)
			 }
			 .font(.largeTitle)
			 .padding()
			 .background(Color.black.opacity(0.1))
			 .cornerRadius(10)
			 
			 Button("Fact") {
				viewStore.send(.factButtonTapped)
			 }
			 .font(.largeTitle)
			 .padding()
			 .background(Color.black.opacity(0.1))
			 .cornerRadius(10)
			 
			 if viewStore.isLoading {
				ProgressView()
			 } else if let fact = viewStore.fact {
				Text(fact)
				    .font(.largeTitle)
				    .multilineTextAlignment(.center)
				    .padding()
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

//
