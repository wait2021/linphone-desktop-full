import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control

import Linphone

LoginLayout {
	id: mainItem
	signal startButtonPressed()

	titleContent: [
		Text {
			id: welcome
			text: qsTr("Bienvenue")
			Layout.alignment: Qt.AlignVCenter
			Layout.leftMargin: 132 * mainWindow.dp
			color: DefaultStyle.main2_800
			font {
				pixelSize: 96 * mainWindow.dp
				weight: 800 * mainWindow.dp
			}
			scaleLettersFactor: 1.1
		},
		Text {
			Layout.alignment: Qt.AlignBottom
			Layout.leftMargin: 29 * mainWindow.dp
			Layout.bottomMargin: 19 * mainWindow.dp
			color: DefaultStyle.main2_800
			text: qsTr("sur Linphone")
			font {
				pixelSize: 36 * mainWindow.dp
				weight: 800 * mainWindow.dp
			}
			scaleLettersFactor: 1.1
		},
		Item {
			Layout.fillWidth: true
		},
		Button {
			visible: carousel.currentIndex < (carousel.itemsCount - 1)
			flat: true
			Layout.rightMargin: 50 * mainWindow.dp
			Layout.alignment: Qt.AlignVCenter | Layout.AlignRight
			background: Item {
				visible: false
			}
			contentItem: Text {
				text: qsTr("Passer")
				font {
					underline: true
					pixelSize: 13 * mainWindow.dp
					weight: 600 * mainWindow.dp
				}
			}
			onClicked: {
				console.debug("[WelcomePage] User: Click skip")
				mainItem.startButtonPressed()
			}
		}
	]
	centerContent: ColumnLayout {
		spacing: 76 * mainWindow.dp
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.leftMargin: 308 * mainWindow.dp
		anchors.topMargin: 166 * mainWindow.dp

		RowLayout {
			id: carouselLayout
			spacing: 76 * mainWindow.dp
			Image {
				id: carouselImg
				// Layout.rightMargin: 40 * mainWindow.dp
				Layout.preferredWidth: 153.22 * mainWindow.dp
				Layout.preferredHeight: 155.9 * mainWindow.dp
				fillMode: Image.PreserveAspectFit
				source: carousel.currentIndex == 0 ? AppIcons.welcomeLinphoneLogo : carousel.currentIndex == 1 ? AppIcons.welcomeLock : AppIcons.welcomeOpenSource
			}
			Carousel {
				id: carousel
				Layout.leftMargin: 75.78 * mainWindow.dp
				itemsCount: slideRepeater.count
				itemsList: Repeater {
					id: slideRepeater
					model: [
					{title: qsTr("Linphone"), text: qsTr("Une application de communication <b>sécurisée</b>,<br> <b>open source</b> et <b>française</b>.")},
					{title: qsTr("Sécurisé"), text: qsTr("Vos communications sont en sécurité grâce aux <br><b>Chiffrement de bout en bout</b>.")},
					{title: qsTr("Open Source"), text: qsTr("Une application open source et un <b>service gratuit</b> <br>depuis <b>2001</b>")}
					]
					ColumnLayout {
						spacing: 10 * mainWindow.dp
						Text {
							id: title
							text: modelData.title
							font {
								pixelSize: 29 * mainWindow.dp
								weight: 800 * mainWindow.dp
							}
						}
						Text {
							id: txt
							Layout.maximumWidth: 361 * mainWindow.dp
							wrapMode: Text.WordWrap
							font.pixelSize: 14 * mainWindow.dp
							font.weight: 400 * mainWindow.dp
							text: modelData.text
						}
					}
				}
			}
		}

		Button {
			Layout.leftMargin: 509 * mainWindow.dp
			leftPadding: 20 * mainWindow.dp
			rightPadding: 20 * mainWindow.dp
			topPadding: 11 * mainWindow.dp
			bottomPadding: 11 * mainWindow.dp
			text: carousel.currentIndex < (carousel.itemsCount - 1) ? qsTr("Suivant") : qsTr("Commencer")
			onClicked: { 
				if (carousel.currentIndex < carousel.itemsCount - 1) carousel.goToSlide(carousel.currentIndex + 1);
				else mainItem.startButtonPressed();
			}
		}
	}
} 
 
