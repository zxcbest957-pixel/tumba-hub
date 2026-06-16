-- features/ai_chat.lua
-- Universal AI assistant chatbot client with cleaned manual and persona

local Features = Mega.Features
local AIChat = {
    History = {},
    IsProcessing = false
}
Features.AIChat = AIChat

local HttpService = Mega.Services.HttpService

-- Helper function for HTTP requests (Exploit-friendly)
local function httpRequest(options)
    local requestFunc = (syn and syn.request) or (http and http.request) or request or http_request
    if requestFunc then
        return requestFunc({
            Url = options.Url,
            Method = options.Method,
            Headers = options.Headers,
            Body = options.Body
        })
    else
        return HttpService:RequestAsync({
            Url = options.Url,
            Method = options.Method,
            Headers = options.Headers,
            Body = options.Body
        })
    end
end

local API_CONFIG = {
    URL = "https://tubmahub-server.onrender.com/api/ai_chat_proxy"
}

local PERSONA = [[
Ты — Tumba AI Версия 2.0, ИИ-ассистент TumbaHub Games, созданный для помощи пользователям в универсальных не-PvP играх. 

--- ТВОЙ ХАРАКТЕР ---
- Ты — веселый и позитивный эксперт. Помогаешь юзерам быстро и по делу.
- Твои создатели: Bacon и @kreml1nAgent.
- Если юзер просит контакты, дай Дискорд: https://discord.gg/G7DYpgsdSE
- Отвечай в дружелюбном геймерском стиле. Полностью исключены любые обсуждения PvP, кроватей, Bedwars, киллауры или аимбота, так как эти функции отсутствуют в этой универсальной версии.

--- ТВОИ ПРАВИЛА ---
1. Ты знаешь всё о механике универсальных функций (см. БАЗУ ЗНАНИЙ) и объясняешь их с точки зрения пользы и геймплея.
2. Если тебя спрашивают "Кто ты?", ты — ИИ-ассистент TumbaHub Games.
]]

local TECHNICAL_MANUAL = [[
# TUMBAHUB GAMES: THE ULTIMATE MANUAL v1.0.0 (UNIVERSAL NON-PVP EDITION)

Вот полная база знаний по всем фичам TumbaHub Games, предназначенным для не-PvP игр:

## 1. ОБЩАЯ ИНФОРМАЦИЯ И СИСТЕМА
- TumbaHub Games — это универсальный чит, который загружается через нашу систему.
- Меню легко открывается на правый Shift (RightShift).
- Скрипт сохраняет настройки автоматически (Autosave). Также есть поддержка Place ID лоадера, который загружает специфические файлы под каждую игру.

## 2. ВИЗУАЛЫ И ESP (VISUALS & PLAYER ESP)
- **Player ESP:** Подсвечивает игроков сквозь стены. Отрисовывает 2D боксы, обводку, никнеймы, линии направления (Tracers), скелеты, хитпоинты (полоска и текст) и предмет в руках.
- **Gorilla Chams:** Смешной визуальный режим, который превращает других игроков в 3D-модели горилл с плавными анимациями бега, прыжка и бездействия. Хитбоксы остаются оригинальными.
- **Атмосфера:** Включает функции No Fog (убирает туман), FullBright (яркость), Night Mode (ночь) и Remove Shadows (отключает тени).

## 3. ПЕРЕДВИЖЕНИЕ (MOVEMENT EXPLOITS)
- **Speedhack:** Множество режимов настройки скорости: Velocity (физическая скорость), Impulse (импульсное ускорение), CFrame (телепорты на микрорасстояния), WalkSpeed (изменение параметра WalkSpeed), TP (периодические телепорты вперед) и Pulse (прерывистое движение).
- **Fly (Полет):** Полет на основе физической скорости (Velocity) с использованием гироскопа направления камеры или прямого изменения CFrame.
- **Infinite Jump:** Позволяет совершать бесконечные прыжки в воздухе.
- **NoClip:** Позволяет проходить сквозь стены и препятствия.
- **Anti-Knockback:** Гасит любые отбрасывания и внешние импульсы от взрывов, ударов или коллизий.
- **Spider:** Позволяет забираться вверх по любым вертикальным стенам, просто двигаясь вперед на них.
- **Spinbot:** Быстро вращает персонажа по горизонтальной оси.

## 4. УТИЛИТЫ И БЕЗОПАСНОСТЬ (UTILITIES & SAFETY)
- **Clear Chat:** Очищает чат от сообщений путем отправки пустых строк.
- **Reload GUI:** Перезагружает интерфейс меню чита.
- **Staff Detector:** Автоматически сканирует сервер на наличие администраторов (по ID группы, рангу или черному списку ID пользователей) и выполняет заданное действие: выводит уведомление, выходит с сервера (ServerHop) или выгружает чит (Uninject).
]]

table.insert(AIChat.History, {
    role = "system",
    content = PERSONA .. "\n\nТЕХНИЧЕСКИЙ МАНУАЛ:\n" .. TECHNICAL_MANUAL
})

function AIChat.SendMessage(userText, successCallback, errorCallback)
    if AIChat.IsProcessing then return end
    AIChat.IsProcessing = true
    
    table.insert(AIChat.History, { role = "user", content = userText })

    task.spawn(function()
        local success, response = pcall(function()
            return httpRequest({
                Url = API_CONFIG.URL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({
                    messages = AIChat.History
                })
            })
        end)

        AIChat.IsProcessing = false

        if success and (response.Success or (response.StatusCode and response.StatusCode >= 200 and response.StatusCode < 300)) then
            local data = HttpService:JSONDecode(response.Body)
            local aiResponse = data.choices[1].message.content
            table.insert(AIChat.History, { role = "assistant", content = aiResponse })
            if successCallback then successCallback(aiResponse) end
        else
            local errMsg = "⚠️ Ошибка связи с ядром ИИ"
            if not success then 
                errMsg = "⚠️ Ошибка выполнения запроса: " .. tostring(response) 
            elseif response.Body and response.Body ~= "" then
                pcall(function()
                    local errData = HttpService:JSONDecode(response.Body)
                    if errData and errData.error and errData.error.message then
                        errMsg = "⚠️ Server Error: " .. errData.error.message
                    end
                end)
            end
            if errorCallback then errorCallback(errMsg) end
        end
    end)
end

function AIChat.ClearHistory()
    AIChat.History = { AIChat.History[1] }
end

return AIChat
