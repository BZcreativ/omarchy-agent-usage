import QtQuick
import Quickshell

// Feeds the omarchy.agents panel by running the Kimi and Z.ai collectors on a
// timer. The collectors are display-agnostic: they write
// ~/.local/state/omarchy/agents/usage/{kimi,zai}.json, the record directory
// the agents panel watches, so no QML integration with the panel is needed
// and records appear/disappear with this service.

Item {
  id: root

  // Directory containing this file; the collectors ship inside the plugin.
  readonly property string pluginDir: Qt.resolvedUrl(".").toString().replace(/^file:\/\//, "")

  function runCollectors() {
    if (!kimiProcess.running) kimiProcess.running = true
    if (!zaiProcess.running) zaiProcess.running = true
  }

  Process {
    id: kimiProcess
    command: [root.pluginDir + "/bin/omarchy-agent-usage-kimi"]
  }

  Process {
    id: zaiProcess
    command: [root.pluginDir + "/bin/omarchy-agent-usage-zai"]
  }

  Timer {
    interval: 5 * 60 * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.runCollectors()
  }
}
