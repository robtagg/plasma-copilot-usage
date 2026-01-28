import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property int remaining: 0
    property int entitlement: 0
    property real percentRemaining: 0
    property string resetDate: ""
    property bool loading: false
    property string errorMessage: ""

    preferredRepresentation: compactRepresentation

    toolTipMainText: "GitHub Copilot Usage"
    toolTipSubText: {
        if (errorMessage) return errorMessage
        if (entitlement === 0) return "Loading..."
        return remaining + "/" + entitlement + " premium requests remaining (" + percentRemaining.toFixed(1) + "%)\nResets: " + resetDate
    }

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            var exitCode = data["exit code"]

            disconnectSource(source)
            loading = false

            if (exitCode !== 0) {
                if (stderr.indexOf("gh auth login") !== -1) {
                    errorMessage = "gh not authenticated"
                } else {
                    errorMessage = "gh error"
                }
                return
            }

            try {
                var json = JSON.parse(stdout)
                var premium = json.quota_snapshots?.premium_interactions
                if (premium) {
                    remaining = premium.remaining || 0
                    entitlement = premium.entitlement || 0
                    percentRemaining = premium.percent_remaining || 0
                }
                if (json.quota_reset_date) {
                    var d = new Date(json.quota_reset_date)
                    resetDate = d.toLocaleDateString(Qt.locale())
                } else {
                    resetDate = ""
                }
                errorMessage = ""
            } catch (e) {
                errorMessage = "Parse error"
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: Plasmoid.configuration.refreshInterval * 60000
        running: true
        repeat: true
        onTriggered: fetchUsage()
    }

    Component.onCompleted: {
        fetchUsage()
    }

    function fetchUsage() {
        loading = true
        errorMessage = ""
        executable.connectSource("gh api /copilot_internal/user 2>&1")
    }

    compactRepresentation: MouseArea {
        id: compactRoot

        Layout.fillWidth: false
        Layout.fillHeight: false
        Layout.minimumWidth: Kirigami.Units.iconSizes.medium
        Layout.minimumHeight: Kirigami.Units.iconSizes.medium
        Layout.maximumWidth: Kirigami.Units.iconSizes.medium
        Layout.maximumHeight: Kirigami.Units.iconSizes.medium

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onClicked: function(mouse) {
            if (mouse.button === Qt.MiddleButton) {
                fetchUsage()
            } else {
                root.expanded = !root.expanded
            }
        }

        Kirigami.Icon {
            anchors.fill: parent
            source: Qt.resolvedUrl("../images/copilot-icon-panel.svg")
            opacity: root.loading ? 0.5 : 1.0
        }
    }

    fullRepresentation: ColumnLayout {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 15
        Layout.preferredHeight: Kirigami.Units.gridUnit * 10
        spacing: Kirigami.Units.largeSpacing

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignHCenter
            text: "GitHub Copilot Usage"
            font.bold: true
            font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.2
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing
            visible: root.entitlement > 0

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Premium Interactions"
                opacity: 0.8
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.remaining + " / " + root.entitlement
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 2
                font.bold: true
                color: {
                    if (root.percentRemaining < 10) return Kirigami.Theme.negativeTextColor
                    if (root.percentRemaining < 25) return Kirigami.Theme.neutralTextColor
                    return Kirigami.Theme.positiveTextColor
                }
            }

            PlasmaComponents.ProgressBar {
                Layout.fillWidth: true
                from: 0
                to: 100
                value: root.percentRemaining
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.percentRemaining.toFixed(1) + "% remaining"
                opacity: 0.8
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Resets: " + root.resetDate
                opacity: 0.6
                visible: root.resetDate !== ""
            }
        }

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: root.errorMessage || (root.entitlement === 0 && !root.loading ? "Unable to fetch data" : "")
            visible: root.errorMessage !== "" || (root.entitlement === 0 && !root.loading)
            color: Kirigami.Theme.negativeTextColor
        }

        Item { Layout.fillHeight: true }

        PlasmaComponents.Button {
            Layout.alignment: Qt.AlignHCenter
            text: root.loading ? "Refreshing..." : "Refresh"
            icon.name: "view-refresh"
            enabled: !root.loading
            onClicked: fetchUsage()
        }
    }
}
