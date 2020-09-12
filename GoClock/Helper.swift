//
//  Helper.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/11.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}
