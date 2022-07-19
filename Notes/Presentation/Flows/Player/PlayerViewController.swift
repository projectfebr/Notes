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
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var pauseButton: UIButton! {
        didSet {
            pauseButton.setTitle("", for: .normal)
            pauseButton.isEnabled = false
        }
    }
    @IBOutlet weak var stopButton: UIButton! {
        didSet {
            stopButton.setTitle("", for: .normal)
            stopButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerService.delegate = self
        setTimeLabel(time: timerService.time)
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

    private func setTimeLabel(time: Int) {
        let minutesLeft = Int(time) / 60 % 60
        let secondsLeft = Int(time) % 60
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
        setTimeLabel(time: time)
        setupTimerButtons(event: .stop)
    }

    func tick(timeRemainig: Int) {
        setTimeLabel(time: timeRemainig)
    }
}
