import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
	FileView {
    id: noctaliaColors
    path: Quickshell.env("HOME") + "/.config/quickshell/noctalia-colors.json"
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()

    JsonAdapter {
    	id: colors
      property string accentColor
      property string bgColor
      property string primaryColor
    }
  }

	PanelWindow {
	  anchors {
		  top: true
		  left: true
		}

		margins {
		  top: 0
		  left: 0
		}

	  WlrLayershell.layer: WlrLayershell.Background
	  WlrLayershell.namespace: "material-frame"

		width: 1366
		height: 8

		color: colors.bgColor

		Rectangle {
		  id: topBar

			width: 1366
			height: 8
			color: colors.bgColor

			border.color: colors.accentColor
    	border.width: 8
		}
	}


	PanelWindow {
	  id: root

	  WlrLayershell.layer: WlrLayershell.Background
	  WlrLayershell.namespace: "material-frame"

	  anchors {
	    top: true
	    left: true
	  }

		margins {
      top: 0
      left: 0
		}

		width: 460
		height: 734

		implicitWidth: 300
		implicitHeight: 734

		color: colors.bgColor

	  AngularFrame {
	    id: leftFrame
	    anchors.fill: parent
	  }
	}

	Clock {}
}
