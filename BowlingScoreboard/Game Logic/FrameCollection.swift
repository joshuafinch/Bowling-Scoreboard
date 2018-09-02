//
//  FrameCollection.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation
import os

final class FrameCollection: Equatable {

    static func == (lhs: FrameCollection, rhs: FrameCollection) -> Bool {
        return lhs.frameInfos == rhs.frameInfos
    }

    // MARK: - Properties

    var frameScores: [FrameScore] {
        var frames: [FrameScore] = []

        var current: Node<FrameScore>? = head
        repeat {
            if let node = current {
                frames.append(node.value)
            }
            current = current?.next
        } while current != nil

        return frames
    }

    var frameInfos: [FrameInfo] {
        var frames: [FrameInfo] = []
        var foundCurrentFrame = false

        var current: Node<FrameScore>? = head
        repeat {
            if let node = current {
                if !foundCurrentFrame {
                    foundCurrentFrame = !node.value.frame.allNecessaryShotsTaken()
                }
                let info = FrameInfo(isCurrent: foundCurrentFrame, frame: node.value.frame, runningTotalScore: node.value.runningTotalScore)
                frames.append(info)
            }
            current = current?.next
        } while current != nil

        return frames
    }

    var frames: [Frame] {
        var frames: [Frame] = []

        var current: Node<FrameScore>? = head
        repeat {
            if let node = current {
                frames.append(node.value.frame)
            }
            current = current?.next
        } while current != nil

        return frames
    }

    private var head: Node<FrameScore>

    // MARK: - Initialization

    /// Expects to be provided with 10 frames, the last of which should be marked final only
    /// Will return nil otherwise
    init?(frames: [Frame]) {

        guard frames.count == 10 else {
            return nil
        }

        guard frames[9].isFinal else {
            return nil
        }

        guard !frames[0..<9].contains(where: { $0.isFinal }) else {
            return nil
        }

        var frameScores = frames.map({ FrameScore(frame: $0) })

        let head = Node(frameScores.removeFirst())
        var previous: Node<FrameScore>? = head

        for frameScore in frameScores {
            previous = previous?.append(frameScore)
        }

        self.head = head
        recalculateScores()
    }

    /// Will create a frame collection with 10 frames, and the final frame being marked as final
    /// Shouldn't return nil unless there is a programmer error
    convenience init?() {
        let frames = [
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(),
            Frame(isFinal: true)
        ].compactMap({$0})

        self.init(frames: frames)
    }

    // MARK: - Public

    func runningTotalScore() -> Score {

        var current: Node<FrameScore>? = head
        var tail: Node<FrameScore> = head

        repeat {
            if let next = current?.next {
                tail = next
            }
            current = current?.next
        } while current != nil

        return tail.value.runningTotalScore
    }

    func allNecessaryShotsTaken() -> Bool {
        var current: Node<FrameScore>? = head
        repeat {
            guard let node = current else { continue }

            if !node.value.frame.allNecessaryShotsTaken() {
                return false
            }

            current = node.next
        } while current != nil

        return true
    }

    func take(shot: Shot) throws {

        let (frameIndex, frame) = currentFrame()

        os_log("Current frame (%d): (isFinal: %d, shots: %@)",
               log: Log.takeShot, type: .debug,
               frameIndex, frame.isFinal, frame.shots)

        let newFrame = try frame.take(shot: shot)

        os_log("New frame (%d): (isFinal: %d, shots: %@)",
               log: Log.takeShot, type: .debug,
               frameIndex, newFrame.isFinal, newFrame.shots)

        let newNode = Node(FrameScore(frame: newFrame))

        var node: Node<FrameScore>? = head

        for _ in 0..<frameIndex {
            node = node?.next
            os_log("Advanced to next node")
        }

        guard let current = node else {
            throw TakeShotError.invalidFrameSetup
        }

        // Replace the current node with the new node
        current.previous?.next = newNode
        newNode.previous = current.previous
        newNode.next = current.next
        current.next?.previous = newNode

        os_log("Replacing frame (%d): (isFinal: %d, shots: %@)",
               log: Log.takeShot, type: .debug,
               frameIndex, current.value.frame.isFinal, current.value.frame.shots)

        // If the current node was the head, reassign head to the new node
        if current.previous == nil || current === head {
            os_log("Replacing head with newNode",
                   log: Log.takeShot, type: .debug)
            head = newNode
        }

        recalculateScores()
    }

    /// Returns the frame index and node that holds the frame the player can take shots in,
    /// or the final frame if all shots are taken
    func currentFrame() -> (Int, Frame) {
        var current: Node<FrameScore>? = head
        var tail = head
        var index = 0

        repeat {
            guard let node = current else { continue }

            if !node.value.frame.allNecessaryShotsTaken() {
                return (index, node.value.frame)
            }

            if let next = node.next {
                tail = next
                index += 1
            }

            current = node.next
        } while current != nil

        return (index, tail.value.frame)
    }

    // MARK: - Private

    private func recalculateScores() {
        var current: Node<FrameScore>? = head
        repeat {
            guard let node = current else { continue }

            let frameScore = calculateFrameScore(at: node)

            let previousRunningTotalScore = node.previous?.value.runningTotalScore ?? 0
            let runningTotalScore = previousRunningTotalScore + frameScore

            let new = FrameScore(frame: node.value.frame,
                                 frameScore: frameScore,
                                 runningTotalScore: runningTotalScore)

            let newNode = Node(new)

            // Replace the current node with the new node
            node.previous?.next = newNode
            newNode.previous = node.previous
            newNode.next = node.next
            node.next?.previous = newNode

            // If the current node was the head, reassign head to the new node
            if node.previous == nil || node === head {
                head = newNode
            }

            current = node.next
        } while current != nil
    }

    private func calculateFrameScore(at node: Node<FrameScore>) -> Score {
        let frame = node.value.frame

        if frame.shots.isEmpty {
            return 0
        }

        if !frame.isFinal {
            if frame.shots.count == 1 {
                if case .strike = frame.shots[0] {
                    // Return 10 + the value of the next two shots

                    if let nextNode = node.next {
                        let nextFrameShots = nextNode.value.frame.shots
                        let nextShot = nextFrameShots.first
                        let nextShotValue = nextShot?.numericValue ?? 0

                        var subsequentShot: Shot?

                        if let nextShot = nextShot {
                            if case .strike = nextShot, !nextNode.value.frame.isFinal {
                                // Was a strike, no subsequent shot in that frame
                                // Check the subsequent frame for the second shot
                                let subsequentNode = nextNode.next
                                let subsequentFrameShots = subsequentNode?.value.frame.shots
                                subsequentShot = subsequentFrameShots?.first
                            } else {
                                // Not a strike, can get subsequent shot from the same frame
                                let nextFrameShots = nextNode.value.frame.shots
                                if nextFrameShots.count >= 2 {
                                    subsequentShot = nextFrameShots[1]
                                }
                            }
                        }

                        let subsequentShotValue = subsequentShot?.numericValue ?? 0
                        return frame.shots[0].numericValue + nextShotValue + subsequentShotValue
                    }

                    return frame.shots[0].numericValue
                }
            }

            if frame.shots.count == 2 {
                if case .spare(_) = frame.shots[1] {
                    // Return 10 + the value of the next shot
                    let nextShotValue = node.next?.value.frame.shots.first?.numericValue ?? 0
                    return frame.shots[0].numericValue + frame.shots[1].numericValue + nextShotValue
                }
            }
        }

        return frame.shots.map({ $0.numericValue }).reduce(into: 0, +=)
    }
}
