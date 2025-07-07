//
//  WaveView.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 6.07.2025.
//

import UIKit

class WaveView: UIView {

    private let waveLayers: [CAShapeLayer] = [CAShapeLayer(), CAShapeLayer(), CAShapeLayer()]
    private var displayLink: CADisplayLink?

    private var phases: [CGFloat] = [0, 0, 0]
    private var speeds: [CGFloat] = [0.01, 0.008, 0.006]
    private let baseSpeeds: [CGFloat] = [0.01, 0.008, 0.006]
    private let boostedSpeeds: [CGFloat] = [0.04, 0.03, 0.02]
    
    private let baseWaveHeight: CGFloat = 30
    private var speedAnimationTimer: Timer?
    private var isAnimatingSpeed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWaves()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWaves()
    }

    private func setupWaves() {
        
        let colors: [UIColor] = [
            UIColor(red: 0.20, green: 0.60, blue: 1.00, alpha: 0.8),
            UIColor(red: 0.15, green: 0.55, blue: 0.95, alpha: 0.5),
            UIColor(red: 0.10, green: 0.45, blue: 0.90, alpha: 0.35)
        ]

        for (i, layer) in waveLayers.enumerated() {
            layer.fillColor = colors[i].cgColor
            self.layer.addSublayer(layer)
        }

        displayLink = CADisplayLink(target: self, selector: #selector(updateWaves))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateWaves() {
        let width = bounds.width

        for i in 0..<waveLayers.count {
            phases[i] += speeds[i]
            let waveHeight = baseWaveHeight * [1.0, 0.7, 0.5][i]
            let wavelength = width / [1.2, 1.5, 1.8][i]
            waveLayers[i].path = generateWavePath(phase: phases[i], waveHeight: waveHeight, wavelength: wavelength).cgPath
        }
    }

    private func generateWavePath(phase: CGFloat, waveHeight: CGFloat, wavelength: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height
        let baseY = waveHeight + 5

        path.move(to: CGPoint(x: 0, y: baseY))
        for x in stride(from: 0, through: width, by: 1) {
            let y = waveHeight * sin((x / wavelength + phase) * .pi * 2) + baseY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        return path
    }

    func boostWaveSpeedTemporarily() {
        speedAnimationTimer?.invalidate()
        isAnimatingSpeed = false

        self.speeds = boostedSpeeds

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateSpeeds(from: self.boostedSpeeds, to: self.baseSpeeds, duration: 1.5)
        }
    }

    private func animateSpeeds(from: [CGFloat], to: [CGFloat], duration: CGFloat, completion: (() -> Void)? = nil) {
        speedAnimationTimer?.invalidate()
        isAnimatingSpeed = true

        var step: CGFloat = 0
        let maxStep: CGFloat = duration / 0.025
        let timerInterval = 0.025

        speedAnimationTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            let t = min(step / maxStep, 1)
            let ease = (1 - cos(t * .pi)) / 2

            for i in 0..<self.speeds.count {
                self.speeds[i] = from[i] + (to[i] - from[i]) * ease
            }

            step += 1
            if t >= 1 {
                timer.invalidate()
                self.isAnimatingSpeed = false
                completion?()
            }
        }
    }

    deinit {
        displayLink?.invalidate()
    }
}
