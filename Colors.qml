pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  property alias accentColor: colors.accentColor
  property alias bgColor: colors.bgColor
  property alias primaryColor: colors.primaryColor

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
}
