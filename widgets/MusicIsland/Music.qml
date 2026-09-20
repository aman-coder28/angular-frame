pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
  property bool playing: MprisPlaybackState.Playing
  property bool paused: MprisPlaybackState.Paused
  property bool stopped: MprisPlaybackState.Stopped
  readonly property var activePlayer: {
    const players = Mpris.players.values;

    for (let i = 0; i < players.length; ++i) {
      if (players[i].isPlaying)
        return players[i];
    }

    return players.length > 0 ? players[0] : null;
  }
  property string trackTitle: Music.activePlayer?.trackTitle ?? ""
  property string albumArt: Music.activePlayer?.trackArtUrl ?? ""
  property string trackArtist: Music.activePlayer?.trackArtist ?? ""
  property real position: activePlayer?.position ?? 0
  property real length: activePlayer?.length ?? 0

  function formatTime(seconds) {
    if (!isFinite(seconds) || seconds < 0)
      seconds = 0;

    const total = Math.floor(seconds);
    const mins = Math.floor(total / 60);
    const secs = total % 60;
    return mins + ":" + (secs < 10 ? "0" + secs : secs);
  }

  function shortenStrings(text: string): string {
    var cleaned = text.replace(/\s*\((?:Official\s*)?(?:Music\s*)?Video\)/gi, "").replace(/\s*\((?:Audio|Lyrics?)\)/gi, "");

    if (cleaned.length >= 31) {
      return cleaned.substring(0, 31) + "...";
    }

    return cleaned;
  }

  function seekTo(seconds) {
    if (!activePlayer)
      return;

    const player = activePlayer;

    if (!player.canSeek || !(player.length > 0))
      return;

    const target = Math.max(0, Math.min(seconds, player.length));

    if (player.positionSupported)
      player.position = target;
    else
      player.seek(target - player.position);
  }

  function cycleLoop() {
    if (!activePlayer || !activePlayer.loopSupported)
      return;

    const p = activePlayer;

    if (p.loopState === MprisLoopState.None)
      p.loopState = MprisLoopState.Playlist;
    else if (p.loopState === MprisLoopState.Playlist)
      p.loopState = MprisLoopState.Track;
    else
      p.loopState = MprisLoopState.None;
  }

  FrameAnimation {
    running: Music.activePlayer?.playbackState == MprisPlaybackState.Playing

    onTriggered: Music.activePlayer?.positionChanged()
  }
}
