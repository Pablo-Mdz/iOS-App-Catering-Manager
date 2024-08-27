//
//  CalendarView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import SwiftUI
import UserNotifications

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @StateObject private var weatherViewModel = WeatherViewModel()
    @State private var selectedDate = Date()
    @State private var selectedEvent: Event?
    private let calendar = Calendar.current
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let today = Date()

    var body: some View {
        NavigationStack {
            ScrollView {
                weatherSection
                calendarSection
                eventDetailSection
            }
            .background(CostumColors.primaryColor.opacity(0.1))
            .navigationTitle("Calendar of Events")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchEvents()
                weatherViewModel.fetchWeather(for: 52.52, longitude: 13.4050)
            }
        }
    }

    // MARK: - Sections

    private var weatherSection: some View {
        VStack {
            if let weather = weatherViewModel.weather?.daily {
                WeatherView(weather: weather, date: selectedDate)
            } else {
                ProgressView()
                    .frame(height: 100)
            }
        }
    }

    private var calendarSection: some View {
        VStack {
            monthNavigation
            daysOfWeekHeader
            calendarGrid
        }
    }

    private var monthNavigation: some View {
        HStack {
            Button(action: viewModel.previousMonth) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(viewModel.monthAndYearString)
                .font(.headline)
            Spacer()
            Button(action: viewModel.nextMonth) {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }

    private var daysOfWeekHeader: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.subheadline)
                    .bold()
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(0..<viewModel.firstDayOffset, id: \.self) { _ in
                Text("")
                    .frame(maxWidth: .infinity)
                    .padding(10)
            }

            ForEach(viewModel.daysInMonth, id: \.self) { date in
                calendarDayView(for: date)
            }
        }
        .padding(.horizontal)
    }

    private func calendarDayView(for date: Date) -> some View {
        Text(dateFormatter.string(from: date))
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(backgroundColor(for: date).opacity(0.3))
            .overlay(
                Circle()
                    .strokeBorder(selectedColor(for: date), lineWidth: 2)
                    .background(Circle().fill(backgroundColor(for: date).opacity(0.3)))
            )
            .clipShape(Circle())
            .foregroundColor(textColor(for: date))
            .onTapGesture {
                selectedDate = date
                selectedEvent = viewModel.events(for: selectedDate).first
            }
    }

    private var eventDetailSection: some View {
        VStack {
            if let event = selectedEvent {
                EventDetailView(event: event)
            } else {
                Text("No event this day")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
        }
    }

    // MARK: - Helpers

    private func backgroundColor(for date: Date) -> Color {
        if calendar.isDate(date, inSameDayAs: today) {
            return Color.gray.opacity(0.3) // Make the gray lighter
        } else if viewModel.hasEvent(on: date) {
            return Color.green.opacity(0.6) // Adjust the opacity for the green background
        } else {
            return Color.clear
        }
    }

    private func selectedColor(for date: Date) -> Color {
        if calendar.isDate(date, inSameDayAs: selectedDate) {
            return Color.blue
        } else {
            return Color.clear
        }
    }

    private func textColor(for date: Date) -> Color {
        if calendar.isDate(date, inSameDayAs: today) || viewModel.hasEvent(on: date) {
            return Color.primary
        } else {
            return Color.primary
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
