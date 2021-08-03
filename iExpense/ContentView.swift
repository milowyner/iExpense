//
//  ContentView.swift
//  iExpense
//
//  Created by Milo Wyner on 8/2/21.
//

import SwiftUI

struct ExpenseItem: Identifiable {
    let name: String
    let type: String
    let amount: Int
    
    let id = UUID()
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]()
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .navigationBarItems(trailing: Button(action: {
                let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                expenses.items.append(expense)
            }, label: {
                Image(systemName: "plus")
            }))
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
