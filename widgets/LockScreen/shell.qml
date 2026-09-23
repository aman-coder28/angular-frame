import Quickshell
import Quickshell.Wayland

ShellRoot {
  LockContext {
    id: lockContext

    onUnlocked: {
      lock.locked = false;

      Qt.quit();
    }
  }

  WlSessionLock {
    id: lock

    locked: true

    WlSessionLockSurface {
      // UnComment this to take screenshot of the loginscreen
      // PanelWindow {
      //   WlrLayershell.layer: WlrLayershell.Overlay
      //   WlrLayershell.exclusionMode: ExclusionMode.Ignore

      //   anchors {
      //     top: true
      //     bottom: true
      //     left: true
      //     right: true
      //   }

      LockSurface {
        anchors.fill: parent
        context: lockContext
      }
    }
  }
}
