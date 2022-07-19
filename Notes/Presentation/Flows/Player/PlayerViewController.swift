//
//  PlayerViewController.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 17.07.2022.
//

import UIKit

class PlayerViewController: UIViewController {
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
        }
    }
    @IBOutlet weak var stopButton: UIButton! {
        didSet {
            stopButton.setTitle("", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerService.delegate = self
        setTimeLabel(timeRemainig: timerService.time)
    }

    @IBAction func playButtonTap(_ sender: Any) {
        timerService.startTimer()
        playButton.isEnabled = false
    }

    @IBAction func pauseButtonTap(_ sender: Any) {
        timerService.pauseTimer()
        playButton.isEnabled = true
    }

    @IBAction func stopButtonTap(_ sender: Any) {
        timerService.stopTimer()
        playButton.isEnabled = true
    }

    private func setTimeLabel(timeRemainig: Int) {
        let minutesLeft = Int(timeRemainig) / 60 % 60
        let secondsLeft = Int(timeRemainig) % 60
        timeLabel.text = String(format: "%02d", minutesLeft) + ":" + String(format: "%02d", secondsLeft)
    }
}

// MARK: Implements TimerServiceDelegate
extension PlayerViewController: TimerServiceDelegate {
    func tick(timeRemainig: Int) {
        setTimeLabel(timeRemainig: timeRemainig)
    }
}
