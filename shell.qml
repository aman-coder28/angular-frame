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

		AngularFrame {
			id: angularFrame
		  width: 300
		  height: 734
		  cornerCut: 70
		  borderColor: colors.accentColor
		  bgColor: colors.bgColor
		  cutTopLeft: true
		  cutBottomRight: false

		  // your clock / weather / system stats content goes here,
		  // just anchor it inside with margins so it doesn't overlap the cut corner
		}
	}
}
