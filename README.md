# Achiever

Achiever is a lightweight World of Warcraft addon that enhances the experience of earning achievements with custom **visual toasts** and **sound effects**.

## ✨ Features

- 🎉 Custom achievement toast popup
- 🔊 Randomized sounds when achievements are earned
- 🏆 Special sounds for rare achievements
- 🕹️ Slash commands for testing, toggling, and debugging
- 📆 Peer-to-Peer Version Control

## 🔧 Commands

| Command              | Description                              |
| -------------------- | ---------------------------------------- |
| `/achievertest <id>` | Test a specific achievement by ID        |
| `/achievertoggle`    | Toggle toast notifications on or off     |
| `/achieverstatus`    | Check if toast notifications are enabled |
| `/achiever version`  | Broadcasts your version to other players |
| `/achiever`          | Show help info                           |

## 🔍 Recognized Rare Achievements

Rare achievement IDs are defined manually in `Achiever.RareAchievements`.

```lua
Achiever.RareAchievements = {
  [12345] = true,
  [67890] = true,
  -- Add more here
}
```
