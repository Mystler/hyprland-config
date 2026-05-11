-- Custom Alphas
hl.window_rule({ opacity = 0.8, match = { class = "org.kde.kate" } })
hl.window_rule({ opacity = 0.8, match = { class = "org.kde.dolphin" } })
hl.window_rule({ opacity = 0.8, match = { class = "org.kde.kdeconnect.app" } })
hl.window_rule({ opacity = 0.8, match = { class = "blueman-manager" } })

-- Float
hl.window_rule({ float = true, match = { class = "blueman-manager" } })
