//
//  EditView.swift
//  01_SwiftUI_CoreData
//
//  Created by Neosoft on 16/11/23.
//

import Foundation
import SwiftUI
import CoreData


struct EditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State var model: EmployeeModel
    
    let roles = ["Software Engineer", "Product Manager", "Designer"]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Edit Employee")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding(30)
            
            HStack {
                Text("Name: ")
                    .fontWeight(.bold)
                TextField("Chintan Rajgor", text: $model.name)
            }
            HStack {
                Text("Id: ")
                    .fontWeight(.bold)
                Text("\(model.empId)")
//                TextField("Id", value: $model.empId, formatter: NumberFormatter())
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
            
            Button("Update") {
                updateItem(name: model.name, empId: model.empId, role: model.role, date: model.joiningDate)
            }
            .frame(width: 100, height: 35)
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(5)
            
            Spacer()
        }
        .padding(20)
    }
    
    private func fetchEmployee(for empId: Int) -> Employee? {
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        // Set a predicate to filter by empId
        fetchRequest.predicate = NSPredicate(format: "empId == %@", NSNumber(value: empId))
        
        do {
            let employees = try viewContext.fetch(fetchRequest)
            return employees.first
        } catch {
            let nsError = error as NSError
            print("Error fetching employee: \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
    
    private func updateItem(name: String, empId: Int, role: String, date: Date) {
        withAnimation {
            guard let existingEmployee = fetchEmployee(for: empId) else {
                print("Error: Unable to get existing employee.")
                return
            }

            existingEmployee.name = name
            existingEmployee.empId = Int16(empId)
            existingEmployee.role = role
            existingEmployee.joiningDate = date

            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
                // Handle the error appropriately for your application
            }
        }
    }

}
