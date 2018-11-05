//
//  ChartsViewController.swift
//  MistAir
//
//  Created by Michelle Zhu on 5/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit
import Firebase
import Charts

class ChartsViewController: UIViewController, ChartViewDelegate {

    //tab bar
    var customTabBar: BaseTabBarController?
    
    //humidity history dict
    var humidityHistory: [String: Double] = [:]
    
    //humidity history list
    var humidityList = [Humidity]()
    
//    //UI programatically
    let titleLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.text = "Have a look at how the humidity level has changed over time."
        label.textColor = UIColor.customGrey
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    //hourly line chart
    let dailyLineChart: LineChartView = {
        let chart = LineChartView()
        chart.chartDescription?.enabled = false
        chart.xAxis.labelPosition = .bottom
        chart.leftAxis.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.xAxis.labelTextColor = UIColor.white
        chart.rightAxis.labelTextColor = UIColor.white
        chart.legend.textColor = UIColor.white
        chart.dragXEnabled = true
        chart.dragYEnabled = false
        chart.scaleYEnabled = false
        chart.scaleXEnabled = false
        chart.xAxis.avoidFirstLastClippingEnabled = true
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        return chart
    }()
    
    //views to display selected values from chart
    let maxView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let maxLabel: UILabel = {
       let label = UILabel()
        label.text = "Higher humidity"
        label.backgroundColor = UIColor.buttonPurple
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    let maxText: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        return label
    }()
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tab bar
        customTabBar = self.tabBarController as? BaseTabBarController
        
        //background colour
        self.view.backgroundColor = UIColor.darkPurple
        
        //chart delegate
        dailyLineChart.delegate = self
        
        //setup UI
        setupTitleLabel()
        
        //setup line charts
        setupDailyLineChart()
        
        //labels
        setupMaxView()
        
        //get data from firebase
        getHumidityData()
        createHumidityList()
        setDailyChartValue()
        
    }
    
    //add constraint to title label
    private func setupTitleLabel(){
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //add constraint to daily line chart
    private func setupDailyLineChart(){
        self.view.addSubview(dailyLineChart)
        dailyLineChart.translatesAutoresizingMaskIntoConstraints = false
        dailyLineChart.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 24).isActive = true
        dailyLineChart.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        dailyLineChart.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        dailyLineChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }

    //max view UI
    private func setupMaxView(){
        self.view.addSubview(maxView)
        self.maxView.addSubview(maxLabel)
        self.maxView.addSubview(maxText)
        
        self.maxView.translatesAutoresizingMaskIntoConstraints = false
        self.maxLabel.translatesAutoresizingMaskIntoConstraints = false
        self.maxText.translatesAutoresizingMaskIntoConstraints = false
        
        //max view
        self.maxView.topAnchor.constraint(equalTo: self.dailyLineChart.bottomAnchor, constant: 16).isActive = true
        self.maxView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        self.maxView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        self.maxView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //max label
        self.maxLabel.topAnchor.constraint(equalTo: self.maxView.topAnchor, constant: 0).isActive = true
        self.maxLabel.leftAnchor.constraint(equalTo: self.maxView.leftAnchor, constant: 0).isActive = true
        self.maxLabel.widthAnchor.constraint(equalToConstant: self.maxView.frame.size.width/2).isActive = true
        self.maxLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //
        self.maxText.topAnchor.constraint(equalTo: self.maxView.topAnchor, constant: 0).isActive = true
        self.maxText.leftAnchor.constraint(equalTo: self.maxLabel.rightAnchor, constant: 8).isActive = true
        self.maxText.rightAnchor.constraint(equalTo: self.maxView.rightAnchor, constant: 0).isActive = true
        self.maxText.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    

    //get data from firebase
    private func getHumidityData(){
        self.humidityHistory = (customTabBar?.humidiferFirebase.myHumidifierStatus.humidityHistory)!
    }
    
    //assign data to humidity list
    private func createHumidityList(){
        var tempList = [Humidity]()
        for (key,value) in self.humidityHistory{
            let time = NSDate.convertStringToDate(stringTime: key)
            let humidityItem = Humidity(time: time as Date, avgHumidity: value)
            tempList.append(humidityItem)
        }
        //sort the list by time ascendingly
        self.humidityList = tempList.sorted(by: { $0.time! < $1.time!} )
    }
    
    //how to customize line chart: https://medium.com/@felicity.johnson.mail/lets-make-some-charts-ios-charts-5b8e42c20bc9
    //set daily chart value
    
    func setDailyChartValue(){
        
        var dates = [String]()//to store week day for xaxis display
        var values = [ChartDataEntry]()//for line chart data
        
        var count = 0
        var y = 0.0
        
        for humidity in self.humidityList{
            //change time to weekday to display at the xaxis label
            let date = NSDate.convertNSdateToStringDate(date: humidity.time! as NSDate)
            dates.append(date)

            
            //assign humidity values as dataset
            y = humidity.avgHumidity!
            let value = ChartDataEntry(x:Double(count),y:y)
            values.append(value)
            count += 1
        }
        
        
        //dataset
        let dataSet = LineChartDataSet(values: values, label: "Average Daily Humidity")
        let data = LineChartData(dataSet: dataSet)
        dataSet.colors = [UIColor.brightPurple]
        dataSet.circleRadius = 5
        dataSet.setCircleColor(UIColor.brightPurple)
        dataSet.circleHoleRadius = 0
        dataSet.valueColors = [UIColor.white]

        //gradient fill
        let gradientColors = [UIColor.brightPurple.cgColor, UIColor.white.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0] //positionning of gradient
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),colors:gradientColors,locations: colorLocations) else {
            print("gradient error");return}
        dataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        dataSet.drawFilledEnabled = true
        
        
        //axes setup
        let formatter : LineChartFormatter = LineChartFormatter()
        formatter.setValue(values: dates)
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
        dailyLineChart.xAxis.valueFormatter = xaxis.valueFormatter
        
        //self.dailyLineChart.xAxis = dataPoints
        self.dailyLineChart.data = data
        
        self.dailyLineChart.setVisibleXRangeMaximum(7.0)
        self.dailyLineChart.moveViewToX(0.0)
    }
    
    //delegate function
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("\(entry)")
    }
}
