// The MIT License (MIT)
// 
// Copyright (c) 2014 Federal Office of Topography swisstopo, Wabern, CH
// Copyright (c) 2016 Sacha Bron https://github.com/BinaryBrain
// Copyright (c) 2016 Basile Vu https://github.com/Flagoul
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
// 


// Source: http://www.swisstopo.admin.ch/internet/swisstopo/en/home/topics/survey/sys/refsys/projections.html (see PDFs under "Documentation")
// Updated 9 dec 2014
// Please validate your results with NAVREF on-line service: http://www.swisstopo.admin.ch/internet/swisstopo/en/home/apps/calc/navref.html (difference ~ 1-2m)


//
//  SwissToLatLonConversion.swift
//  Timetable
//
//  Created by Michael Ruepp on 07.03.20.
//  Copyright © 2020 Michael Ruepp. All rights reserved.
//

import Foundation
import MapKit

class SwissToLatLonConversion {
    public var x: Double = 0
    public var y: Double = 0
    private var xaux: Double = 0
    private var yaux: Double = 0
    
    
    private func swissToLat() -> Double {
        let latAux = (16.9023892 + (3.238272 * xaux)) +
            -(0.270978 * pow(yaux, 2)) +
            -(0.002528 * pow(xaux, 2)) +
            -(0.0447 * pow(yaux, 2) * xaux) +
            -(0.0140 * pow(xaux, 3))
        // Unit 10000" to 1" and convert seconds to degrees (dec)
        return (latAux * 100) / 36
    }
    
    private func swissToLon() -> Double {
        let lonAux = (2.6779094 + (4.728982 * yaux) +
            +(0.791484 * yaux * xaux) +
            +(0.1306 * yaux * pow(xaux, 2))) +
            -(0.0436 * pow(yaux, 3))
        // Unit 10000" to 1" and convert seconds to degrees (dec)
        return (lonAux * 100) / 36
    }
    
    func latlonFromString(_ x: String, _ y: String) -> String {
        self.x = Double(x)!
        self.y = Double(y)!
        self.xaux = (self.x - 200000) / 1000000
        self.yaux = (self.y - 600000) / 1000000
        //print(x,y,xaux,yaux)
        return ("\(swissToLat()),\(swissToLon())")
    }
    
    func latlonCLLocation2D(_ x: String, _ y: String) -> CLLocationCoordinate2D {
        self.x = Double(x)!
        self.y = Double(y)!
        self.xaux = (self.x - 200000) / 1000000
        self.yaux = (self.y - 600000) / 1000000
        //print(x,y,xaux,yaux)
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(swissToLat()), longitude: CLLocationDegrees(swissToLon()))
    }
}
