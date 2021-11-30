//
//  ViewController.swift
//  Calendar
//
//  Created by Mirdin Sadykov on 9/17/21.
//

import UIKit
import CalendarKit
import EventKit

class CalendarViewController: DayViewController {
    private let eventStore = EKEventStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Calendar"
        requestAccessToCalendar()
        }
    func requestAccessToCalendar()  {
        eventStore.requestAccess(to: .event){
            success, error in
        }
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map {ekEvent -> Event in
            let ckEvent = Event()
            ckEvent.startDate = ekEvent.startDate
            ckEvent.endDate = ekEvent.endDate
            ckEvent.isAllDay = ekEvent.isAllDay
            ckEvent.text = ekEvent.title
            if let evenColor = ekEvent.calendar.cgColor{
                ckEvent.color = UIColor(cgColor: evenColor)
            }
            return ckEvent
        }
        return calendarKitEvents
    }

}

