//
//  ContentView.swift
//  01_SwiftUI_CoreData
//
//  Created by webwerks  on 15/11/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    
    private var employees: FetchedResults<Employee>
    
    @State var model = EmployeeModel(name: "", empId: 0, role: "", joiningDate: Date())
    @State var isPresentingAdd = false
    @State var selectedEmployee:Employee?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Employee List")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .background(.orange)
                    .background(in: Capsule())
                    .padding(10)
                
                List {
                    ForEach(employees) { employee in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Name: ")
                                    .fontWeight(.bold)
                                Text("\(employee.name ?? "")")
                                Spacer()
                                Text("Id: ")
                                    .fontWeight(.bold)
                                Text("\(employee.empId)")
                            }
                            HStack {
                                Text("Role: ")
                                    .fontWeight(.bold)
                                Text("\(employee.role ?? "")")
                            }
                            HStack {
                                Text("Joining Date: ")
                                    .fontWeight(.bold)
                                Text("\(employee.joiningDate ?? Date(), formatter: itemFormatter)")
                            }
                        }
                        .onTapGesture {
                            selectedEmployee = employee
                        }
                        .padding()
                        .listRowBackground(Color.blue.opacity(0.5))
                    }
                    .onDelete(perform: deleteItems)
                }
                .scrollContentBackground(.hidden)
                
                Button("Add", action: {
                    isPresentingAdd.toggle()
                })
                .frame(width: 100, height: 35)
                .font(.title3)
                .fontWeight(.bold)
                .background(.black)
                .background(in: Capsule())
                .foregroundColor(Color.mint)
                .padding(10)
                .sheet(isPresented: $isPresentingAdd) {
                        AddView(model: EmployeeModel(name: "", empId: 0, role: "", joiningDate: Date()), isPresenting: $isPresentingAdd)
                }
                .sheet(item: $selectedEmployee) { selectedEmp in
                    EditView(model: EmployeeModel(name: selectedEmp.name ?? "", empId: Int(selectedEmp.empId), role: selectedEmp.role ?? "", joiningDate: selectedEmp.joiningDate ?? Date()))
                }
            }
            .background(.pink)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { employees[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
