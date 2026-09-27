#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

install -m 0755 bin/omarchy-agent-usage-kimi bin/omarchy-agent-usage-zai ~/.local/bin/
install -m 0644 systemd/omarchy-agent-usage-extra.service systemd/omarchy-agent-usage-extra.timer ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable --now omarchy-agent-usage-extra.timer
systemctl --user start omarchy-agent-usage-extra.service

cat <<'EOF'
Installed. Now add credentials:

  mkdir -p ~/.config/omarchy/agents
  echo '{"apiKey": "sk-...", "region": "global"}' > ~/.config/omarchy/agents/kimi.json
  echo '{"apiKey": "..."}' > ~/.config/omarchy/agents/zai.json

Then: omarchy-agent-usage-kimi --force && omarchy-agent-usage-zai --force && omarchy-shell omarchy.agents refresh
EOF
