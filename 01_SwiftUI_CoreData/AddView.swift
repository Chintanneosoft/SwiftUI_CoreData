//
//  AddView.swift
//  01_SwiftUI_CoreData
//
//  Created by webwerks  on 15/11/23.
//

import SwiftUI

struct EmployeeModel {
    var name: String
    var empId: Int
    var role: String
    var joiningDate: Date
}

struct AddView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var model: EmployeeModel
    @Binding var isPresenting: Bool
    let roles = ["Software Engineer", "Product Manager", "Designer"]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Employee Details")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding(30)
            
            HStack {
                Text("Name: ")
                    .fontWeight(.bold)
                TextField("Name", text: $model.name)
            }
            HStack {
                Text("Id: ")
                    .fontWeight(.bold)
                TextField("Id", value: $model.empId, formatter: NumberFormatter())
            }
            HStack {
                Text("Role")
                    .fontWeight(.bold)
                Picker("Role", selection: $model.role) {
                    ForEach(roles, id: \.self) { role in
                        Text(role)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            HStack {
                Text("Joining Date: ")
                    .fontWeight(.bold)
                DatePicker("", selection: $model.joiningDate, displayedComponents: .date)
            }
            .padding(.bottom, 30)
            
            Button("Submit") {
                isPresenting.toggle()
                addItem(name: model.name, empId: model.empId, role: model.role, date: model.joiningDate)
            }
            .frame(width: 100, height: 35)
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(5)
            
            Spacer()
        }
        .padding(20)
    }
    
    private func addItem(name: String, empId: Int, role: String, date: Date) {
        withAnimation {
            let newItem = Employee(context: viewContext)
            newItem.name = name
            newItem.empId = Int16(empId)
            newItem.role = role
            newItem.joiningDate = date
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
