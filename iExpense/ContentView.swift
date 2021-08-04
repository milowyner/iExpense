//
//  ContentView.swift
//  iExpense
//
//  Created by Milo Wyner on 8/2/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let name: String
    let type: String
    let amount: Int
    
    var id = UUID()
}

class Expenses: ObservableObject {
    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
                print("encoded")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "Items"),
           let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: data) {
            items = decoded
            print("decoded")
        } else {
            items = []
        }
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text("$\(item.amount)")
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .navigationBarItems(trailing: Button(action: {
                showingAddExpense = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showingAddExpense, content: {
                AddView(expenses: expenses)
            })
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(expenses: {
            let expenses = Expenses()
            expenses.items = [ExpenseItem](repeating: ExpenseItem(name: "Lunch", type: "Business", amount: 20), count: 3)
            return expenses
        }())
    }
}
