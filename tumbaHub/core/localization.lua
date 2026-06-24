-- core/localization.lua
-- Mega.Localization table and GetText function

Mega.Localization = {
    CurrentLanguage = "en", -- Default
    Strings = {
        -- Loader Phases
        ["phase_network"] = { ru = "РУКОПОЖАТИЕ (СЕТЬ)", en = "HANDSHAKE (NETWORK)", uk = "РУКОСТИСКАННЯ (МЕРЕЖА)" },
        ["phase_core"] = { ru = "СБОРКА ОКРУЖЕНИЯ", en = "BUILDING CORE", uk = "ЗБІРКА ЯДРА" },
        ["phase_features"] = { ru = "СИНХРОНИЗАЦИЯ ФУНКЦИЙ", en = "SYNCING FEATURES", uk = "СИНХРОНІЗАЦІЯ ФУНКЦІЙ" },
        ["phase_ui"] = { ru = "ФИНАЛИЗАЦИЯ ИНТЕРФЕЙСА", en = "FINALIZING INTERFACE", uk = "ФІНАЛІЗАЦІЯ ІНТЕРФЕЙСУ" },
        ["loader_ready"] = { ru = "СИСТЕМА ГОТОВА к ЗАПУСКУ", en = "SYSTEM READY FOR LAUNCH", uk = "СИСТЕМА ГОТОВА ДО ЗАПУСКУ" },

        -- Notifications
        ["notify_enabled"] = { ru = "ВКЛЮЧЕНО", en = "ENABLED", uk = "УВІМКНЕНО" },
        ["notify_disabled"] = { ru = "ВЫКЛЮЧЕНО", en = "DISABLED", uk = "ВИМКНЕНО" },
        ["notify_spectate_start"] = { ru = "Наблюдение за %s включено", en = "Spectating %s enabled", uk = "Спостереження за %s увімкнено" },
        ["notify_spectate_stop"] = { ru = "Наблюдение отключено", en = "Spectating disabled", uk = "Спостереження вимкнено" },
        ["user_status_beloved"] = { ru = "❤️ Любимый пользователь", en = "❤️ Beloved User", uk = "❤️ Улюблений користувач" },
        ["notify_keybind_set"] = { ru = "%s привязана к %s", en = "%s bound to %s", uk = "%s прив'язано до %s" },
        ["notify_keybind_removed"] = { ru = "Бинд для %s удален", en = "Keybind for %s removed", uk = "Бінд для %s видалено" },
        ["section_settings_config"] = { ru = "💾 УПРАВЛЕНИЕ КОНФИГАМИ", en = "💾 CONFIG MANAGEMENT", uk = "💾 КЕРУВАННЯ КОНФІГАМИ" },
        ["textbox_config_name"] = { ru = "Имя конфига...", en = "Config name...", uk = "Ім'я конфігу..." },
        ["button_config_save"] = { ru = "💾 Сохранить конфиг", en = "💾 Save Config", uk = "💾 Зберегти конфіг" },
        ["dropdown_config_list"] = { ru = "Выберите конфиг", en = "Select Config", uk = "Виберіть конфіг" },
        ["button_config_load"] = { ru = "📂 Загрузить конфиг", en = "📂 Load Config", uk = "📂 Завантажити конфіг" },
        ["button_config_delete"] = { ru = "🗑️ Удалить конфиг", en = "🗑️ Delete Config", uk = "🗑️ Видалити конфіг" },
        ["button_config_refresh"] = { ru = "🔄 Обновить список", en = "🔄 Refresh List", uk = "🔄 Оновити список" },
        ["notify_config_saved"] = { ru = "Конфиг сохранен", en = "Config saved", uk = "Конфіг збережено" },
        ["notify_config_loaded"] = { ru = "Конфиг загружен", en = "Config loaded", uk = "Конфіг завантажено" },
        ["notify_config_not_found"] = { ru = "Конфиг не найден", en = "Config not found", uk = "Конфіг не знайдено" },
        ["notify_config_deleted"] = { ru = "🗑️ Конфиг удален", en = "🗑️ Config deleted", uk = "🗑️ Конфіг видалено" },
        ["notify_enter_name"] = { ru = "⚠️ Введите имя конфига!", en = "⚠️ Enter config name!", uk = "⚠️ Введіть ім'я конфігу!" },
        ["notify_theme_changed"] = { ru = "🎨 Цветовая тема изменена", en = "🎨 Theme color changed", uk = "🎨 Колірну тему змінено" },
        ["notify_chat_cleared"] = { ru = "🧹 Чат очищен", en = "🧹 Chat cleared", uk = "🧹 Чат очищено" },
        ["notify_reload"] = { ru = "🔄 Скрипт перезагружается...", en = "🔄 Script reloading...", uk = "🔄 Скрипт перезавантажується..." },
        ["notify_cleanup"] = { ru = "🗑️ Скрипт выгружен", en = "🗑️ Script unloaded", uk = "🗑️ Скрипт вивантажено" },

        -- Movement tab translations
        ["dropdown_speed_mode"] = { ru = "Метод Спидхака", en = "Speed Mode", uk = "Метод Спідхака" },
        ["dropdown_speed_move_mode"] = { ru = "Режим Движения", en = "Movement Mode", uk = "Режим Руху" },
        ["slider_speed_tp_frequency"] = { ru = "Частота телепорта (сек)", en = "TP Frequency (sec)", uk = "Частота телепорту (сек)" },
        ["slider_speed_pulse_length"] = { ru = "Длительность импульса", en = "Pulse Length", uk = "Тривалість імпульсу" },
        ["slider_speed_pulse_delay"] = { ru = "Задержка импульса", en = "Pulse Delay", uk = "Затримка імпульсу" },
        ["toggle_speed_wall_check"] = { ru = "Обход стен (Wall Check)", en = "Wall Check", uk = "Обхід стін (Wall Check)" },
        ["toggle_speed_autojump"] = { ru = "Авто-прыжок", en = "Auto Jump", uk = "Авто-стрибок" },
        ["toggle_speed_customjump"] = { ru = "Кастомный прыжок", en = "Custom Jump", uk = "Кастомний стрибок" },
        ["slider_speed_jumppower"] = { ru = "Сила прыжка", en = "Jump Power", uk = "Сила стрибка" },
        
        ["toggle_speed"] = { ru = "Спидхак (Speedhack)", en = "Speedhack", uk = "Спідхак" },
        ["slider_speed"] = { ru = "Скорость движения", en = "Movement Speed", uk = "Швидкість руху" },
        
        ["toggle_fly"] = { ru = "Полет (Fly)", en = "Fly", uk = "Політ" },
        ["slider_fly_speed"] = { ru = "Скорость полета", en = "Fly Speed", uk = "Швидкість польоту" },
        ["dropdown_fly_mode"] = { ru = "Режим полета", en = "Fly Mode", uk = "Режим польоту" },

        ["toggle_inf_jump"] = { ru = "Бесконечный прыжок", en = "Infinite Jump", uk = "Нескінченний стрибок" },
        ["toggle_nofall"] = { ru = "Нет урона от падения", en = "No Fall Damage", uk = "Ні ушкодженням від падіння" },
        ["toggle_noclip"] = { ru = "Прохождение сквозь стены (NoClip)", en = "NoClip", uk = "Проходження крізь стіни" },
        ["toggle_spider"] = { ru = "Паук (Spider)", en = "Spider", uk = "Павук" },
        ["dropdown_spider_mode"] = { ru = "Режим паука", en = "Spider Mode", uk = "Режим павука" },
        ["slider_spider_speed"] = { ru = "Скорость карабканья", en = "Climbing Speed", uk = "Швидкість карабкання" },
        ["toggle_spinbot"] = { ru = "Спинбот (SpinBot)", en = "SpinBot", uk = "Спінбот" },
        ["slider_spinspeed"] = { ru = "Скорость вращения", en = "Spin Speed", uk = "Швидкість обертання" },
        ["toggle_antiknockback"] = { ru = "Анти-отдача (AntiKB)", en = "Anti-Knockback", uk = "Анти-віддача" },
        ["slider_knockback_strength"] = { ru = "Сила отдачи (%)", en = "KB Strength (%)", uk = "Сила віддачі (%)" },

        -- Staff Detector
        ["toggle_staff_detector"] = { ru = "Staff Detector (Детектор админов)", en = "Staff Detector", uk = "Staff Detector (Детектор адмінів)" },
        ["tooltip_staff_detector"] = { ru = "Обнаруживает администраторов и модераторов в игре", en = "Detects people with a staff rank ingame", uk = "Виявляє адміністраторів та модераторів у грі" },
        ["dropdown_staff_detector_mode"] = { ru = "Действие при обнаружении", en = "Action Mode", uk = "Дія при виявленні" },
        ["textbox_staff_detector_group"] = { ru = "ID Группы", en = "Group ID", uk = "ID Групи" },
        ["textbox_staff_detector_role"] = { ru = "Мин. ранг в группе", en = "Min Group Rank", uk = "Мін. ранг в групі" },
        ["textbox_staff_detector_profile"] = { ru = "Конфиг для загрузки", en = "Config profile", uk = "Конфіг для завантаження" },
        ["textbox_staff_detector_users"] = { ru = "Черный список ID", en = "Blacklisted IDs", uk = "Чорний список ID" },

        -- Visuals
        ["toggle_nofog"] = { ru = "Без тумана (No Fog)", en = "No Fog", uk = "Без туману" },
        ["toggle_fullbright"] = { ru = "Яркость (FullBright)", en = "FullBright", uk = "Яскравість" },
        ["toggle_nightmode"] = { ru = "Ночной режим (Night Mode)", en = "Night Mode", uk = "Нічний режим" },
        ["toggle_removeshadows"] = { ru = "Удалить тени", en = "Remove Shadows", uk = "Видалити тіні" },
        ["toggle_gorilla_mode"] = { ru = "Режим Гориллы (3D)", en = "Gorilla Mode (3D)", uk = "Режим Горили (3D)" },

        -- Player list & Spectating
        ["button_stop_spectate"] = { ru = "❌ Сбросить камеру", en = "❌ Reset Camera", uk = "❌ Скинути камеру" },
        ["playerlist_name"] = { ru = "Имя", en = "Name", uk = "Ім'я" },
        ["playerlist_team"] = { ru = "Команда", en = "Team", uk = "Команда" },
        ["playerlist_hp"] = { ru = "Здоровье", en = "Health", uk = "Здоров'я" },
        ["playerlist_dist"] = { ru = "Дистанция", en = "Distance", uk = "Дистанція" },
        ["playerlist_team_none"] = { ru = "Нет", en = "None", uk = "Немає" },
        ["playerlist_hp_format"] = { ru = "%s HP", en = "%s HP", uk = "%s HP" },
        ["playerlist_hp_dead"] = { ru = "Мертв", en = "Dead", uk = "Мертвий" },
        ["playerlist_dist_format"] = { ru = "%s ст.", en = "%s st.", uk = "%s ст." },
        ["playerlist_dist_none"] = { ru = "—", en = "—", uk = "—" },

        -- Utilities
        ["button_clear_chat"] = { ru = "🧹 Очистить чат", en = "🧹 Clear Chat", uk = "🧹 Очистити чат" },
        ["button_reload_script"] = { ru = "🔄 Перезагрузить GUI", en = "🔄 Reload GUI", uk = "🔄 Перезавантажити GUI" },

        -- Aim Assist
        ["tab_aim"] = { ru = "AIM", en = "AIM", es = "PUNTERÍA", pt = "MIRA", ko = "조준", ja = "狙い", uk = "AIM" },
        ["section_aim_main"] = { ru = "🎯 ОСНОВНЫЕ НАСТРОЙКИ AIM", en = "🎯 MAIN AIM SETTINGS", es = "🎯 CONFIGURACIONES PRINCIPALES DE PUNTERÍA", pt = "🎯 CONFIGURAÇÕES PRINCIPAIS DE MIRA", ko = "🎯 주요 조준 설정", ja = "🎯 メインエイム設定", uk = "🎯 ОСНОВНІ НАЛАШТУВАННЯ AIM" },
        ["toggle_aim"] = { ru = "Включить Aim Assist", en = "Enable Aim Assist", es = "Habilitar Ayuda de Puntería", pt = "Ativar Assistência de Mira", ko = "조준 보조 활성화", ja = "エイムアシスト有効", uk = "Увімкнути Aim Assist" },
        ["section_aim_settings"] = { ru = "⚙️ НАСТРОЙКИ ПАРАМЕТРОВ", en = "⚙️ PARAMETER SETTINGS", es = "⚙️ CONFIGURACIONES DE PARÁMETROS", pt = "⚙️ CONFIGURAÇÕES DE PARÂMETROS", ko = "⚙️ 매개변수 설정", ja = "⚙️ パラメータ設定", uk = "⚙️ НАЛАШТУВАННЯ ПАРАМЕТРІВ" },
        ["toggle_aim_prediction"] = { ru = "Предсказание движения", en = "Movement Prediction", es = "Predicción de Movimiento", pt = "Previsão de Movimento", ko = "움직임 예측", ja = "移動予測", uk = "Передбачення руху" },
        ["toggle_aim_toggle_mode"] = { ru = "Режим переключения (Toggle)", en = "Toggle Mode", es = "Modo de alternancia (Toggle)", pt = "Modo de alternância (Toggle)", ko = "전환 모드 (Toggle)", ja = "切り替えモード (Toggle)", uk = "Режим перемикання (Toggle)" },
        ["slider_aim_range"] = { ru = "Дальность", en = "Range", es = "Rango", pt = "Alcance", ko = "범위", ja = "範囲", uk = "Дальність" },
        ["slider_aim_speed"] = { ru = "Скорость аима (Aim speed)", en = "Aim speed", uk = "Швидкість аїму (Aim speed)" },
        ["dropdown_aim_target"] = { ru = "Цель прицела", en = "Aim Target", es = "Objetivo de Puntería", pt = "Alvo da Mira", ko = "조준 목표", ja = "エイムターゲット", uk = "Ціль прицілу" },
        ["dropdown_aim_target_head"] = { ru = "Голова", en = "Head", es = "Cabeza", pt = "Cabeça", ko = "머리", ja = "頭", uk = "Голова" },
        ["dropdown_aim_target_upper"] = { ru = "Верхняя часть тела", en = "UpperTorso", es = "Torso Superior", pt = "Torso Superior", ko = "상체", ja = "上半身", uk = "Верхня частина тіла" },
        ["dropdown_aim_target_lower"] = { ru = "Нижняя часть тела", en = "LowerTorso", es = "Torso Inferior", pt = "Torso Inferior", ko = "하체", ja = "下半身", uk = "Нижня частина тіла" },
        ["dropdown_aim_target_root"] = { ru = "Центр", en = "HumanoidRootPart", es = "ParteRaízHumanoide", pt = "ParteRaizHumanoide", ko = "휴머노이드 루트 파트", ja = "ヒューマノイドルートパート", uk = "Центр" },
        ["section_aim_key"] = { ru = "🎯 КЛАВИША AIM", en = "🎯 AIM KEY", es = "🎯 TECLA DE PUNTERÍA", pt = "🎯 TECLA DE MIRA", ko = "🎯 조준 키", ja = "🎯 エイムキー", uk = "🎯 КЛАВІША AIM" },
        ["keybind_aim"] = { ru = "🔑 Изменить клавишу Aim", en = "🔑 Change Aim Key", es = "🔑 Cambiar Tecla de Puntería", pt = "🔑 Alterar Tecla de Mira", ko = "🔑 조준 키 변경", ja = "🔑 エイムキー変更", uk = "🔑 Змінити клавішу Aim" },

        -- AI Chat
        ["ai_chat_placeholder"] = { ru = "Задай любой вопрос ИИ-ассистенту...", en = "Ask any question to AI Assistant...", uk = "Запитай що завгодно у ШІ-помічника..." },
        ["ai_chat_send"] = { ru = "Отправить", en = "Send", uk = "Надіслати" },

        -- Settings
        ["dropdown_language"] = { ru = "Язык интерфейса", en = "Interface Language", uk = "Мова інтерфейсу" },
        ["dropdown_base_theme"] = { ru = "Базовая тема", en = "Base Theme", uk = "Базова тема" },
        ["button_change_theme"] = { ru = "Цветовая гамма", en = "Color Scheme", uk = "Колірна гама" },
        ["slider_menu_transparency"] = { ru = "Прозрачность меню", en = "Menu Transparency", uk = "Прозорість меню" },
        ["keybind_menu"] = { ru = "Клавиша открытия", en = "Menu Keybind", uk = "Клавіша відкриття" },
        ["toggle_show_notifications"] = { ru = "Показывать уведомления", en = "Show Notifications", uk = "Показувати сповіщення" },
        ["button_cleanup"] = { ru = "🗑️ Полная выгрузка чита", en = "🗑️ Complete Uninstall", uk = "🗑️ Повне вивантаження читу" },

        -- Tabs
        ["tab_home"] = { ru = "ГЛАВНАЯ", en = "HOME", uk = "ГОЛОВНА" },
        ["tab_esp"] = { ru = "ESP", en = "ESP", uk = "ESP" },
        ["tab_player"] = { ru = "ИГРОК", en = "PLAYER", uk = "ГРАВЕЦЬ" },
        ["tab_visuals"] = { ru = "ВИЗУАЛЫ", en = "VISUALS", uk = "ВІЗУАЛИ" },
        ["tab_users"] = { ru = "ИГРОКИ", en = "PLAYERS", uk = "ГРАВЦІ" },
        ["tab_utils"] = { ru = "УТИЛИТЫ", en = "UTILITIES", uk = "УТИЛІТИ" },
        ["tab_settings"] = { ru = "НАСТРОЙКИ", en = "SETTINGS", uk = "НАЛАШТУВАННЯ" },
        ["tab_ai_chat"] = { ru = "AI ЧАТ", en = "AI CHAT", uk = "AI ЧАТ" },

        -- General strings
        ["title_bar"] = { ru = "TUMBA HUB GAMES v%s", en = "TUMBA HUB GAMES v%s", uk = "TUMBA HUB GAMES v%s" },
        ["title_bar_with_tab"] = { ru = "TUMBA HUB GAMES | %s", en = "TUMBA HUB GAMES | %s", uk = "TUMBA HUB GAMES | %s" },
        ["section_updates_list"] = { ru = "📋 СПИСОК ИЗМЕНЕНИЙ", en = "📋 CHANGELOG", uk = "📋 СПИСОК ЗМІН" },
        ["update_text_v5_1"] = { 
            ru = "Tumba Hub Games v1.0.0:\n• Адаптация под не-PvP игры;\n• Очистка от Bedwars специфики;\n• Модульная архитектура с загрузчиком Place ID.", 
            en = "Tumba Hub Games v1.0.0:\n• Adaptation for non-PvP games;\n• Cleaned from Bedwars specific code;\n• Modular Place ID loader.", 
            uk = "Tumba Hub Games v1.0.0:\n• Адаптація під не-PvP ігри;\n• Очищення від Bedwars специфіки;\n• Модульна архітектура з завантажувачем Place ID."
        },
        ["section_status"] = { ru = "⚡ СОСТОЯНИЕ СИСТЕМЫ", en = "⚡ SYSTEM STATUS", uk = "⚡ СТАН СИСТЕМИ" },
        ["toggle_autosave"] = { ru = "Автосохранение конфигов", en = "Autosave Configs", uk = "Автозбереження конфігів" },
        ["toggle_perf_mode"] = { ru = "Режим оптимизации (FPS)", en = "Optimization Mode (FPS)", uk = "Режим оптимізації (FPS)" },
        ["toggle_status_indicator"] = { ru = "Статус-лист активных функций", en = "Active Features Status List", uk = "Статус-лист активних функцій" },
        ["section_quick_access"] = { ru = "🚀 БЫСТРЫЙ ДОСТУП", en = "🚀 QUICK ACCESS", uk = "🚀 ШВИДКИЙ ДОСТУП" },
        ["button_esp_toggle"] = { ru = "Переключить Player ESP", en = "Toggle Player ESP", uk = "Перемикнути Player ESP" },
        ["button_speed_toggle"] = { ru = "Переключить Speedhack", en = "Toggle Speedhack", uk = "Перемикнути Speedhack" },
        ["section_stats"] = { ru = "📊 ИГРОВАЯ СТАТИСТИКА", en = "📊 GAME STATS", uk = "📊 ІГРОВА СТАТИСТИКА" },
        ["stats_label"] = { 
            ru = "Убито игроков: %s\nСмертей: %s\nВремя в игре: %s мин.", 
            en = "Players killed: %s\nDeaths: %s\nTime played: %s min.", 
            uk = "Вбито гравців: %s\nСмертей: %s\nЧас у грі: %s хв." 
        },

        -- Language selections
        ["language_english"] = { ru = "English", en = "English", uk = "English" },
        ["language_russian"] = { ru = "Русский", en = "Русский", uk = "Русский" },
        ["language_ukrainian"] = { ru = "Українська", en = "Українська", uk = "Українська" },
        ["language_spanish"] = { ru = "Español", en = "Español", uk = "Español" },
        ["language_portuguese"] = { ru = "Português", en = "Português", uk = "Português" },
        ["language_korean"] = { ru = "한국어", en = "한국어", uk = "한국어" },
        ["language_japanese"] = { ru = "日本語", en = "日本語", uk = "日本語" },

        -- ESP
        ["section_esp_main"] = { ru = "PLAYER ESP", en = "PLAYER ESP", uk = "PLAYER ESP" },
        ["toggle_esp"] = { ru = "Включить ESP", en = "Enable ESP", uk = "Увімкнути ESP" },
        ["section_esp_visuals"] = { ru = "👁️ ОТРИСОВКА ЭЛЕМЕНТОВ", en = "👁️ RENDER OPTIONS", uk = "👁️ ВІДОБРАЖЕННЯ ЕЛЕМЕНТІВ" },
        ["toggle_esp_boxes"] = { ru = "2D Боксы", en = "2D Boxes", uk = "2D Бокси" },
        ["toggle_esp_outline"] = { ru = "Обводка боксов", en = "Box Outline", uk = "Обведення боксів" },
        ["toggle_esp_names"] = { ru = "Никнеймы игроков", en = "Player Nicknames", uk = "Нікнейми гравців" },
        ["toggle_esp_health"] = { ru = "Полоска здоровья", en = "Health Bar", uk = "Смужка здоров'я" },
        ["toggle_esp_health_text"] = { ru = "Текст здоровья (HP)", en = "Health Text (HP)", uk = "Текст здоров'я (HP)" },
        ["toggle_esp_tool"] = { ru = "Предмет в руках", en = "Held Item", uk = "Предмет у руках" },
        ["toggle_esp_distance"] = { ru = "Дистанция до игрока", en = "Distance to Player", uk = "Дистанція до гравця" },
        ["toggle_esp_skeleton"] = { ru = "Скелет персонажа", en = "Player Skeleton", uk = "Скелет персонажа" },
        ["toggle_esp_chams"] = { ru = "Цветной силуэт (Chams)", en = "Chams Glow", uk = "Кольоровий силует (Chams)" },
        ["toggle_esp_tracers"] = { ru = "Линии следования (Tracers)", en = "Tracers", uk = "Лінії слідування (Tracers)" },
        ["dropdown_tracer_origin"] = { ru = "Начало трейсеров", en = "Tracer Origin", uk = "Початок трейсерів" },
        ["toggle_esp_team"] = { ru = "Показывать свою команду", en = "Show Teammates", uk = "Показувати свою команду" },
        ["slider_esp_max_dist"] = { ru = "Макс. дистанция отрисовки", en = "Max Render Distance", uk = "Макс. дистанція відображення" },
        ["section_esp_colors"] = { ru = "🎨 НАСТРОЙКА ЦВЕТОВ", en = "🎨 COLOR OPTIONS", uk = "🎨 НАЛАШТУВАННЯ КОЛЬОРІВ" },
        ["toggle_use_team_colors"] = { ru = "Использовать цвета команд", en = "Use Team Colors", uk = "Використовувати кольори команд" },
        ["button_team_color"] = { ru = "Цвет союзников", en = "Teammate Color", uk = "Колір союзників" },
        ["button_enemy_color"] = { ru = "Цвет врагов", en = "Enemy Color", uk = "Колір ворогів" },

        -- Player / Movement tab UI
        ["section_player_movement"] = { ru = "🏃 ПЕРЕМЕЩЕНИЕ ПЕРСОНАЖА", en = "🏃 CHARACTER MOVEMENT", uk = "🏃 ПЕРЕМІЩЕННЯ ПЕРСОНАЖА" },
        ["section_player_defense"] = { ru = "🛡️ ЗАЩИТА И УТИЛИТЫ", en = "🛡️ DEFENSE & UTILITIES", uk = "🛡️ ЗАХИСТ ТА УТИЛІТИ" },
        ["section_utils_fun"] = { ru = "🎭 РАЗВЛЕЧЕНИЯ И ФАН", en = "🎭 FUN & MISC", uk = "🎭 РОЗВАГИ ТА ФАН" },

        -- UI builders helper
        ["slider_label"] = { ru = "%s: %s", en = "%s: %s", uk = "%s: %s" },
        ["dropdown_label"] = { ru = "%s:", en = "%s:", uk = "%s:" },
        ["keybind_none"] = { ru = "None", en = "None", uk = "Немає" },
        ["keybind_listening"] = { ru = "...", en = "...", uk = "..." },
        ["section_settings_appearance"] = { ru = "🎨 ВНЕШНИЙ ВИД МЕНЮ", en = "🎨 MENU APPEARANCE", uk = "🎨 ЗОВНІШНІЙ ВИГЛЯД МЕНЮ" }
    },
    
    GetText = function(key, ...)
        local current = Mega.Localization.CurrentLanguage
        local tbl = Mega.Localization.Strings[key]
        local text = key
        
        if tbl then
            text = tbl[current] or tbl["en"] or key
        end
        
        if ... then
            local success, formatted = pcall(string.format, text, ...)
            if success then
                return formatted
            end
        end
        return text
    end
}

Mega.GetText = Mega.Localization.GetText

function Mega.SaveLanguage(lang)
    if writefile then
        if not isfolder("tumbaHub") then pcall(makefolder, "tumbaHub") end
        if not isfolder("tumbaHub/configs") then pcall(makefolder, "tumbaHub/configs") end
        pcall(writefile, "tumbaHub/configs/Language.txt", lang)
    end
end

function Mega.LoadLanguage()
    if readfile and isfile then
        if isfile("tumbaHub/configs/Language.txt") then
            local success, lang = pcall(readfile, "tumbaHub/configs/Language.txt")
            if success and lang then return lang end
        elseif isfile("TumbaLanguage.txt") then
            local success, lang = pcall(readfile, "TumbaLanguage.txt")
            if success and lang then 
                Mega.SaveLanguage(lang)
                return lang 
            end
        end
    end
    return "en"
end

function Mega.HasSavedLanguage()
    return (isfile and (isfile("tumbaHub/configs/Language.txt") or isfile("TumbaLanguage.txt")))
end

-- Load saved language on startup
Mega.Localization.CurrentLanguage = Mega.LoadLanguage()

