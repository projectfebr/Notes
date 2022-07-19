//
//  PlayerViewController.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 17.07.2022.
//

import UIKit

class PlayerViewController: UIViewController {
    enum TimerEvents {
        case start
        case pause
        case stop
    }

    private let timerService = TimerService()

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerService.delegate = self
        setTimeLabel(timeRemainingInSeconds: timerService.time)
    }

    @IBAction func playButtonTap(_ sender: Any) {
        timerService.startTimer()
        setupTimerButtons(event: .start)
    }

    @IBAction func pauseButtonTap(_ sender: Any) {
        timerService.pauseTimer()
        setupTimerButtons(event: .pause)
    }

    @IBAction func stopButtonTap(_ sender: Any) {
        timerService.stopTimer()
    }

    private func setTimeLabel(timeRemainingInSeconds: Int) {
        let minutesLeft = Int(timeRemainingInSeconds) / 60 % 60
        let secondsLeft = Int(timeRemainingInSeconds) % 60
        timeLabel.text = String(format: "%02d", minutesLeft) + ":" + String(format: "%02d", secondsLeft)
    }

    private func setupTimerButtons(event: TimerEvents) {
        switch event {
        case .start:
            playButton.isEnabled = false
            pauseButton.isEnabled = true
            stopButton.isEnabled = true
        case .pause:
            playButton.isEnabled = true
            pauseButton.isEnabled = false
        case .stop:
            playButton.isEnabled = true
            pauseButton.isEnabled = false
            stopButton.isEnabled = false
        }
    }
}

// MARK: Implements TimerServiceDelegate
extension PlayerViewController: TimerServiceDelegate {
    func onStopTimer(time: Int) {
        setTimeLabel(timeRemainingInSeconds: time)
        setupTimerButtons(event: .stop)
    }

    func tick(timeRemainingSeconds: Int) {
        setTimeLabel(timeRemainingInSeconds: timeRemainingSeconds)
    }
}
