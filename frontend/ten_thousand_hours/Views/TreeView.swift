//
//  TreeView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/30/23.
//

import SwiftUI

struct Node: Identifiable {
    var id = UUID()
    var name: String
    var children: [Node]
    var position: CGPoint // 添加位置属性
}

struct NodeView: View {
    var node: Node

    var body: some View {
        Text(node.name)
            .padding()
            .background(Circle().fill(Color.blue))
            .foregroundColor(.white)
            .frame(width: 100, height: 100)
            .position(node.position) // 使用节点的位置
    }
}

struct ConnectionLine: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct TreeView: View {
    var rootNode: Node

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            ZStack {
                // 绘制连接线
                ForEach(rootNode.children) { child in
                    ConnectionLine(start: rootNode.position, end: child.position)
                        .stroke(Color.gray, lineWidth: 2)
                }

                // 放置所有节点视图
                ForEach(rootNode.children) { childNode in
                    NodeView(node: childNode)
                }
            }
        }
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        // 生成随机位置
        func randomPosition() -> CGPoint {
            return CGPoint(x: CGFloat.random(in: 100...300), y: CGFloat.random(in: 100...500))
        }

        // 示例节点，带有随机位置
        let rootNode = Node(name: "Root", children: [
            Node(name: "Child 1", children: [], position: randomPosition()),
            Node(name: "Child 2", children: [], position: randomPosition()),
            Node(name: "Child 3", children: [], position: randomPosition()),
            Node(name: "Child 4", children: [], position: randomPosition())
        ], position: CGPoint(x: 200, y: 200)) // 根节点位置

        return TreeView(rootNode: rootNode)
    }
}
