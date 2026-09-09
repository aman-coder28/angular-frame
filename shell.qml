import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "."

ShellRoot {
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
		height: 7

		color: Colors.bgColor

		Rectangle {
		  id: topBar

			width: 1366
			height: 7
			color: Colors.bgColor

			border.color: Colors.accentColor
    	border.width: 8
		}
	}

	Diagonal {
	  width: 150
	  height: 150
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

		width: 253
		height: 736

		implicitWidth: 289
		implicitHeight: 736

		color: Colors.bgColor

	  AngularFrame {
	    id: leftFrame
	    // anchors.fill: parent
	  }
	}

	Clock {}
}
