//
//  AboutMeView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 26/07/2024.
//

import SwiftUI

struct AboutMeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("About Me")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                Text("Welcome to the CateringManager App!")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("""
                This application is a final project for the course at Syntax Institut. As a proud member of Batch 13, I have developed this app to help catering managers efficiently plan and manage their events.
                The app includes features such as menu planning, event scheduling, ingredient management, and more. The goal is to simplify the daily tasks of catering managers, allowing them to focus more on creating delightful experiences for their clients.
                """)
                Text("About the Developer")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("""
                My name is Pablo Cigoy, and I am passionate about creating practical and user-friendly applications. This project has been a significant learning experience, helping me enhance my skills in Swift, SwiftUI, REST API and Firebase.
                I am grateful for the support and guidance from the instructors and peers at Syntax Institut. Their insights and feedback have been invaluable in shaping this project.
                """)
                Text("Features of CateringManager App")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("""
                - **Menu Planning**: Create and manage menus for different events.
                - **Event Scheduling**: Schedule and keep track of events with a user-friendly calendar.
                - **Ingredient Management**: Keep an inventory of ingredients and their costs.
                - **Weather Forecasting**: Get weather forecasts for event locations to ensure perfect planning.
                - **ToDo list**: To not forget items for the event.
                """)
                Text("Thank You!")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("""
                Thank you for using the CateringManager App. I hope this tool helps you streamline your catering management tasks. If you have any feedback or suggestions, feel free to reach out!
                """)
                Text("Contact Information")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("""
                - Email: pablocigoy@gmail.com
                """)
            }
            .padding()
        }
        .navigationTitle("About Me")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeView()
    }
}
