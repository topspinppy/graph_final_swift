//
//  ViewController.swift
//  testfFinal
//
//  Created by champis on 3/4/2562 BE.
//  Copyright © 2562 sdflerfff. All rights reserved.
//



//
//  ViewController.swift
//  appApiCountry
//
//  Created by Admin on 3/4/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import Charts

struct jsonstruct:Decodable {
    let name:String?
    let capital:String?
    let alpha2Code:String?
    let alpha3Code:String?
    let region:String?
    let subregion:String?
    let population: Int?
    let area: Double?
    
}

class ViewController: UIViewController,ChartViewDelegate {
    var testNa = [jsonstruct]()
    var country = [Double]()
    var population = [Double]()
    var name = [String]()
    @IBOutlet weak var textFieldLang: UITextField!
    
    @IBOutlet weak var chartView: CombinedChartView!
    
    @IBAction func OKNA(_ sender: Any) {
        if(textFieldLang.text! != "")
        {
            getdata(languages: textFieldLang.text!)
            self.setChart(xValues: name, yValuesLineChart:  country, yValuesBarChart: population)
        }
        else {
            print("error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getdata(languages: String){
        let jsonUrlString = "https://restcountries.eu/rest/v2/lang/\(languages)"
        print(jsonUrlString)
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, responds,err) in
            guard let data = data else {return}
            do {
                self.country = []
                self.population = []
                self.name = []
                
                self.testNa = try JSONDecoder().decode([jsonstruct].self, from: data)
                for mainarr in self.testNa{
//                    if mainarr.subregion == "Southern Asia" {
                        self.population.append(Double(mainarr.population ?? 0)/10000000)
                        self.country.append(Double(mainarr.area ?? 0)/100000000)
                        self.name.append(mainarr.alpha3Code ?? "")
//                    }
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            }.resume()
    }
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        chartView.noDataText = "Please provide data for the chart."
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        for i in 0..<xValues.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: yValuesLineChart[i],data: xValues as AnyObject?))
            yVals2.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i],data: xValues as AnyObject?))
        }
        
        let lineChartSet = LineChartDataSet(values: yVals1, label: "Line Data")
        let barChartSet: BarChartDataSet = BarChartDataSet(values: yVals2, label: "Bar Data")
        let data: CombinedChartData = CombinedChartData()
        data.barData=BarChartData(dataSets: [barChartSet])
        if yValuesLineChart.contains(0) == false {
            data.lineData = LineChartData(dataSets:[lineChartSet] )
            
        }
        chartView.data = data
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xValues)
        chartView.xAxis.granularity = 1
        barChartSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
    }
}
