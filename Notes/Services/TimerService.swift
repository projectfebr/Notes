//
//  TimerService.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 17.07.2022.
//

import Foundation

protocol TimerServiceDelegate {
    func tick(timeRemainingSeconds: Int)
    func onStopTimer(time: Int)
}

class TimerService {
    var delegate: TimerServiceDelegate?

    private var timerIsOn = false
    private(set) var time: Int
    private var timeRemaining: Int
    private var timer = Timer()

    init(time: Int = 60) {
        self.time = time
        self.timeRemaining = time
    }

    func startTimer() {
        if !timerIsOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
            timerIsOn = true
        }
    }

    func pauseTimer() {
        timer.invalidate()
        timerIsOn = false
    }

    func stopTimer() {
        timer.invalidate()
        timeRemaining = time
        timerIsOn = false
        delegate?.onStopTimer(time: time)
    }

    @objc func timerRunning() {
        timeRemaining -= 1
        if timeRemaining == -1 {
            stopTimer()
        } else {
            delegate?.tick(timeRemainingSeconds: timeRemaining)
        }
    }
}
