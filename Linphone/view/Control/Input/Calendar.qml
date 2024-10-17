import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import QtQuick.Effects

import Linphone
import ConstantsCpp 1.0
import UtilsCpp 1.0

ListView {
	id: mainItem
	snapMode: ListView.SnapOneItem
	orientation: Qt.Horizontal
	clip: true
	property int maxYears: 5
	readonly property var currentDate: new Date()
	highlightMoveDuration: 100
	// height: contentHeight

	property var selectedDate

	property int currentMonth: calendarModel.monthAt(currentIndex) + 1 //january is index 0
	property int currentYear: calendarModel.yearAt(currentIndex)
	onCurrentYearChanged: console.log("currentyear", currentYear)
	onCurrentMonthChanged: console.log("current month", currentMonth)
	keyNavigationEnabled: false

	model: Control.CalendarModel {
		id: calendarModel
		from: new Date()
		to: UtilsCpp.addYears(new Date(), 5)
	}
	
	delegate: FocusScope{
		width: mainItem.width
		height: mainItem.height
		property bool isCurrentIndex: index == mainItem.currentIndex
		onIsCurrentIndexChanged: if( isCurrentIndex) monthGrid.forceActiveFocus()
		ColumnLayout {
			anchors.fill: parent
			property int currentMonth: model.month
			spacing: 18 * mainWindow.dp
			RowLayout {
				Layout.fillWidth: true
				spacing: 38 * mainWindow.dp
				Text {
					text: UtilsCpp.toDateMonthAndYearString(new Date(model.year, model.month, 15))// 15 because of timezones that can change the date for localeString
					font {
						pixelSize: 14 * mainWindow.dp
						weight: 700 * mainWindow.dp
						capitalization: Font.Capitalize
					}
				}
				Item {
					Layout.fillWidth: true
				}
				Button {
					id: previousButton
					Layout.preferredWidth: 20 * mainWindow.dp
					Layout.preferredHeight: 20 * mainWindow.dp
					icon.width: width
					icon.height: height
					background: Item{}
					icon.source: AppIcons.leftArrow
					onClicked: if (mainItem.currentIndex > 0) mainItem.currentIndex = mainItem.currentIndex - 1
				}
				Button {
					id: nextButton
					Layout.preferredWidth: 20 * mainWindow.dp
					Layout.preferredHeight: 20 * mainWindow.dp
					icon.width: width
					icon.height: height
					background: Item{}
					icon.source: AppIcons.rightArrow
					onClicked: if (mainItem.currentIndex < mainItem.count) mainItem.currentIndex = mainItem.currentIndex + 1
				}
			}
	
			ColumnLayout {
				spacing: 12 * mainWindow.dp
				Control.DayOfWeekRow {
					locale: monthGrid.locale
					Layout.column: 1
					Layout.fillWidth: true
					delegate: Text {
						text: model.shortName
						color: DefaultStyle.main2_400
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						font {
							pixelSize: 12 * mainWindow.dp
							weight: 300 * mainWindow.dp
						}
					}
				}
	
				Control.MonthGrid {
					id: monthGrid
					Layout.fillWidth: true
					Layout.fillHeight: true
					year: model.year
					month: model.month
					property var curDate: model.date
					locale: Qt.locale(ConstantsCpp.DefaultLocale)
					delegate: FocusScope {
						id: focusDay
						property bool isSelectedDay: mainItem.selectedDate ? UtilsCpp.datesAreEqual(mainItem.selectedDate, model.date) : false
						property var d: model.date
						objectName: 'focusDay'
						activeFocusOnTab: true
						focus: UtilsCpp.isCurrentMonth(model.date) && UtilsCpp.isCurrentDay(model.date) || index == 0
						Keys.onPressed: (event)=> {
							if (event.key == Qt.Key_Space || event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
								monthGrid.clicked(model.date)
								event.accepted = true;
							}else if(event.key == Qt.Key_Left){
								var previous = nextItemInFocusChain(false)
								if( previous.objectName != 'focusDay'){
									previousButton.clicked(undefined)
								}else{
									if (UtilsCpp.daysOffset(new Date(), model.date) >= 0) previous.forceActiveFocus()
								}
							}else if(event.key == Qt.Key_Right){
								var next = nextItemInFocusChain()
								if( next.objectName != 'focusDay'){
									nextButton.clicked(undefined)
								} else {
									next.forceActiveFocus()
								}
							}	
						}
						
						MouseArea{
							id: hoveringArea
							anchors.fill: parent
							hoverEnabled: true
							cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
							acceptedButtons: Qt.LeftButton
							// onEntered: focusDay.forceActiveFocus()
							onPressed: (event) =>{
								focusDay.forceActiveFocus()
								event.accepted = false
							}
						}
						
						Rectangle {
							anchors.centerIn: parent
							width: 30 * mainWindow.dp
							height: 30 * mainWindow.dp
							radius: 50 * mainWindow.dp
							color: isSelectedDay ? DefaultStyle.main1_500_main : "transparent"
							border.width: focusDay.activeFocus || hoveringArea.containsMouse ? 1 : 0
							
						}
						Text {
							anchors.centerIn: parent
							text: UtilsCpp.toDateDayString(model.date)
							color: isSelectedDay
								? DefaultStyle.grey_0
								: UtilsCpp.isCurrentDay(model.date)
									? DefaultStyle.main1_500_main
									: UtilsCpp.dateisInMonth(model.date, mainItem.currentMonth, mainItem.currentYear)
										? DefaultStyle.main2_700
										: DefaultStyle.main2_400
							font {
								pixelSize: 12 * mainWindow.dp
								weight: 300 * mainWindow.dp
							}
						}
					}
					onClicked: (date) => {
						if (UtilsCpp.daysOffset(new Date(), date) >= 0) mainItem.selectedDate = date
					}
				}
			}
		}
	}
}
