import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland


ShellRoot {
	PanelWindow {
	  id: root

	  WlrLayershell.layer: WlrLayershell.Background
	  WlrLayershell.namespace: "material-frame"

	  anchors {
	    top: true
	    right: true
	  }

		FileView {
	    id: noctaliaColors
	    path: Quickshell.env("HOME") + "/.config/quickshell/noctalia-colors.json"
	    watchChanges: true
	    onFileChanged: reload()
	    onAdapterUpdated: writeAdapter()

	    JsonAdapter {
	    	id: colors
	      property string accentColor: "#903B3B"
	      property string bgColor: "#ecd1c7"
	      property string primaryColor: "#090F1B"
	    }
	  }

		margins {
      top: 0
      left: 0
    }

	  implicitWidth: 300
	  implicitHeight: 734
	  color: colors.bgColor

		Canvas {
      id: clockFace
      anchors.fill: parent
      anchors.margins: 0
      antialiasing: true
		}
	}
}
