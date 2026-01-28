import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root

    property alias cfg_refreshInterval: refreshSpinBox.value

    Kirigami.FormLayout {
        anchors.fill: parent

        QQC2.SpinBox {
            id: refreshSpinBox
            Kirigami.FormData.label: "Refresh interval (minutes):"
            from: 1
            to: 60
            value: 5
        }

        QQC2.Label {
            text: "Uses 'gh' CLI for authentication.\nMake sure you're logged in with: gh auth login"
            wrapMode: Text.WordWrap
            opacity: 0.7
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
        }
    }
}
