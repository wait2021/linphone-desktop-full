import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import Linphone
import QtQml
import UtilsCpp

ListView {
	id: mainItem
	visible: count > 0
	onVisibleChanged: if (!visible) confInfoProxy.clear()
	clip: true

	property string searchBarText
	property bool hoverEnabled: true	
	property var delegateButtons
	property ConferenceInfoGui selectedConference
	property bool _moveToIndex: false

	signal meetingSelected()
	onMeetingSelected: {
		updatePosition()
	}
	spacing: 8 * DefaultStyle.dp
	highlightFollowsCurrentItem: false
	// highlightMoveVelocity: 1500

	onCountChanged: if(_moveToIndex && count > mainItem.currentIndex){
		_moveToIndex = false
		selectIndex(mainItem.currentIndex)
	}

	function selectIndex(index){
		if (index < 0) return
		// confInfoProxy.loadUntil()
		mainItem.currentIndex = index
		console.log("select index", currentIndex, index)
		var item = itemAtIndex(index)
		confInfoProxy.loadUntil(model.count - 1)
		if(item){// Item is ready and available
			mainItem.selectedConference = item && item.itemGui || null
			item.forceActiveFocus()
			updatePosition()
		} else {
			_moveToIndex = true
			console.log("NO ITEM")
		}
	}
	
	onAtYEndChanged: if(atYEnd) confInfoProxy.displayMore()

	function updatePosition(){
		var item = itemAtIndex(currentIndex)
		var centerItemPos = 0
		console.log("update position for item", item, currentIndex)
		if(item){
			centerItemPos = item.y + y + item.height/2
			var centerPos = centerItemPos - height/2
			mainItem.contentY = Math.max(0, Math.min(centerPos, contentHeight-height, height))
		} else {
			console.log("NO ITEM")
		}
	}
	Behavior on contentY{
		NumberAnimation {
			duration: 500
			easing.type: Easing.OutExpo
		}
	}

	Keys.onPressed: (event)=> {
		var direction = (event.key == Qt.Key_Up ? -1 : 1)
		if(event.key == Qt.Key_Up) {
			if(currentIndex > 0 ) {
				selectIndex(mainItem.currentIndex-1)
				event.accepted = true
			} else {
				selectIndex(model.count - 1)
				event.accepted = true
			}
		}else if(event.key == Qt.Key_Down){
			if(currentIndex < model.count - 1) {
				selectIndex(currentIndex+1)
				event.accepted = true
			} else {
				selectIndex(0)
				event.accepted = true
			}
		}
	}
	
	model: ConferenceInfoProxy {
		id: confInfoProxy
		filterText: searchBarText
		filterType: ConferenceInfoProxy.None
		initialDisplayItems: mainItem.height / (63 * DefaultStyle.dp) + 5
		displayItemsStep: initialDisplayItems/2
		onConferenceInfoCreated: (data) => {
			console.log("select conf created", data.core.subject)
			// confInfoProxy.loadUntil(data)
			mainItem.selectedConference = data
		}
		onCurrentConfInfoChanged: (confInfoGui) => {
			console.log("selected conf changed", confInfoGui)
			confInfoProxy.loadUntil(confInfoGui)
			if (confInfoGui.core) console.log("with subject", confInfoGui.core.subject)
			mainItem.selectedConference = confInfoGui
		}
	}

	section {
		criteria: ViewSection.FullString
		delegate: Text {
			topPadding: 24 * DefaultStyle.dp
			bottomPadding: 16 * DefaultStyle.dp
			text: section
			height: 29 * DefaultStyle.dp + topPadding + bottomPadding
			wrapMode: Text.NoWrap
			font {
				pixelSize: 20 * DefaultStyle.dp
				weight: 800 * DefaultStyle.dp
				capitalization: Font.Capitalize
			}
		}
		property: '$sectionMonth'
	}

	delegate: FocusScope {
		id: itemDelegate
		height: 63 * DefaultStyle.dp
		width: mainItem.width
		enabled: !isCanceled && haveModel
		property ConferenceInfoGui itemGui: $modelData
		property ConferenceInfoGui previousItem : mainItem.model.count > 0 && index > 0 ? mainItem.model.getAt(index-1) : null
		property var dateTime: itemGui ? itemGui.core.dateTime : UtilsCpp.getCurrentDateTime()
		property string day : UtilsCpp.toDateDayNameString(dateTime)
		property string dateString:  UtilsCpp.toDateString(dateTime)
		property string previousDateString: previousItem ? UtilsCpp.toDateString(previousItem.core ? previousItem.core.dateTimeUtc : UtilsCpp.getCurrentDateTimeUtc()) : ''
		property bool isFirst : ListView.previousSection !== ListView.section
		property int topOffset: (dateDay.visible && !isFirst? 8 * DefaultStyle.dp : 0)
		property var endDateTime: itemGui ? itemGui.core.endDateTime : UtilsCpp.getCurrentDateTime()
		property bool haveModel: itemGui ? itemGui.core.haveModel : false
		property bool isCanceled: itemGui ? itemGui.core.state === LinphoneEnums.ConferenceInfoState.Cancelled : false
		property bool isSelected: !itemGui ? !mainItem.selectedConference : mainItem.selectedConference && itemGui.core === mainItem.selectedConference.core
		onIsSelectedChanged: {
			if(isSelected) {
				console.log("select delegate at index", index)
				// mainItem.currentIndex = index
				mainItem.selectIndex(index)
			}
		}
		Component.onCompleted: if (!isFirst && dateDay.visible) {
			height = (63+topOffset)*DefaultStyle.dp
			delegateIn.anchors.topMargin = topOffset
		}
		
		RowLayout{
			id: delegateIn
			anchors.fill: parent
			spacing: 0
			Item{
				Layout.preferredWidth: 32 * DefaultStyle.dp
				visible: !dateDay.visible
			}
			ColumnLayout {
				id: dateDay
				Layout.fillWidth: false
				Layout.preferredWidth: 32 * DefaultStyle.dp
				Layout.minimumWidth: 32 * DefaultStyle.dp
				Layout.preferredHeight: 51 * DefaultStyle.dp
				visible: previousDateString.length == 0 || previousDateString != dateString
				spacing: 0
				Text {
					Layout.preferredHeight: 19 * DefaultStyle.dp
					Layout.alignment: Qt.AlignCenter
					text: day.substring(0,3) + '.'
					color: DefaultStyle.main2_500main
					wrapMode: Text.NoWrap
					elide: Text.ElideNone
					font {
						pixelSize: 14 * DefaultStyle.dp
						weight: 400 * DefaultStyle.dp
						capitalization: Font.Capitalize
					}
				}
				Rectangle {
					id: dayNum
					Layout.preferredWidth: 32 * DefaultStyle.dp
					Layout.preferredHeight: 32 * DefaultStyle.dp
					Layout.alignment: Qt.AlignCenter
					radius: height/2
					property var isCurrentDay: UtilsCpp.isCurrentDay(dateTime)

					color: isCurrentDay ? DefaultStyle.main1_500_main : "transparent"
					
					Text {
						anchors.centerIn: parent
						verticalAlignment: Text.AlignVCenter
						horizontalAlignment: Text.AlignHCenter
						text: UtilsCpp.toDateDayString(dateTime)
						color: dayNum.isCurrentDay ? DefaultStyle.grey_0 : DefaultStyle.main2_500main
						wrapMode: Text.NoWrap
						font {
							pixelSize: 20 * DefaultStyle.dp
							weight: 800 * DefaultStyle.dp
						}
					}
				}
				Item{Layout.fillHeight:true;Layout.fillWidth: true}
			}
			Item {
				Layout.preferredWidth: 265 * DefaultStyle.dp
				Layout.preferredHeight: 63 * DefaultStyle.dp
				Layout.leftMargin: 23 * DefaultStyle.dp
				Rectangle {
					id: conferenceInfoDelegate
					anchors.fill: parent
					anchors.rightMargin: 5	// margin to avoid clipping shadows at right
					radius: 10 * DefaultStyle.dp
					visible: itemDelegate.haveModel || itemDelegate.activeFocus
					color: itemDelegate.isSelected ? DefaultStyle.main2_200 : DefaultStyle.grey_0 // mainItem.currentIndex === index
					ColumnLayout {
						anchors.fill: parent
						anchors.left: parent.left
						anchors.leftMargin: 15 * DefaultStyle.dp
						spacing: 2 * DefaultStyle.dp
						visible: itemDelegate.haveModel
						RowLayout {
							spacing: 8 * DefaultStyle.dp
							Image {
								source: AppIcons.usersThree
								Layout.preferredWidth: 24 * DefaultStyle.dp
								Layout.preferredHeight: 24 * DefaultStyle.dp
							}
							Text {
								text: itemGui? itemGui.core.subject : ""
								Layout.fillWidth: true
								maximumLineCount: 1
								font {
									pixelSize: 13 * DefaultStyle.dp
									weight: 700 * DefaultStyle.dp
								}
							}
						}
						Text {
							text: itemDelegate.isCanceled ? qsTr("Réunion annulée") : UtilsCpp.toDateHourString(dateTime) + " - " + UtilsCpp.toDateHourString(endDateTime)
							color: itemDelegate.isCanceled ? DefaultStyle.danger_500main : DefaultStyle.main2_500main
							font {
								pixelSize: 14 * DefaultStyle.dp
								weight: 400 * DefaultStyle.dp
							}
						}
					}
				}
				MultiEffect {
					source: conferenceInfoDelegate
					anchors.fill: conferenceInfoDelegate
					visible: itemDelegate.haveModel
					shadowEnabled: true
					shadowBlur: 0.7
					shadowOpacity: 0.2
				}
				Text {
					anchors.fill: parent
					anchors.rightMargin: 5 * DefaultStyle.dp // margin to avoid clipping shadows at right
					anchors.leftMargin: 16 * DefaultStyle.dp
					verticalAlignment: Text.AlignVCenter
					visible: !itemDelegate.haveModel
					text: qsTr("Aucune réunion aujourd'hui")
					lineHeightMode: Text.FixedHeight
					lineHeight: 17.71 * DefaultStyle.dp
					font {
						pixelSize: 13 * DefaultStyle.dp
						weight: 700
					}
				}
				MouseArea {
					hoverEnabled: mainItem.hoverEnabled
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					visible: itemDelegate.haveModel
					onClicked: {
						confInfoProxy.setCurrentConfInfo(itemGui)
						itemDelegate.forceActiveFocus()
						mainItem.meetingSelected()
					}
				}
			}
		}
	}
}
