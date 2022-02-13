//
//  ContentView.swift
//  Oekaki
//
//  Created by 大津 真 on 2020/04/21.
//  Copyright © 2020 大津 真. All rights reserved.
//
import SwiftUI

struct ContentView: View {
    @State private var  colors:[Color] = [.black, .red, .blue, .green, .white]
    // 現在選択されている色
    @State private var colorSel = 0
    // 線幅
    @State private var lineWidth = 5
    // ひとつの線
    @State private var line: Line = Line()
    // 線の配列
    @State private var lines: [Line] = []
    // 設定シートの表示
    @State private var showSetting = false
    
    var body: some View {
        VStack {
            ZStack {
                Color.white
                    .gesture(DragGesture()
                        .onChanged{value in
                            self.line.points.append(value.location)
                    }
                    .onEnded{ value in
                        self.line.color = self.colors[self.colorSel]
                        self.line.lineWidth = self.lineWidth
                        // lines配列に線を追加する
                        self.lines.append(self.line)
                        self.line = Line(points: [], color: self.colors[self.colorSel], lineWidth: self.lineWidth)
                        }
                    )

                // ドラッグ中以外のすべての線を描画
                ForEach(lines) { oneLine in
                    Path { path in
                        path.addLines(oneLine.points)
                    }
                    .stroke(oneLine.color, lineWidth: CGFloat(oneLine.lineWidth + 1))
                }
                // ドラッグ中の線の描画
                Path{ path in
                    path.addLines(self.line.points)
                }
                .stroke(self.colors[colorSel], lineWidth: CGFloat(self.lineWidth + 1))
            }

            // ツールバー用アイコン
            HStack{
                // 設定
                Button(action: {
                    self.showSetting = true
                }) {
                    Image(systemName: "gear")
                }
                .sheet(isPresented: $showSetting) {
                    SettingView(colorSel: self.$colorSel, lineWidth: self.$lineWidth, colors: self.$colors)
                }
                
                // Undo（ひとつ前の線を消去）
                Button(action: {
                    if self.lines.count > 0 {
                        self.lines.removeLast()
                    }
                }) {
                    Image(systemName: "arrow.uturn.left.circle")
                }
                
                // 全ての線を削除
                Button(action: {
                    if self.lines.count > 0 {
                        self.lines.removeAll()
                    }
                }) {
                    Image(systemName: "trash")
                }
                
            }.frame(height: 50)
        }
    }
}

struct Line: Identifiable {
    var points: [CGPoint] = []
    var color: Color = .black
    var lineWidth = 5
    var id = UUID()    // IDを設定
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
