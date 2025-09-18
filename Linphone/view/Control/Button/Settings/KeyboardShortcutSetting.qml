import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Linphone

RowLayout{
	id: mainItem
    spacing : Math.round(20 * DefaultStyle.dp)
	property string titleText
	property string keySequence

	Text{
		text: titleText
		font: Typography.p2l
		wrapMode: Text.WordWrap
		color: DefaultStyle.main2_600
		Layout.fillWidth: true
	}

	KeyboardShortcutInput{
		keySequence: keySequence
}
}
