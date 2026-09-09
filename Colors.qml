pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
  FileView {
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

  property alias accentColor: colors.accentColor
  property alias bgColor: colors.bgColor
  property alias primaryColor: colors.primaryColor
}
