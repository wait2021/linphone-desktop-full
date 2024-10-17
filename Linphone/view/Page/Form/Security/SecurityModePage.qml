import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import Linphone

LoginLayout {
	id: mainItem
	signal modeSelected(int index)

	titleContent: RowLayout {
		Image {
			fillMode: Image.PreserveAspectFit
			source: AppIcons.profile
		}
		ColumnLayout {
			Text {
				text: qsTr("Choisir votre mode")
				font {
					pixelSize: 36 * mainWindow.dp
					weight: 800 * mainWindow.dp
				}
			}
			Text {
				text: qsTr("Vous pourrez changer de mode plus tard.")
				font.bold: true
				font {
					pixelSize: 14 * mainWindow.dp
					weight: 400 * mainWindow.dp
				}
			}
		}
	}

	centerContent: ColumnLayout {
		spacing: 80 * mainWindow.dp
		RowLayout {
			id: radioButtonsLayout
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignHCenter
			spacing: 70 * mainWindow.dp
			Repeater {
				model: [
					{checked: true, title: qsTr("Chiffrement de bout en bout"), text: qsTr("Ce mode vous garanti la confidentialité de tous vos échanges. Notre technologie de chiffrement de bout en bout assure un niveau de sécurité maximal pour tous vos échanges."), imgUrl: AppIcons.chiffrement, color: DefaultStyle.info_500_main},
					{checked: false, title: qsTr("Interoperable"), text: qsTr("Ce mode vous permet de profiter de toute les fonctionnalités de Linphone, toute en restant interopérable avec n’importe qu’elle autre service SIP."), imgUrl: AppIcons.interoperable, color: DefaultStyle.main1_500_main}
				]
				SecurityRadioButton {
					title: modelData.title
					contentText: modelData.text
					imgUrl: modelData.imgUrl
					checked: modelData.checked
					color: modelData. color
					onCheckedChanged: {
						if (checked) continueButton.selectedIndex = index
					}
				}
			}
		}
		Button {
			id: continueButton
			property int selectedIndex: 0
			Layout.alignment: Qt.AlignHCenter
			topPadding: 11 * mainWindow.dp
			bottomPadding: 11 * mainWindow.dp
			leftPadding: 100 * mainWindow.dp
			rightPadding: 100 * mainWindow.dp
			text: qsTr("Continuer")
			onClicked: mainItem.modeSelected(selectedIndex)
		}
		Item {
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}
}
 
