//
//  ACDataStore.swift
//  AxisContribution
//
//  Created by jasu on 2022/02/23.
//  Copyright (c) 2022 jasu All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import SwiftUI

/// A ViewModel that manages grid data.
class ACDataStore: ObservableObject {
    
    @Published var constant: ACConstant = .init()
    @Published var datas: [[ACData]] = [[]]
    
    /// A method that creates data.
    /// - Parameters:
    ///   - constant: Settings that define the contribution view.
    ///   - sourceDates: An array of contributed dates.
    ///   - axisMode: The axis mode of the component.
    func setup(constant: ACConstant, source sourceDates: [Date], axisMode: ACAxisMode = .horizontal) {
        self.constant = constant
        mappingDatas(createDatas(axisMode: axisMode), sourceDates)
    }
    
    /// Generate data from start date to end date.
    /// - Parameter axisMode: The axis mode of the component.
    /// - Returns: An array of data.
    private func createDatas(axisMode: ACAxisMode) -> [ACData] {
        var sequenceDatas = [ACData]()
        var newDatas = [[ACData]]()
        var dateWeekly = Date.datesWeekly(from: constant.fromDate, to: constant.toDate)
        if axisMode == .vertical {
            dateWeekly = dateWeekly.reversed()
        }
        dateWeekly.forEach { date in
            let datas = date.datesInWeek.map { date in
                ACData(date: date)
            }
            newDatas.append(datas)
            sequenceDatas.append(contentsOf: datas)
        }
        self.datas = newDatas
        return sequenceDatas
    }
    
    /// Merges contribution date counts into your data.
    /// - Parameters:
    ///   - sequenceDatas: An array of all data.
    ///   - sourceDates: An array of contributed dates.
    private func mappingDatas(_ sequenceDatas: [ACData], _ sourceDates: [Date]) {
        guard !datas.isEmpty else { return }
        for date in sourceDates {
            if let data = getData(sequenceDatas: sequenceDatas, date: date) {
                data.count += 1
            }
        }
    }
    
    /// Returns data corresponding to the date you pass in.
    /// - Parameters:
    ///   - sequenceDatas: An array of all data.
    ///   - date: The date required to return the data.
    /// - Returns: -
    private func getData(sequenceDatas: [ACData], date: Date) -> ACData? {
        let datas = sequenceDatas.filter { data in
            data.date.startOfDay == date.startOfDay
        }
        return datas.isEmpty ? nil : datas[0]
    }
}
