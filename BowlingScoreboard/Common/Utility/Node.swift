//
//  Node.swift
//  BowlingScoreboard
//
//  Created by Joshua Finch on 29/08/2018.
//  Copyright © 2018 Joshua Finch. All rights reserved.
//

import Foundation

public final class Node<Value> {

    public var next: Node?
    public var previous: Node?

    public let value: Value

    public init(_ value: Value) {
        self.value = value
    }

    /// Appends `value` as a new node, at the tail of the linked list, and returns that Node
    @discardableResult
    public func append(_ value: Value) -> Node<Value> {

        let newTail = Node(value)

        var tail = self

        while let next = next {
            tail = next
        }

        tail.next = newTail
        newTail.previous = tail

        return newTail
    }

    /// Prepends `value` as a new node, at the head of the linked list, and returns that Node
    @discardableResult
    public func prepend(_ value: Value) -> Node<Value> {

        let newHead = Node(value)

        var head = self

        while let previous = previous {
            head = previous
        }

        head.previous = newHead
        newHead.previous = nil
        newHead.next = head

        return newHead
    }

    /// Deletes the current node, updating next and previous links
    /// on previous and next nodes respectively to point to the correct nodes
    public func delete() {
        previous?.next = next
        next?.previous = previous
    }
}

extension Node: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(value)"
    }

    /// Returns all subsequent nodes in an array format (inclusive of current node)
    public func toArray() -> [Value] {

        var arr = [Value]()

        var node = self
        arr.append(value)

        while let next = node.next {
            arr.append(next.value)
            node = next
        }

        return arr
    }
}
