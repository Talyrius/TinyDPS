--[[--------------------------------------------------------------------------------------------------------------------
  TinyDPS - A lightweight damage and healing meter.
  Copyright © 2010-2014 Sideshow, Talyrius <talyrius@gmail.com>. All rights reserved.
  See the accompanying README and LICENSE files for more information.

  Authorized distributions:
    http://www.curse.com/addons/wow/tinydps
    http://wow.curseforge.com/addons/tinydps/
    http://www.wowinterface.com/downloads/info16780-TinyDPS.html
--]]--------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- Localization --
------------------------------------------------------------------------------------------------------------------------

local tdpsL = {}

if GetLocale() == "koKR" then
  tdpsL.fight = "전투"
  tdpsL.allFight = "전체     모든 전투"
  tdpsL.current = "현재 "
  tdpsL.resetAllData = "초기화"
  tdpsL.showDamage = "데미지 보기"
  tdpsL.showHealing = "힐량 보기"

  tdpsL.report = "보고"
  tdpsL.top3 = "상위 3"
  tdpsL.top5 = "상위 5"
  tdpsL.top10 = "상위 10"
  tdpsL.say = "일반"
  tdpsL.instance = "인스턴스"
  tdpsL.raid = "공격대"
  tdpsL.party = "파티"
  tdpsL.guild = "길드"
  tdpsL.officer = "지휘관"
  tdpsL.whisper = "귓속말"
  tdpsL.whisper2 = "귓속말 <Name>"
  tdpsL.channel = "채널"

  tdpsL.options = "설정"
  tdpsL.text = "문자"
  tdpsL.size = "크기"
  tdpsL.increase = "증가"
  tdpsL.decrease = "감소"
  tdpsL.font = "글꼴"
  tdpsL.layout = "표시"
  tdpsL.outline = "외곽선"
  tdpsL.nudge = "넛지"

  tdpsL.dps = "DPS"
  tdpsL.rank = "순위"
  tdpsL.percent = "퍼센트"
  tdpsL.amount = "데미지"
  tdpsL.short = "요약"
  tdpsL.none = "없음"
  tdpsL.thin = "얇게"
  tdpsL.thick = "굵게"
  tdpsL.shadow = "그림자"
  tdpsL.mono = "단색"

  tdpsL.bars = "바"
  tdpsL.height = "높이"
  tdpsL.spacing = "간격"
  tdpsL.maximum = "줄"
  tdpsL.oneYourself = "1 (당신)"
  tdpsL.five = "5"
  tdpsL.ten = "10"
  tdpsL.fifteen = "15"
  tdpsL.twenty = "20"
  tdpsL.unlimited = "? (무제한)"

  tdpsL.colors = "색상"
  tdpsL.barBackdrop = "바 색상"
  tdpsL.frameBorder = "테두리 색상"
  tdpsL.frameBackdrop = "배경 색상"
  tdpsL.dimClassColors = "직업 색상 어둡게"
  tdpsL.resetClassColors = "직업 색상 초기화"
  tdpsL.swapBarTextColor = "직업 색상으로 표시"

  tdpsL.history = "      %i  전투 기록"
  tdpsL.keepOnlyBossFights = "보스만 세분화 유지"

  tdpsL.various = "전환"
  tdpsL.hideInPvP = "전장/투기장에서 숨김"
  tdpsL.hideWhenSolo = "솔로잉시 숨김"
  tdpsL.hideInCombat = "Hide In Combat (needs translatation)"
  tdpsL.hideOutOfCombat = "비전투시 숨김"
  tdpsL.growUpwards = "하단을 기준으로"
  tdpsL.minimapButton = "미니맵 버튼 보기"
  tdpsL.trackSpellDetails = "툴팁에 기술/대상 보기"
  tdpsL.resetOnNewGroup = "새 그룹시 자동삭제"
  tdpsL.refreshEverySecond = "매시간 초기화"

  tdpsL.spells = "      %i  툴팁에 표시되는 기술 갯수"
  tdpsL.targets = "      %i  툴팁에 표시되는 대상 갯수"

  tdpsL.close = "취소"
  tdpsL.empty = "<없음>"

  tdpsL.helpVersion = "버젼"
  tdpsL.helpMove = "이동: 쉬프트를 누른채로 마우스 드래그"
  tdpsL.helpResize = "사이즈조절: 우측하단 모서리를 드래그"
  tdpsL.helpToggle = "명령: /tdps 입력시 프레임 숨김/보기"
  tdpsL.helpParameters1 = "/tdps help | reset | damage | healing | whisper <name>"
  tdpsL.helpParameters2 = "/tdps visiblebars <number> | reportlength <number>"

  tdpsL.allClear = "모든 데이터 초기화"
  tdpsL.personal = "자신"
  tdpsL.byPets = "소환수"
  tdpsL.topAbilities = "상위 기술"
  tdpsL.topTargets = "상위 대상"

  tdpsL.noTarget = "잘못된 대상 혹은 대상이 선택되지 않음"
  tdpsL.noData = "기록할 데이터가 없음"

  tdpsL.tipPrefix = {
    d = "데미지량 -",
    h = "힐량 -",
  }
  tdpsL.repPrefix = {
    d = "데미지량 -",
    h = "힐량 -",
  }
  tdpsL.overallData = "전체 전투"
  tdpsL.currentFight = "현재 전투"
  tdpsL.lastFight = "마지막 전투"
  tdpsL.melee = "밀리"
elseif GetLocale() == "ruRU" then
  tdpsL.fight = "Бой"
  tdpsL.allFight = "Общий       Все бои"
  tdpsL.current = "Текущий"
  tdpsL.resetAllData = "Сбросить статистику"
  tdpsL.showDamage = "Показывать урон"
  tdpsL.showHealing = "Показывать исцеление"

  tdpsL.report = "Сообщить"
  tdpsL.top3 = "Top 3"
  tdpsL.top5 = "Top 5"
  tdpsL.top10 = "Top 10"
  tdpsL.say = "Сказать"
  tdpsL.instance = "Подземелье"
  tdpsL.raid = "Рейд"
  tdpsL.party = "Группа"
  tdpsL.guild = "Гильдия"
  tdpsL.officer = "Офицер"
  tdpsL.whisper = "Шепнуть"
  tdpsL.whisper2 = "Шепнуть <Name>"
  tdpsL.channel = "Канал"

  tdpsL.options = "Опции"
  tdpsL.text = "Текст"
  tdpsL.size = "Размер"
  tdpsL.increase = "Увеличить"
  tdpsL.decrease = "Уменьшить"
  tdpsL.font = "Шрифт"
  tdpsL.layout = "Отображать..."
  tdpsL.outline = "Контур"
  tdpsL.nudge = "Поднять текст"

  tdpsL.dps = "Урон в секунду"
  tdpsL.rank = "Ранг"
  tdpsL.percent = "Проценты"
  tdpsL.amount = "Урон"
  tdpsL.short = "Сократить значения"
  tdpsL.none = "Нет"
  tdpsL.thin = "Тонкий"
  tdpsL.thick = "Толстый"
  tdpsL.shadow = "Тень"
  tdpsL.mono = "Одноцветный"

  tdpsL.bars = "Полоски"
  tdpsL.height = "Высота"
  tdpsL.spacing = "Промежуток"
  tdpsL.maximum = "Максимум"
  tdpsL.oneYourself = "1 (Ваш персонаж)"
  tdpsL.five = "5"
  tdpsL.ten = "10"
  tdpsL.fifteen = "15"
  tdpsL.twenty = "20"
  tdpsL.unlimited = "Неограничено"

  tdpsL.colors = "Цвета"
  tdpsL.barBackdrop = "Цвет полос"
  tdpsL.frameBorder = "Цвет границ окна"
  tdpsL.frameBackdrop = "Цвет текстуры окна"
  tdpsL.dimClassColors = "Уменьшить яркость классовых цветов"
  tdpsL.resetClassColors = "Сбросить классовые цвета"
  tdpsL.swapBarTextColor = "Использовать цвета классов / 1 цвет для всех полос"

  tdpsL.history = "      Боёв запоминать: %i"
  tdpsL.keepOnlyBossFights = "Запоминать только бои с боссами"

  tdpsL.various = "Дополнительно"
  tdpsL.hideInPvP = "Скрывать в PvP"
  tdpsL.hideWhenSolo = "Скрывать вне группы"
  tdpsL.hideInCombat = "Скрыть в бою"
  tdpsL.hideOutOfCombat = "Показывать только в бою"
  tdpsL.growUpwards = "Отображать новые полосы над предыдущими"
  tdpsL.minimapButton = "Кнопка у миникарты"
  tdpsL.trackSpellDetails = "Показывать детали (атакуемые цели/исп. способности)"
  tdpsL.resetOnNewGroup = "Сбрасывать статистику при входе в группу"
  tdpsL.refreshEverySecond = "Обновлять статистику каждую секунду"

  tdpsL.spells = "      Заклинаний в подсказке: %i"
  tdpsL.targets = "      Целей в подсказке: %i"

  tdpsL.close = "Закрыть"
  tdpsL.empty = "<Нет>"

  tdpsL.helpVersion = "Версия"
  tdpsL.helpMove = "Перемещение: зажмите Shift и двигайте окно"
  tdpsL.helpResize = "Смена размера: двигайте стрелку в правой нижней части окна"
  tdpsL.helpToggle = "Команда: '/tdps' скрыть окно/показать"
  tdpsL.helpParameters1 = "/tdps help | reset | damage | healing | whisper <name>"
  tdpsL.helpParameters2 = "/tdps visiblebars <number> | reportlength <number>"

  tdpsL.allClear = "Статистика была сброшена"
  tdpsL.personal = "Личный"
  tdpsL.byPets = "Питомец"
  tdpsL.topAbilities = "Наиболее используемые способности"
  tdpsL.topTargets = "Наиболее атакуемые цели"

  tdpsL.noTarget = "Возьмите в цель игрока своей фракции"
  tdpsL.noData = "Нет статистики для сообщения"

  tdpsL.tipPrefix = {
    d = "Урон:",
    h = "Исцеление:",
  }
  tdpsL.repPrefix = {
    d = "Урон:",
    h = "Исцеление:",
  }
  tdpsL.overallData = "Все бои"
  tdpsL.currentFight = "Текущий бой"
  tdpsL.lastFight = "Последний бой"
  tdpsL.melee = "Ближний бой"
elseif GetLocale() == "deDE" then
  tdpsL.fight = "Kampf"
  tdpsL.allFight = "Gesamt   Alle Kämpfe"
  tdpsL.current = "Aktuell"
  tdpsL.resetAllData = "Alle Daten zurücksetzen"
  tdpsL.showDamage = "Schaden anzeigen"
  tdpsL.showHealing = "Heilung anzeigen"

  tdpsL.report = "Verkünden"
  tdpsL.top3 = "Top 3"
  tdpsL.top5 = "Top 5"
  tdpsL.top10 = "Top 10"
  tdpsL.say = "Sagen"
  tdpsL.instance = "Instanz"
  tdpsL.raid = "Schlachtzug"
  tdpsL.party = "Gruppe"
  tdpsL.guild = "Gilde"
  tdpsL.officer = "Offizier"
  tdpsL.whisper = "Flüstern"
  tdpsL.whisper2 = "Flüstern <Name>"
  tdpsL.channel = "Channel"

  tdpsL.options = "Optionen"
  tdpsL.text = "Text"
  tdpsL.size = "Größe"
  tdpsL.increase = "Vergrößern"
  tdpsL.decrease = "Verkleinern"
  tdpsL.font = "Schriftart"
  tdpsL.layout = "Layout"
  tdpsL.outline = "Kontur"
  tdpsL.nudge = "Anstoßen"

  tdpsL.dps = "DPS"
  tdpsL.rank = "Rang"
  tdpsL.percent = "Prozent"
  tdpsL.amount = "Menge"
  tdpsL.short = "Kurzes Format"
  tdpsL.none = "Keine"
  tdpsL.thin = "Dünn"
  tdpsL.thick = "Dick"
  tdpsL.shadow = "Schatten"
  tdpsL.mono = "Monochrome"

  tdpsL.bars = "Leisten"
  tdpsL.height = "Höhe"
  tdpsL.spacing = "Abstand"
  tdpsL.maximum = "Maximum"
  tdpsL.oneYourself = "1 (Du selbst)"
  tdpsL.five = "5"
  tdpsL.ten = "10"
  tdpsL.fifteen = "15"
  tdpsL.twenty = "20"
  tdpsL.unlimited = "? (Unbegrenzt)"

  tdpsL.colors = "Farben"
  tdpsL.barBackdrop = "Leisten - Hintergrund"
  tdpsL.frameBorder = "Fenster - Rand"
  tdpsL.frameBackdrop = "Fenster - Hintergrund"
  tdpsL.dimClassColors = "Klassenfarben verdunkeln"
  tdpsL.resetClassColors = "Klassenfarben zurücksetzen"
  tdpsL.swapBarTextColor = "Leisten/Text Farben austauschen"

  tdpsL.history = "      %i  Historische Kämpfe"
  tdpsL.keepOnlyBossFights = "Nur Bosskämpfe behalten"

  tdpsL.various = "Verschiedenes"
  tdpsL.hideInPvP = "In PvP verstecken"
  tdpsL.hideWhenSolo = "Wenn solo, verstecken"
  tdpsL.hideInCombat = "Hide In Combat (needs translatation)"
  tdpsL.hideOutOfCombat = "Außerhalb des Kampfes verstecken"
  tdpsL.growUpwards = "Aufwärts auflisten"
  tdpsL.minimapButton = "Minimap Button"
  tdpsL.trackSpellDetails = "Zauber Details aufzeichnen"
  tdpsL.resetOnNewGroup = "Bei neuer Gruppe zurücksetzen"
  tdpsL.refreshEverySecond = "Jede Sekunde aktualisieren"

  tdpsL.spells = "      %i  Zauber in Tooltips"
  tdpsL.targets = "      %i  Ziele in Tooltips"

  tdpsL.close = "Abbrechen"
  tdpsL.empty = "<Leer>"

  tdpsL.helpVersion = "Version"
  tdpsL.helpMove = "move: Halte Umschalt gedrückt und bewege das Fenster"
  tdpsL.helpResize = "resize: An der unteren rechten Ecke ziehen"
  tdpsL.helpToggle = "command: Tippe /tdps ein um das Fenster anzuzeigen/auszublenden"
  tdpsL.helpParameters1 = "/tdps help | reset | damage | healing | whisper <name>"
  tdpsL.helpParameters2 = "/tdps visiblebars <number> | reportlength <number>"

  tdpsL.allClear = "Alle Daten wurden zurückgesetzt"
  tdpsL.personal = "Persönlich"
  tdpsL.byPets = "Durch Begleiter"
  tdpsL.topAbilities = "Top Fähigkeiten"
  tdpsL.topTargets = "Top Ziele"

  tdpsL.noTarget = "Ungültig oder kein Ziel ausgewählt"
  tdpsL.noData = "Keine Daten vorhanden zum Verkünden"

  tdpsL.tipPrefix = {
    d = "Schaden für",
    h = "Heilung für",
  }
  tdpsL.repPrefix = {
    d = "Schaden gemacht für",
    h = "Geheilt für",
  }
  tdpsL.overallData = "gesamte Daten"
  tdpsL.currentFight = "aktuellen Kampf"
  tdpsL.lastFight = "letzten Kampf"
  tdpsL.melee = "Nahkampf"
elseif GetLocale() == "frFR" then
  tdpsL.fight = "Combat"
  tdpsL.allFight = "L'ensemble de tous les combats"
  tdpsL.current = "Actuel"
  tdpsL.resetAllData = "Réinitialiser toutes les données"
  tdpsL.showDamage = "Voir les dommages"
  tdpsL.showHealing = "Voir les soins"

  tdpsL.report = "Rapport"
  tdpsL.top3 = "Top 3"
  tdpsL.top5 = "Top 5"
  tdpsL.top10 = "Top 10"
  tdpsL.say = "Dire"
  tdpsL.instance = "Instance"
  tdpsL.raid = "Raid"
  tdpsL.party = "Groupe"
  tdpsL.guild = "Guilde"
  tdpsL.officer = "Officer"
  tdpsL.whisper = "Chuchoter à la cible"
  tdpsL.whisper2 = "Chuchoter <Nom>"
  tdpsL.channel = "Canal"

  tdpsL.options = "Options"
  tdpsL.text = "Texte"
  tdpsL.size = "Taille"
  tdpsL.increase = "Agrandir"
  tdpsL.decrease = "Réduire"
  tdpsL.font = "Fonte"
  tdpsL.layout = "Disposition"
  tdpsL.outline = "Contour"
  tdpsL.nudge = "Démarrer"

  tdpsL.dps = "DPS"
  tdpsL.rank = "Classement"
  tdpsL.percent = "Pourcentage"
  tdpsL.amount = "Quantité"
  tdpsL.short = "Format court"
  tdpsL.none = "Aucun"
  tdpsL.thin = "Mince"
  tdpsL.thick = "Épais"
  tdpsL.shadow = "Ombre"
  tdpsL.mono = "Monochrome"

  tdpsL.bars = "Bars"
  tdpsL.height = "Hauteur"
  tdpsL.spacing = "Espacement"
  tdpsL.maximum = "Barres visibles"
  tdpsL.oneYourself = "1 (Vous-même)"
  tdpsL.five = "5"
  tdpsL.ten = "10"
  tdpsL.fifteen = "15"
  tdpsL.twenty = "20"
  tdpsL.unlimited = "? (Illimité)"

  tdpsL.colors = "Couleurs"
  tdpsL.barBackdrop = "Bar fond"
  tdpsL.frameBorder = "Bordure de la fenêtre"
  tdpsL.frameBackdrop = "Fond de la fenêtre"
  tdpsL.dimClassColors = "Couleurs sombres de classe"
  tdpsL.resetClassColors = "Réinitialiser les couleurs de classe"
  tdpsL.swapBarTextColor = "Changer la bar/Couleur du texte"

  tdpsL.history = "      %i  Combats historiques"
  tdpsL.keepOnlyBossFights = "Garde seulement les combats des boss"

  tdpsL.various = "Divers"
  tdpsL.hideAlways = "Toujours cacher"
  tdpsL.hideInPvP = "Cacher en PvP"
  tdpsL.hideWhenSolo = "Cacher en mode solo"
  tdpsL.hideInCombat = "Cacher en Combat"
  tdpsL.hideOutOfCombat = "Cacher hors combat"
  tdpsL.growUpwards = "Direction vers le haut"
  tdpsL.minimapButton = "Bouton sur la Minicarte"
  tdpsL.trackSpellDetails = "Suivre les détails des sorts"
  tdpsL.resetOnNewGroup = "Réinitialiser le nouveau groupe"
  tdpsL.refreshEverySecond = "Rafraîchir Chaque Seconde"

  tdpsL.spells = "      %i  Sorts dans les infobulles"
  tdpsL.targets = "      %i  Objectifs dans les infobulles"

  tdpsL.close = "Annuler"
  tdpsL.empty = "<Vide>"

  tdpsL.helpVersion = "Version"
  tdpsL.helpMove = "Pour déplacer: Maintenez la touche Maj et faites glisser le cadre"
  tdpsL.helpResize = "Redimensionner: Faites glisser le coin inférieur droit"
  tdpsL.helpToggle = "Commande: Taper '/tdps' pour masquer ou afficher"
  tdpsL.helpParameters1 = "/tdps help | reset | damage | healing | whisper <nom>"
  tdpsL.helpParameters2 = "/tdps visiblebars <nombre> | reportlength <nombre>"

  tdpsL.allClear = "Toutes les données ont été réinitialisées"
  tdpsL.personal = "Personnel"
  tdpsL.byPets = "Par Pet(s)"
  tdpsL.topAbilities = "Capacités utilisées le plus en combat"
  tdpsL.topTargets = "Tes cibles principales"

  tdpsL.noTarget = "Cible non valide ou non sélectionné"
  tdpsL.noData = "Aucune donnée à afficher pour le moment"

  tdpsL.tipPrefix = {
    d = "Donnée des dommages pour",
    h = "Données des soins pour",
  }
  tdpsL.repPrefix = {
    d = "Dommages causés par",
    h = "Soins causés par",
  }
  tdpsL.overallData = "Les données globales"
  tdpsL.currentFight = "Le combat actuel"
  tdpsL.lastFight = "Le dernier combat"
  tdpsL.melee = "Mêlée"
elseif GetLocale() == "itIT" then
  tdpsL.fight = "Scontro"
  tdpsL.allFight = "Totale di tutti gli scontri (Overall Data)"
  tdpsL.current = "Corrente"
  tdpsL.resetAllData = "Riazzera tutti i dati"
  tdpsL.showDamage = "Mostra i danni"
  tdpsL.showHealing = "Mostra le cure"

  tdpsL.report = "Riporta"
  tdpsL.top3 = "Migliori 3"
  tdpsL.top5 = "Migliori 5"
  tdpsL.top10 = "Migliori 10"
  tdpsL.say = "Dici"
  tdpsL.instance = "Istance"
  tdpsL.raid = "Incursione"
  tdpsL.party = "Gruppo"
  tdpsL.guild = "Gilda"
  tdpsL.officer = "Ufficiali"
  tdpsL.whisper = "Sussurro al bersaglio"
  tdpsL.whisper2 = "Sussurro a <Nome>"
  tdpsL.channel = "Canale"

  tdpsL.options = "Opzioni"
  tdpsL.text = "Testo"
  tdpsL.size = "Dimensioni"
  tdpsL.increase = "Ingrandisci"
  tdpsL.decrease = "Rimpicciolisci"
  tdpsL.font = "Carattere"
  tdpsL.layout = "Disposizione"
  tdpsL.outline = "Contorno"
  tdpsL.nudge = "Avvio"

  tdpsL.dps = "DPS"
  tdpsL.rank = "Rango"
  tdpsL.percent = "Percentuale"
  tdpsL.amount = "Ammontare"
  tdpsL.short = "Formato abbreviato"
  tdpsL.none = "Nessuno"
  tdpsL.thin = "Leggero"
  tdpsL.thick = "Pesante"
  tdpsL.shadow = "Ombreggiato"
  tdpsL.mono = "Monocromatico"

  tdpsL.bars = "Barre"
  tdpsL.height = "Altezza"
  tdpsL.spacing = "Spaziatura"
  tdpsL.maximum = "Barre visibili"
  tdpsL.oneYourself = "1 (Te stesso)"
  tdpsL.five = "5"
  tdpsL.ten = "10"
  tdpsL.fifteen = "15"
  tdpsL.twenty = "20"
  tdpsL.unlimited = "? (Illimitate)"

  tdpsL.colors = "Colori"
  tdpsL.barBackdrop = "Sfondo delle barre"
  tdpsL.frameBorder = "Bordo del riquadro"
  tdpsL.frameBackdrop = "Sfondo del riquadro"
  tdpsL.dimClassColors = "Scurisci i colori delle classi"
  tdpsL.resetClassColors = "Ripristina i colori delle classi"
  tdpsL.swapBarTextColor = "Scambia il colore tra barra e testo"

  tdpsL.history = "      %i Storico degli scontri"
  tdpsL.keepOnlyBossFights = "Conserva solo gli scontri contro un boss"

  tdpsL.various = "Varie"
  tdpsL.hideAlways = "Nascondi sempre"
  tdpsL.hideInPvP = "Nascondi in PvP"
  tdpsL.hideWhenSolo = "Nascondi in solitaria"
  tdpsL.hideInCombat = "Nascondi in combattimento"
  tdpsL.hideOutOfCombat = "Nascondi fuori dal combattimento"
  tdpsL.growUpwards = "Sviluppa verso l'alto"
  tdpsL.minimapButton = "Pulsante della minimappa"
  tdpsL.trackSpellDetails = "Traccia i dettagli degli incantesimi"
  tdpsL.resetOnNewGroup = "Riazzera con un nuovo gruppo"
  tdpsL.refreshEverySecond = "Aggiorna ogni secondo"

  tdpsL.spells = "      %i Incantesimi nei suggerimenti"
  tdpsL.targets = "      %i Bersagli nei suggerimenti"

  tdpsL.close = "Cancella"
  tdpsL.empty = "<Vuoto>"

  tdpsL.helpVersion = "Versione"
  tdpsL.helpMove = "muovi: tieni premuto shift e trascina il riquadro"
  tdpsL.helpResize = "ridimensiona: trascina l'angolo destro in basso"
  tdpsL.helpToggle = "visibilità: digita /tdps per nascondere o visualizzare"
  tdpsL.helpParameters1 = "/tdps help | reset | damage | healing | whisper <nome>"
  tdpsL.helpParameters2 = "/tdps visiblebars <numero> | reportlength <numero>"

  tdpsL.allClear = "Tutti i dati sono stati azzerati"
  tdpsL.personal = "Personale"
  tdpsL.byPets = "Famigli"
  tdpsL.topAbilities = "Abilità migliori"
  tdpsL.topTargets = "Bersagli migliori"

  tdpsL.noTarget = "Bersaglio invalido o non selezionato"
  tdpsL.noData = "Nessun dato da riportare"

  tdpsL.tipPrefix = {
    d = "Danno per",
    h = "Cura per",
  }
  tdpsL.repPrefix = {
    d = "Danno fatto per",
    h = "Cura fatta per",
  }
  tdpsL.overallData = "dati complessivi"
  tdpsL.currentFight = "scontro corrente"
  tdpsL.lastFight = "ultimo scontro"
  tdpsL.melee = "mischia"
else
  tdpsL.fight = "Fight"
  tdpsL.allFight = "Overall     All Fights"
  tdpsL.current = "Current"
  tdpsL.resetAllData = "Reset All Data"
  tdpsL.showDamage = "Show Damage"
  tdpsL.showHealing = "Show Healing"

  tdpsL.report = "Report"
  tdpsL.top3 = "Top 3"
  tdpsL.top5 = "Top 5"
  tdpsL.top10 = "Top 10"
  tdpsL.say = "Say"
  tdpsL.instance = "Instance"
  tdpsL.raid = "Raid"
  tdpsL.party = "Party"
  tdpsL.guild = "Guild"
  tdpsL.officer = "Officer"
  tdpsL.whisper = "Whisper Target"
  tdpsL.whisper2 = "Whisper <Name>"
  tdpsL.channel = "Channel"

  tdpsL.options = "Options"
  tdpsL.text = "Text"
  tdpsL.size = "Size"
  tdpsL.increase = "Increase"
  tdpsL.decrease = "Decrease"
  tdpsL.font = "Font"
  tdpsL.layout = "Layout"
  tdpsL.outline = "Outline"
  tdpsL.nudge = "Nudge"

  tdpsL.dps = "DPS"
  tdpsL.rank = "Rank"
  tdpsL.percent = "Percent"
  tdpsL.amount = "Amount"
  tdpsL.short = "Short Format"
  tdpsL.none = "None"
  tdpsL.thin = "Thin"
  tdpsL.thick = "Thick"
  tdpsL.shadow = "Shadow"
  tdpsL.mono = "Monochrome"

  tdpsL.bars = "Bars"
  tdpsL.height = "Height"
  tdpsL.spacing = "Spacing"
  tdpsL.maximum = "Visible bars"
  tdpsL.oneYourself = "1 (Yourself)"
  tdpsL.five = "5"
  tdpsL.ten = "10"
  tdpsL.fifteen = "15"
  tdpsL.twenty = "20"
  tdpsL.unlimited = "? (Unlimited)"

  tdpsL.colors = "Colors"
  tdpsL.barBackdrop = "Bar Backdrop"
  tdpsL.frameBorder = "Frame Border"
  tdpsL.frameBackdrop = "Frame Backdrop"
  tdpsL.dimClassColors = "Dim Class Colors"
  tdpsL.resetClassColors = "Reset Class Colors"
  tdpsL.swapBarTextColor = "Swap Bar/Text Color"

  tdpsL.history = "      %i  Historic Fights"
  tdpsL.keepOnlyBossFights = "Keep Only Boss Fights"

  tdpsL.various = "Various"
  tdpsL.hideAlways = "Hide Always"
  tdpsL.hideInPvP = "Hide In PvP"
  tdpsL.hideWhenSolo = "Hide When Solo"
  tdpsL.hideInCombat = "Hide In Combat"
  tdpsL.hideOutOfCombat = "Hide Out Of Combat"
  tdpsL.growUpwards = "Grow Upwards"
  tdpsL.minimapButton = "Minimap Button"
  tdpsL.trackSpellDetails = "Track Spell Details"
  tdpsL.resetOnNewGroup = "Reset On New Group"
  tdpsL.refreshEverySecond = "Refresh Every Second"

  tdpsL.spells = "      %i  Spells in Tooltips"
  tdpsL.targets = "      %i  Targets in Tooltips"

  tdpsL.close = "Cancel"
  tdpsL.empty = "<Empty>"

  tdpsL.helpVersion = "Version"
  tdpsL.helpMove = "move: hold shift and drag the frame"
  tdpsL.helpResize = "resize: drag the bottom right corner"
  tdpsL.helpToggle = "toggle: type /tdps to hide or show"
  tdpsL.helpParameters1 = "/tdps help | reset | damage | healing | whisper <name>"
  tdpsL.helpParameters2 = "/tdps visiblebars <number> | reportlength <number>"

  tdpsL.allClear = "All data has been reset"
  tdpsL.personal = "Personal"
  tdpsL.byPets = "By Pet(s)"
  tdpsL.topAbilities = "Top Abilities"
  tdpsL.topTargets = "Top Targets"

  tdpsL.noTarget = "Invalid or no target selected"
  tdpsL.noData = "No data to report"

  tdpsL.tipPrefix = {
    d = "Damage for",
    h = "Healing for",
  }
  tdpsL.repPrefix = {
    d = "Damage Done for",
    h = "Healing Done for",
  }
  tdpsL.overallData = "Overall Data"
  tdpsL.currentFight = "Current Fight"
  tdpsL.lastFight = "Last Fight"
  tdpsL.melee = "Melee"
end

------------------------------------------------------------------------------------------------------------------------
-- Variables --
------------------------------------------------------------------------------------------------------------------------

local bu = {}
local bar = {}
local tdpsShield = {}
local px, com, key, arg
local maxValue, barsWithValue
local scrollPos, isMovingOrSizing = 1, false
local ttSpellMerge, ttMobMerge, ttSort = {}, {}, {}
local cColor

local isBoss = LibStub("LibBossIDs-1.0").BossIDs
local isHeal = {
  SPELL_HEAL = true,
  SPELL_PERIODIC_HEAL = true,
}
local isMiss = {
  SWING_MISSED = true,
  RANGE_MISSED = true,
  SPELL_MISSED = true,
  SPELL_PERIODIC_MISSED = true,
}
local isDamage = {
  SWING_DAMAGE = true,
  RANGE_DAMAGE = true,
  SPELL_DAMAGE = true,
  SPELL_PERIODIC_DAMAGE = true,
  DAMAGE_SHIELD = true,
  DAMAGE_SPLIT = true,
}
local isValidEvent = {
  SWING_DAMAGE = true,
  SWING_MISSED = true,
  RANGE_DAMAGE = true,
  RANGE_MISSED = true,
  SPELL_DAMAGE = true,
  SPELL_HEAL = true,
  SPELL_MISSED = true,
  SPELL_SUMMON = true,
  SPELL_PERIODIC_DAMAGE = true,
  SPELL_PERIODIC_HEAL = true,
  SPELL_PERIODIC_MISSED = true,
  SPELL_EXTRA_ATTACKS = true,
  DAMAGE_SHIELD = true,
  DAMAGE_SPLIT = true,
}

local isAbsorb = {
  -- Death Knight
  [ 48707] = true, -- Anti-Magic Shell
  [ 50461] = true, -- Anti-Magic Zone
  [ 77535] = true, -- Blood Shield

  -- Druid
  [110570] = true, -- Symbiosis: Anti-Magic Shell

  -- Mage
  [  1463] = true, -- Incanter's Ward
  [ 11426] = true, -- Ice Barrier

  -- Monk
  [116849] = true, -- Life Cocoon
  [123402] = true, -- Guard

  -- Paladin
  [ 65148] = true, -- Sacred Shield
  [ 86273] = true, -- Illuminated Healing

  -- Priest
  [    17] = true, -- Power Word: Shield
  [ 47753] = true, -- Divine Aegis
  [ 47788] = true, -- Guardian Spirit
  [114908] = true, -- Spirit Shell

  -- Shaman
  [114893] = true, -- Stone Bulwark Totem

  -- Warlock
  [  6229] = true, -- Twilight Ward
  [  7812] = true, -- Sacrifice
  [ 91711] = true, -- Nether Ward
  [110913] = true, -- Dark Bargain

  -- Warrior
  [112048] = true, -- Shield Barrier

  -- Items
  [ 64411] = true, -- Blessing of the Ancient (Val'anyr Hammer of Ancient Kings)
  [ 64413] = true, -- Protection of Ancient Kings (Val'anyr Hammer of Ancient Kings)
  [105801] = true, -- Delayed Judgment (Paladin T13 Protection 2P Bonus)
  [105909] = true, -- Shield of Fury (Warrior T13 Protection 2P Bonus)

  -- Enchants
  [116631] = true, -- Colossus
}

local isExcludedPet = {
  -- Totems
  [ 2630] = true, -- Earthbind Totem
  [ 5913] = true, -- Tremor Totem
  [10467] = true, -- Mana Tide Totem
  [53006] = true, -- Spirit Link Totem
  [59717] = true, -- Windwalk Totem
  [60561] = true, -- Earthgrab Totem
  [61245] = true, -- Capacitor Totem
  [62002] = true, -- Stormlash Totem

  -- Miscellaneous
  [29742] = true, -- Snake Wrap
  [36619] = true, -- Bone Spike
  [38163] = true, -- Swarming Shadows
  [38711] = true, -- Bone Spike
  [38712] = true, -- Bone Spike
}

local function initialiseSavedVariables()
  tdps = {
    speed = 2,
    width = 190,
    version = -1,
    autoReset = true,
    swapColor = true,
    tooltipSpells = 3,
    tooltipTargets = 3,
    anchor = "TOPLEFT",
    layout = 10,
    showRank = true,
    onlyBossSegments = false,
    showMinimapButton = false,
    spacing = 2,
    barHeight = 15,
    bar = {0.9, 0.9, 0.9, 1},
    barbackdrop = {1, 1, 1, 0.05},
    border = {0, 0, 0, 0.8},
    backdrop = {0, 0, 0, 0.8},
  }

  tdpsTextOffset = 0
  tdpsVisibleBars = 10
  tdpsReportLength = 5

  if GameFontNormal then
    tdpsFont = {
      name = GameFontNormal:GetFont(),
      size = 12,
      outline = "",
      shadow = 1,
    }
  else
    tdpsFont = {
      name = [[Interface\AddOns\TinyDPS\Fonts\Visitor.ttf]],
      size = 13,
      outline = "OUTLINE, MONOCHROME",
      shadow = 0,
    }
  end

  tdpsColorAlpha = .8
end

tdpsPosition = {
  x = 0,
  y = 0,
}

local function initialiseSavedVariablesPerCharacter()
  tdpsVersion = -1
  tdpsPet, tdpsPlayer, tdpsLink = {}, {}, {}
  tdpsFight = {{
      name = tdpsL.overallData,
      d = 0, h = 0
    }, {
      name = nil,
      boss = nil,
      d = 0,
      h = 0
    },
  }
  tdpsPartySize = 0
  tdpsF = 1
  tdpsV = "d"
  tdpsNumberOfFights = 2
end

initialiseSavedVariables()
initialiseSavedVariablesPerCharacter()

------------------------------------------------------------------------------------------------------------------------
-- Frames --
------------------------------------------------------------------------------------------------------------------------

-- anchor frame
CreateFrame("Frame", "tdpsAnchor", UIParent)
tdpsAnchor:SetWidth(3)
tdpsAnchor:SetHeight(3)
tdpsAnchor:SetMovable(true)
tdpsAnchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
tdpsAnchor:SetFrameStrata("BACKGROUND")
tdpsAnchor:SetBackdrop({
  bgFile = [[Interface\AddOns\TinyDPS\Textures\blank.tga]],
  edgeFile = [[Interface\AddOns\TinyDPS\Textures\blank.tga]],
  tile = false,
  tileSize = 1,
  edgeSize = 1,
  insets = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 1,
  },
})
tdpsAnchor:SetBackdropColor(0, 0, 0, 0)
tdpsAnchor:SetBackdropBorderColor(0, 0, 0, 0)

-- main window
CreateFrame("Frame", "tdpsFrame", UIParent)
tdpsFrame:SetWidth(190)
tdpsFrame:SetHeight(tdps.barHeight + 4)
tdpsFrame:SetClampedToScreen(true)
tdpsFrame:EnableMouse(true)
tdpsFrame:EnableMouseWheel(true)
tdpsFrame:SetResizable(true)
tdpsFrame:SetPoint("TOPLEFT", tdpsAnchor, "TOPLEFT", 0, 0)
tdpsFrame:SetFrameStrata("MEDIUM")
tdpsFrame:SetFrameLevel(1)
tdpsFrame:SetBackdrop({
  bgFile = [[Interface\AddOns\TinyDPS\Textures\blank.tga]],
  edgeFile = [[Interface\AddOns\TinyDPS\Textures\blank.tga]],
  tile = false,
  tileSize = 1,
  edgeSize = 1,
  insets = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 1,
  },
})

-- main window animation
local tdpsAnimationGroup = tdpsFrame:CreateAnimationGroup()
local tdpsAnimation = tdpsAnimationGroup:CreateAnimation("Alpha")
tdpsAnimation:SetChange(-1)
tdpsAnimation:SetDuration(.2)
tdpsAnimation:SetScript("OnFinished", function(self, requested)
  tdpsRefresh()
end)

-- title font string
tdpsFrame:CreateFontString("noData", "OVERLAY")
noData:SetPoint("CENTER", tdpsFrame, "CENTER")
noData:SetJustifyH("CENTER")
noData:SetFont(tdpsFont.name, tdpsFont.size)
noData:SetShadowColor(.1, .1, .1, 1)
noData:SetShadowOffset(tdpsFont.shadow, tdpsFont.shadow * -1)
noData:SetTextColor(1, 1, 1, .07)
noData:SetText("TinyDPS")

-- resize frame
CreateFrame("Frame", "tdpsResizeFrame", tdpsFrame)
tdpsResizeFrame:SetFrameStrata("MEDIUM")
tdpsResizeFrame:SetFrameLevel(3)
tdpsResizeFrame:SetWidth(6)
tdpsResizeFrame:SetHeight(6)
tdpsResizeFrame:SetPoint("BOTTOMRIGHT", tdpsFrame, "BOTTOMRIGHT", 0, 0)
tdpsResizeFrame:EnableMouse(true)
tdpsResizeFrame:CreateTexture("tdpsResizeTexture")
tdpsResizeTexture:SetTexture([[Interface\Buttons\UI-AutoCastableOverlay]])
tdpsResizeTexture:SetTexCoord(.619, .760, .612, .762)
tdpsResizeTexture:SetDesaturated(true)
tdpsResizeTexture:SetAlpha(0)
tdpsResizeTexture:ClearAllPoints()
tdpsResizeTexture:SetPoint("TOPLEFT", tdpsResizeFrame)
tdpsResizeTexture:SetPoint("BOTTOMRIGHT", tdpsResizeFrame, "BOTTOMRIGHT", 0, 0)
tdpsResizeFrame:SetScale(1.3)

-- minimap button frame
CreateFrame("Button", "tdpsButtonFrame", Minimap)
tdpsButtonFrame:SetHeight(30)
tdpsButtonFrame:SetWidth(30)
tdpsButtonFrame:SetMovable(true)
tdpsButtonFrame:SetClampedToScreen(true)
tdpsButtonFrame:SetUserPlaced(true)
tdpsButtonFrame:EnableMouse(true)
tdpsButtonFrame:RegisterForDrag("LeftButton")
tdpsButtonFrame:SetFrameStrata("MEDIUM")
tdpsButtonFrame:SetPoint("CENTER", Minimap:GetWidth() / 2 * -1, Minimap:GetHeight() / 2 * -1)
tdpsButtonFrame:CreateTexture("tdpsButtonTexture", "BACKGROUND")
tdpsButtonTexture:SetWidth(24)
tdpsButtonTexture:SetHeight(24)
tdpsButtonTexture:SetTexture([[Interface\AddOns\TinyDPS\Textures\minimapbutton.blp]])
tdpsButtonTexture:SetPoint("CENTER")
tdpsButtonFrame:SetNormalTexture(tdpsButtonTexture)
tdpsButtonFrame:CreateTexture("tdpsButtonTexturePushed", "BACKGROUND")
tdpsButtonTexturePushed:SetWidth(24)
tdpsButtonTexturePushed:SetHeight(24)
tdpsButtonTexturePushed:SetTexture([[Interface\AddOns\TinyDPS\Textures\minimapbutton.blp]])
tdpsButtonTexturePushed:SetPoint("CENTER", 1, -1)
tdpsButtonFrame:SetPushedTexture(tdpsButtonTexturePushed)
tdpsButtonFrame:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
tdpsButtonFrame:CreateTexture("tdpsButtonOverlay", "OVERLAY")
tdpsButtonOverlay:SetWidth(53)
tdpsButtonOverlay:SetHeight(53)
tdpsButtonOverlay:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])
tdpsButtonOverlay:SetPoint("TOPLEFT")

-- dropdown frame
CreateFrame("Frame", "tdpsDropDown")
tdpsDropDown.displayMode = "MENU"

------------------------------------------------------------------------------------------------------------------------
-- Functions --
------------------------------------------------------------------------------------------------------------------------

-- make local copy of global functions (faster)
local tonumber, band = tonumber, bit.band
local floor, abs = floor, abs
local sort, tremove, tinsert, wipe = sort, tremove, tinsert, wipe
local pairs, ipairs, type = pairs, ipairs, type
local strsub, strsplit, format = strsub, strsplit, format
local UnitName, UnitGUID, UnitClass = UnitName, UnitGUID, UnitClass
local UnitIsPlayer, UnitAffectingCombat = UnitIsPlayer, UnitAffectingCombat
local IsInInstance, IsInRaid, IsInGroup = IsInInstance, IsInRaid, IsInGroup
local GetNumGroupMembers, GetWorldPVPAreaInfo = GetNumGroupMembers, GetWorldPVPAreaInfo
local GetCurrentMapAreaID, SetMapByID, SetMapToCurrentZone = GetCurrentMapAreaID, SetMapByID, SetMapToCurrentZone

-- some random functions
local function round(num, idp)
  return floor(num * (10 ^ (idp or 0)) + .5) / (10 ^ (idp or 0))
end

local function echo(str)
  print("|cfffef00fTinyDPS |cff82e2eb"..(str or ""))
end

local function getClass(name)
  local _, class = UnitClass(name)
  return class or "UNKNOWN"
end

-- this is how GetCurrentMapAreaID() should work
local function getCurrentMapAreaID()
  if WorldMapFrame:IsShown() then
    local viewing = GetCurrentMapAreaID()
    SetMapToCurrentZone()
    local current = GetCurrentMapAreaID()
    SetMapByID(viewing)
    return current
  end
  return GetCurrentMapAreaID()
end

local function isPvPZone()
  local mapAreaID = getCurrentMapAreaID()
  local _, instanceType = IsInInstance()
  local _, _, isActiveWintergrasp = GetWorldPVPAreaInfo(1)
  local _, _, isActiveTolBarad = GetWorldPVPAreaInfo(2)
  if instanceType == "pvp" or instanceType == "arena" or (mapAreaID == 501 and isActiveWintergrasp) or (mapAreaID == 708
  and isActiveTolBarad) then
    return true
  end
end

local function nudgeText()
  if tdpsTextOffset == 2 then
    tdpsTextOffset = -2
  else
    tdpsTextOffset = tdpsTextOffset + 1
  end
  for i = 1, #bar do
    bar[i].fontStringLeft:ClearAllPoints()
    bar[i].fontStringRight:ClearAllPoints()
    bar[i].fontStringRight:SetPoint("RIGHT", -1, tdpsTextOffset)
    bar[i].fontStringLeft:SetPoint("LEFT", 1, tdpsTextOffset)
    bar[i].fontStringLeft:SetPoint("RIGHT", bar[i].fontStringRight, "LEFT", -2, 1)
  end
end

local function report(button, channel, playerName)
  if type(channel) == "number" then
    destination = channel
    channel = "CHANNEL"
  end

  if channel == "WHISPER" then
    if not playerName then
      if UnitIsPlayer("target") and UnitCanCooperate("player", "target") then
        destination = GetUnitName("target", true)
      else
        echo(tdpsL.noTarget)
        return
      end
    else
      destination = playerName
    end
  end

  -- make table for sorting
  local report = {}
  for k, v in pairs(tdpsPlayer) do
    local reportPlayer = {
      name = strsplit("-", tdpsPlayer[k].name),
      n = tdpsPlayer[k].fight[tdpsF][tdpsV],
      t = tdpsPlayer[k].fight[tdpsF].t,
    }
    local pet = tdpsPlayer[k].pet
    for i = 1, #pet do
      -- add pet number
      reportPlayer.n = reportPlayer.n + tdpsPet[pet[i]].fight[tdpsF][tdpsV]
      -- check time
      if tdpsPet[pet[i]].fight[tdpsF].t > reportPlayer.t then
        reportPlayer.t = tdpsPet[pet[i]].fight[tdpsF].t
      end
    end
    tinsert(report, reportPlayer)
  end
  sort(report, function(x, y)
    return x.n > y.n
  end)

  -- check if there is any data
  if not report[1] or report[1].n == 0 then
    echo(tdpsL.noData)
    return
  end

  -- output report title
  if tdpsF == 2 then
    SendChatMessage(format("%s %s", tdpsL.repPrefix[tdpsV], tdpsL.lastFight), channel, nil, destination)
  else
    SendChatMessage(format("%s %s", tdpsL.repPrefix[tdpsV], tdpsFight[tdpsF].name or "?"), channel, nil, destination)
  end

  -- output the text lines
  for i = 1, math.min(#report, tdpsReportLength) do
    if report[i].n > 0 then
      SendChatMessage(format("%i. %s    %i    %i%%    (%i)", i, report[i].name, report[i].n, report[i].n /
      tdpsFight[tdpsF][tdpsV] * 100, report[i].n / report[i].t), channel, nil, destination)
    end
  end
end

local function visibilityEvent()
  if (tdps.hidePvP and isPvPZone())
  or (tdps.hideSolo and not IsInGroup())
  or (tdps.hideOOC and not UnitAffectingCombat("player"))
  or (tdps.hideIC and UnitAffectingCombat("player")) then
    tdpsFrame:Hide()
  else
    tdpsFrame:Show()
    tdpsRefresh()
  end
end

local function deleteSpellData()
  for _, v in pairs(tdpsPlayer) do
    for i = 1, #v.fight do
      v.fight[i].ds, v.fight[i].hs = {}, {}
    end
  end
  for _, v in pairs(tdpsPet) do
    for i = 1, #v.fight do
      v.fight[i].ds, v.fight[i].hs = {}, {}
    end
  end
  collectgarbage()
end

local function short(n)
  if n > 999999 then
    return format("%.1fM", n / 1000000)
  elseif n > 9999 then
    return format("%.0fK", n / 1000)
  elseif n > 999 then
    return format("%.1fK", n / 1000)
  else
    return format("%i", n)
  end
end

local textLayout = {
  -- bits: 8 = dps, 4 = percentage, 2 = amount, 1 = short format. Example: 13 = 1101 = percentage and dps (short)
  [0] = function(i, n, t)
    bar[i].fontStringRight:SetText("")
  end,
  [1] = function(i, n, t)
    bar[i].fontStringRight:SetText("")
  end,
  [2] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i", n)
  end,
  [3] = function(i, n, t)
    bar[i].fontStringRight:SetText(short(n))
  end,
  [4] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i%%", n / tdpsFight[tdpsF][tdpsV] * 100)
  end,
  [5] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i%%", n / tdpsFight[tdpsF][tdpsV] * 100)
  end,
  [6] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i%% %i", n / tdpsFight[tdpsF][tdpsV] * 100, n / t)
  end,
  [7] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%s %i%%", short(n), n / tdpsFight[tdpsF][tdpsV] * 100)
  end,
  [8] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i", n / t)
  end,
  [9] = function(i, n, t)
    bar[i].fontStringRight:SetText(short(n / t))
  end,
  [10] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i %i", n, n / t)
  end,
  [11] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%s %s", short(n), short(n / t))
  end,
  [12] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i%% %i", n / tdpsFight[tdpsF][tdpsV] * 100, n / t)
  end,
  [13] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i%% %s", n / tdpsFight[tdpsF][tdpsV] * 100, short(n / t))
  end,
  [14] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%i %i%% %i", n, n / tdpsFight[tdpsF][tdpsV] * 100, n / t)
  end,
  [15] = function(i, n, t)
    bar[i].fontStringRight:SetFormattedText("%s %i%% %s", short(n), n / tdpsFight[tdpsF][tdpsV] * 100, short(n / t))
  end
}

function tdpsRefresh()
  maxValue, barsWithValue = 0, 0
  -- amount, time, height, pet, text, guid
  local n, t, h, p, g

  -- update all bar values
  for i = 1, #bar do
    bar[i]:Hide()
    g = bar[i].guid
    n, t, p = tdpsPlayer[g].fight[tdpsF][tdpsV], tdpsPlayer[g].fight[tdpsF].t, tdpsPlayer[g].pet
    for i = 1, #p do
      n = n + tdpsPet[p[i]].fight[tdpsF][tdpsV]
      if tdpsPet[p[i]].fight[tdpsF].t > t then
        t = tdpsPet[p[i]].fight[tdpsF].t
      end
    end
    -- update bar values
    if n > 0 then
      barsWithValue = barsWithValue + 1
      if n > maxValue then
        maxValue = n
      end
      textLayout[tdps.layout](i, n, t)
    end
    bar[i].n = n
  end

  -- sort all bars
  sort(bar, function(x, y)
    return x.n > y.n
  end)

  -- layout the bars
  px = -2
  if tdpsVisibleBars == 1 then
    for i = 1, #bar do
      if bar[i].name == UnitName("player") and bar[i].n > 0 then
        bar[i]:SetMinMaxValues(0, maxValue)
        bar[i]:SetValue(bar[i].n)
        bar[i]:SetPoint("TOPLEFT", tdpsFrame, "TOPLEFT", 2, px)
        if tdps.showRank then
          bar[i].fontStringLeft:SetFormattedText("%i%s%s", i, ". ", bar[i].name)
        else
          bar[i].fontStringLeft:SetText(bar[i].name)
        end
        px = px - tdps.barHeight - tdps.spacing
        bar[i]:Show()
      end
    end
  else
    local to
    if barsWithValue < tdpsVisibleBars + scrollPos - 1 then
      to = barsWithValue
    else
      to = tdpsVisibleBars + scrollPos - 1
    end
    for i = scrollPos, to do
      bar[i]:SetWidth(tdpsFrame:GetWidth() - 4)
      bar[i]:SetMinMaxValues(0, maxValue)
      bar[i]:SetValue(bar[i].n)
      bar[i]:SetPoint("TOPLEFT", tdpsFrame, "TOPLEFT", 2, px)
      if tdps.showRank then
        bar[i].fontStringLeft:SetFormattedText("%i%s%s", i, ". ", bar[i].name)
      else
        bar[i].fontStringLeft:SetText(bar[i].name)
      end
      px = px - tdps.barHeight - tdps.spacing
      bar[i]:Show()
    end
  end

  -- set the frame height
  h = abs(px) + 2 - tdps.spacing
  if h < tdps.barHeight then
    tdpsFrame:SetHeight(tdps.barHeight + 4) noData:Show()
  else
    tdpsFrame:SetHeight(h) noData:Hide()
  end
end

--[[
local function tdpsShowStatus()
  ACTION_STATUS_FADETIME = 3
  if tdpsF == 2 then
    ActionStatus_DisplayMessage(format("%s for Current Fight", viewTitle[tdpsV]), true)
  else
    ActionStatus_DisplayMessage(format("%s for %s", viewTitle[tdpsV], tdpsFight[tdpsF].name), true)
  end
end
--]]

local function changeView(button, v)
  if tdpsV == v then
    return
  end
  tdpsV = v scrollPos = 1 CloseDropDownMenus() tdpsAnimationGroup:Play()
end

local function checkView(v)
  if tdpsV == v then
    return true
  end
end

local function changeFight(button, f)
  if tdpsF == f then
    return
  else
    tdpsF = f scrollPos = 1 CloseDropDownMenus() tdpsAnimationGroup:Play()
  end
end

local function checkFight(f)
  if tdpsF == f then
    return true
  end
end

local function changeTextLayout(button, bit)
  if band(tdps.layout, bit) > 0 then
    tdps.layout = tdps.layout - bit
  else
    tdps.layout = tdps.layout + bit
  end
  tdpsRefresh()
end

local function changeNumberOfFights(button)
  if tdpsNumberOfFights == 11 then
    tdpsNumberOfFights = 2
  else
    tdpsNumberOfFights = tdpsNumberOfFights + 1
  end
  if button then
    button:SetFormattedText(tdpsL.history, tdpsNumberOfFights - 2)
  end

  -- make or delete entries for global fight data
  while #tdpsFight > tdpsNumberOfFights do
    tremove(tdpsFight)
  end
  while #tdpsFight < tdpsNumberOfFights do
    tinsert(tdpsFight, {
      name = nil,
      boss = nil,
      d = 0,
      h = 0,
    })
  end

  -- make or delete entries for combatants data
  for _, v in pairs(tdpsPlayer) do
    while #v.fight > tdpsNumberOfFights do
      tremove(v.fight)
    end
    while #v.fight < tdpsNumberOfFights do
      tinsert(v.fight, {
        d = 0,
        ds = {},
        h = 0,
        hs = {},
        t = 0,
      })
    end
  end
  for _, v in pairs(tdpsPet) do
    while #v.fight > tdpsNumberOfFights do
      tremove(v.fight)
    end
    while #v.fight < tdpsNumberOfFights do
      tinsert(v.fight, {
        d = 0,
        ds = {},
        h = 0,
        hs = {},
        t = 0,
      })
    end
  end

  --[[ adjust the current selected fight
  example: selected fight is 5; user disables fight history; we now have only 2 fights (overall and current); the new
  selected fight has to be 2 --]]
  while not tdpsFight[tdpsF] do
    tdpsF = tdpsF - 1
  end

  -- clean up memory
  collectgarbage()
end

local function changeBarSpacing(button)
  if tdps.spacing + 1 > 8 then
    tdps.spacing = 0
  else
    tdps.spacing = tdps.spacing + 1
  end
  button:SetText(tdpsL.spacing..": "..tdps.spacing)
  tdpsRefresh()
end

local function changeBarHeight(button, d)
  if tdps.barHeight + d < 2 then
    tdps.barHeight = 2
  elseif tdps.barHeight + d > 40 then
    tdps.barHeight = 40
  else
    tdps.barHeight = tdps.barHeight + d
  end
  for i = 1, #bar do
    bar[i]:SetHeight(tdps.barHeight)
  end
  tdpsRefresh()
end

local function changeFont(button, change, arg)
  -- check arg
  if change == "font" then
    tdpsFont.name = arg
  end
  if change == "size" then
    if tdpsFont.size + arg < 4 then
      tdpsFont.size = 4
    elseif tdpsFont.size + arg > 30 then
      tdpsFont.size = 30
    else
      tdpsFont.size = tdpsFont.size + arg
    end
  end
  if change == "outline" then
    tdpsFont.outline, tdpsFont.shadow = arg, 0
  end
  if change == "shadow" then
    tdpsFont.outline, tdpsFont.shadow = "", arg
  end
  -- set the font
  noData:SetFont(tdpsFont.name, tdpsFont.size, tdpsFont.outline)
  noData:SetShadowOffset(tdpsFont.shadow, tdpsFont.shadow * -1)
  for i = 1, #bar do
    bar[i].fontStringLeft:SetFont(tdpsFont.name, tdpsFont.size, tdpsFont.outline)
    bar[i].fontStringRight:SetFont(tdpsFont.name, tdpsFont.size, tdpsFont.outline)
    bar[i].fontStringLeft:SetShadowOffset(tdpsFont.shadow, tdpsFont.shadow * -1)
    bar[i].fontStringRight:SetShadowOffset(tdpsFont.shadow, tdpsFont.shadow * -1)
  end
end

local function changeBarColor()
  if tdps.swapColor then
    for i = 1, #bar do
      bar[i]:SetStatusBarColor(cColor[tdpsPlayer[bar[i].guid].class].r, cColor[tdpsPlayer[bar[i].guid].class].g,
      cColor[tdpsPlayer[bar[i].guid].class].b, tdpsColorAlpha)
      bar[i].fontStringLeft:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
      bar[i].fontStringRight:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
    end
  else
    for i = 1, #bar do
      bar[i]:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
      bar[i].fontStringLeft:SetTextColor(cColor[tdpsPlayer[bar[i].guid].class].r,
      cColor[tdpsPlayer[bar[i].guid].class].g, cColor[tdpsPlayer[bar[i].guid].class].b, tdpsColorAlpha)
      bar[i].fontStringRight:SetTextColor(cColor[tdpsPlayer[bar[i].guid].class].r,
      cColor[tdpsPlayer[bar[i].guid].class].g, cColor[tdpsPlayer[bar[i].guid].class].b, tdpsColorAlpha)
    end
  end
end

local function changeBarBackdropColor()
  for i = 1, #bar do
    bar[i]:SetBackdropColor(tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], tdps.barbackdrop[4])
  end
end

local function startNewFight(target, GUID)
  local _, _, _, _, _, id = strsplit("-", GUID)
  tdpsStartNewFight = false
  tdpsInCombat = true
  if tdpsF ~= 1 then
    scrollPos = 1
  end

  -- insert a new fight at position 2
  if tdpsFight[2].d + tdpsFight[2].h > 0 and ((tdps.onlyBossSegments and tdpsFight[2].boss) or not
  tdps.onlyBossSegments) then
    tinsert(tdpsFight, 2, {
      name = target or "?",
      boss = isBoss[tonumber(id)],
      d = 0,
      h = 0,
    })
    tremove(tdpsFight)
    for _, v in pairs(tdpsPlayer) do
      tinsert(v.fight, 2, {
        d = 0,
        ds = {},
        h = 0,
        hs = {},
        t = 0,
      })
      tremove(v.fight)
    end
    for _, v in pairs(tdpsPet) do
      tinsert(v.fight, 2, {
        d = 0,
        ds = {},
        h = 0,
        hs = {},
        t = 0,
      })
      tremove(v.fight)
    end
  -- reset current fight
  else
    tdpsFight[2] = {
      name = target or "?",
      boss = isBoss[tonumber(id)],
      d = 0,
      h = 0,
    }
    for _, v in pairs(tdpsPlayer) do
      v.fight[2] = {
        d = 0,
        ds = {},
        h = 0,
        hs = {},
        t = 0,
      }
    end
    for _, v in pairs(tdpsPet) do
      v.fight[2] = {
        d = 0,
        ds = {},
        h = 0,
        hs = {},
        t = 0,
      }
    end
  end
end

local function checkCombat()
  if tdpsStartNewFight then
    return
  end
  if UnitAffectingCombat("player") or UnitAffectingCombat("pet") then
    tdpsInCombat = true
    return
  end
  for i = 1, GetNumGroupMembers() do
    if IsInRaid() then
      if UnitAffectingCombat(format("raid%i", i)) or UnitAffectingCombat(format("raidpet%i", i)) then
        tdpsInCombat = true
        return
      end
    else
      if UnitAffectingCombat(format("party%i", i)) or UnitAffectingCombat(format("partypet%i", i)) then
        tdpsInCombat = true
        return
      end
    end
  end
  tdpsInCombat = false
end

local function getPetOwnerName(petGUID)
  local n, s
  if petGUID == UnitGUID("pet") then
    n, s = UnitName("player")
    if s then
      return n.."-"..s
    else
      return n
    end
  else
    for i = 1, GetNumGroupMembers() do
      if IsInRaid() then
        if petGUID == UnitGUID(format("raidpet%i", i)) then
          n, s = UnitName(format("raid%i", i))
          if s then
            return n.."-"..s
          else
            return n
          end
        end
      else
        if petGUID == UnitGUID(format("partypet%i", i)) then
          n, s = UnitName(format("party%i", i))
          if s then
            return n.."-"..s
          else
            return n
          end
        end
      end
    end
  end
end

local function getPetOwnerGUID(petGUID)
  if petGUID == UnitGUID("pet") then
    return UnitGUID("player")
  else
    for i = 1, GetNumGroupMembers() do
      if IsInRaid() then
        if petGUID == UnitGUID(format("raidpet%i", i)) then
          return UnitGUID(format("raid%i", i))
        end
      else
        if petGUID == UnitGUID(format("partypet%i", i)) then
          return UnitGUID(format("party%i", i))
        end
      end
    end
  end
end

local function isPartyPet(petGUID)
  if petGUID == UnitGUID("pet") then
    return true
  else
    for i = 1, GetNumGroupMembers() do
      if IsInRaid() then
        if petGUID == UnitGUID(format("raidpet%i", i)) then
          return true
        end
      else
        if petGUID == UnitGUID(format("partypet%i", i)) then
          return true
        end
      end
    end
  end
end

local function toggleMinimapButton()
  tdps.showMinimapButton = not tdps.showMinimapButton
  if tdps.showMinimapButton then
    tdpsRefresh()
    tdpsButtonFrame:Show()
  else
    tdpsButtonFrame:Hide()
  end
end

local function ver()
  echo(tdpsL.helpVersion.." "..GetAddOnMetadata("TinyDPS", "Version").." by Sideshow (formerly) and Talyrius")
end

local function slashhelp()
  echo(tdpsL.helpParameters1)
  echo(tdpsL.helpParameters2)
end

local function help()
  ver()
  echo("- "..tdpsL.helpMove)
  echo("- "..tdpsL.helpResize)
  echo("- "..tdpsL.helpToggle)
  slashhelp()
end

local function reset()
  -- hide all bars in the GUI
  for i = 1, #bar do
    bar[i]:ClearAllPoints()
    bar[i]:Hide()
  end
  -- delete data
  tdpsPlayer, tdpsPet, tdpsLink, tdpsFight, bar = {}, {}, {}, {}, {}
  -- make new fight data
  tinsert(tdpsFight, {
    name = tdpsL.overallData,
    d = 0,
    h = 0,
  })
  while #tdpsFight < tdpsNumberOfFights do
    tinsert(tdpsFight, 2, {
      name = nil,
      boss = false,
      d = 0,
      h = 0,
    })
  end
  -- reset scroll position
  scrollPos = 1
  -- return to current fight if needed
  if tdpsF > 2 then
    tdpsF = 2
  end
  -- reset the window
  tdpsFrame:SetHeight(tdps.barHeight + 4)
  noData:Show()
  -- output message
  echo(tdpsL.allClear)
  CloseDropDownMenus()
  -- clean up memory
  collectgarbage()
end

local function toggle()
  if tdpsFrame:IsVisible() then
    CloseDropDownMenus()
    tdps.hidePvP, tdps.hideSolo, tdps.hideIC, tdps.hideOOC = true, true, true, true
    tdpsFrame:Hide()
  else
    CloseDropDownMenus()
    tdps.hidePvP, tdps.hideSolo, tdps.hideIC, tdps.hideOOC = nil, nil, nil, nil
    tdpsRefresh()
    tdpsFrame:Show()
  end
  PlaySound("gsTitleOptionExit")
end

SLASH_TINYDPS1, SLASH_TINYDPS2 = "/tinydps", "/tdps"
function SlashCmdList.TINYDPS(msg, editbox)
  local cmd, arg = strsplit(" ", strlower(msg))
  if cmd == "reset" or cmd == "r" then
    reset()
  elseif cmd == "damage" or cmd == "d" then
    changeView(nil, "d")
  elseif cmd == "healing" or cmd == "h" then
    changeView(nil, "h")
  elseif cmd == "reportlength" and tonumber(arg) then
    tdpsReportLength = min(40, max(1, tonumber(arg)))
  elseif cmd == "visiblebars" and tonumber(arg) then
    tdpsVisibleBars = min(40, max(1, tonumber(arg))) scrollPos = 1 tdpsRefresh()
  elseif cmd == "whisper" and arg then
    report(nil, "WHISPER", arg)
  elseif cmd == "help" or cmd == "?" then
    help()
  elseif cmd == "" then
    toggle()
  else
    slashhelp()
  end
end

local function scroll(d)
  if bar[1] and bar[1].n > 0 and scrollPos - d > 0 and scrollPos - d + tdpsVisibleBars <= barsWithValue + 1 and
  tdpsVisibleBars > 1 then
    scrollPos = scrollPos - d
    tdpsRefresh()
  end
end

-- function for adding buttons in the context menu
local function newBu(...)
  --[[ level, text, title, notCheckable, hasArrow, value, keepShownOnClick, func, arg1, arg2, checked, disabled,
  isNotRadio, hasColorSwatch, swatchFunc, hasOpacity, opacityFunc, r, g, b, opacity, notClickable --]]
  level, bu.text, bu.isTitle, bu.notCheckable, bu.hasArrow, bu.value, bu.keepShownOnClick, bu.func, bu.arg1, bu.arg2,
  bu.checked, bu.disabled, bu.isNotRadio, bu.hasColorSwatch, bu.swatchFunc, bu.hasOpacity, bu.opacityFunc, bu.r, bu.g,
  bu.b, bu.opacity, bu.notClickable = ...
  UIDropDownMenu_AddButton(bu, level)
  wipe(bu)
end

tdpsDropDown.initialize = function(self, level)
  if level == 1 then
    PlaySound("gsTitleOptionExit")
    newBu(level, "TinyDPS       ", 1, 1)
    newBu(level, tdpsL.fight, nil, 1, 1, "fight", 1)
    newBu(level, tdpsL.report, nil, 1, 1, "report", 1)
    newBu(level, tdpsL.options, nil, 1, 1, "options", 1)
    newBu(level, tdpsL.close, nil, 1)
  elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == "fight" then
    newBu(level, tdpsL.allFight, nil, nil, nil, nil, nil, changeFight, 1, nil, checkFight(1))
    newBu(level, tdpsL.current.."    "..(tdpsFight[2].name or tdpsL.empty), nil, nil, nil, nil, nil, changeFight, 2,
    nil, checkFight(2))
    if tdpsNumberOfFights > 2 then
      newBu(level, "", nil, 1, nil, nil, nil, nil, nil, nil, nil, 1)
    end
    for i = 3, tdpsNumberOfFights do
      newBu(level, format("%s %i     %s", tdpsL.fight, i - 2, (tdpsFight[i].name or tdpsL.empty)), nil, nil, nil, nil,
      nil, changeFight, i, nil, checkFight(i))
    end
    newBu(level, "", nil, 1, nil, nil, nil, nil, nil, nil, nil, 1)
    newBu(level, tdpsL.showDamage, nil, nil, nil, nil, nil, changeView, "d", nil, checkView("d"))
    newBu(level, tdpsL.showHealing, nil, nil, nil, nil, nil, changeView, "h", nil, checkView("h"))
    newBu(level, "", nil, 1, nil, nil, nil, nil, nil, nil, nil, 1)
    newBu(level, "     "..tdpsL.resetAllData, nil, 1, nil, nil, nil, reset)
  elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == "report" then
    newBu(level, tdpsL.say, nil, 1, nil, nil, nil, report, "SAY")
    newBu(level, tdpsL.instance, nil, 1, nil, nil, nil, report, "INSTANCE_CHAT")
    newBu(level, tdpsL.raid, nil, 1, nil, nil, nil, report, "RAID")
    newBu(level, tdpsL.party, nil, 1, nil, nil, nil, report, "PARTY")
    newBu(level, tdpsL.guild, nil, 1, nil, nil, nil, report, "GUILD")
    newBu(level, tdpsL.officer, nil, 1, nil, nil, nil, report, "OFFICER")
    newBu(level, tdpsL.whisper, nil, 1, nil, nil, nil, report, "WHISPER")
    newBu(level, tdpsL.whisper2, nil, 1, nil, nil, nil, function()
      ChatEdit_ActivateChat(DEFAULT_CHAT_FRAME.editBox)
      DEFAULT_CHAT_FRAME.editBox:SetText("/tdps whisper ")
    end)
    for i = 1, 20 do
      local _, name = GetChannelName(i)
      if name then
        newBu(level, name.."     ", nil, 1, nil, nil, nil, report, i)
      end
    end
    newBu(level, "", nil, 1, nil, nil, nil, nil, nil, nil, nil, 1)
    newBu(level, "Report Length: "..tdpsReportLength, nil, 1, nil, nil, nil, function()
      ChatEdit_ActivateChat(DEFAULT_CHAT_FRAME.editBox)
      DEFAULT_CHAT_FRAME.editBox:SetText("/tdps reportlength "..tdpsReportLength)
    end)
  elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == "options" then
    newBu(level, tdpsL.text, nil, 1, 1, "text", 1)
    newBu(level, tdpsL.bars, nil, 1, 1, "bars", 1)
    newBu(level, tdpsL.colors, nil, 1, 1, "colors", 1)
    newBu(level, tdpsL.various, nil, 1, 1, "various", 1)
  elseif level == 3 and UIDROPDOWNMENU_MENU_VALUE == "text" then
    newBu(level, tdpsL.size, nil, 1, 1, "size", 1)
    newBu(level, tdpsL.font, nil, 1, 1, "font", 1)
    newBu(level, tdpsL.layout, nil, 1, 1, "layout", 1)
    newBu(level, tdpsL.outline, nil, 1, 1, "outline", 1)
    newBu(level, format(tdpsL.nudge, tdpsTextOffset), nil, 1, nil, nil, 1, nudgeText)
  elseif level == 3 and UIDROPDOWNMENU_MENU_VALUE == "bars" then
    newBu(level, tdpsL.height, nil, 1, 1, "height", 1)
    newBu(level, tdpsL.spacing..": "..tdps.spacing, nil, 1, nil, nil, 1, changeBarSpacing)
    newBu(level, tdpsL.maximum..": "..tdpsVisibleBars, nil, 1, nil, nil, nil, function()
      ChatEdit_ActivateChat(DEFAULT_CHAT_FRAME.editBox)
      DEFAULT_CHAT_FRAME.editBox:SetText("/tdps visiblebars "..tdpsVisibleBars)
    end)
  elseif level == 3 and UIDROPDOWNMENU_MENU_VALUE == "colors" then
    local st
    if tdps.swapColor then
      st = tdpsL.text
    else
      st = tdpsL.bars
    end
    newBu(level, st, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, function()
      ColorPickerOkayButton:Hide()
      ColorPickerCancelButton:SetText("Close")
      local red, green, blue = ColorPickerFrame:GetColorRGB()
      local alpha = 1 - OpacitySliderFrame:GetValue()
      tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4] = red, green, blue, alpha
      changeBarColor()
    end, 1, function()
      local red, green, blue = ColorPickerFrame:GetColorRGB()
      local alpha = 1 - OpacitySliderFrame:GetValue()
      tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4] = red, green, blue, alpha
      changeBarColor()
    end, tdps.bar[1], tdps.bar[2], tdps.bar[3], 1 - tdps.bar[4], 1)
    newBu(level, tdpsL.barBackdrop, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, function()
      ColorPickerOkayButton:Hide()
      ColorPickerCancelButton:SetText("Close")
      local red, green, blue = ColorPickerFrame:GetColorRGB()
      local alpha = 1 - OpacitySliderFrame:GetValue()
      tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], tdps.barbackdrop[4] = red, green, blue, alpha
      changeBarBackdropColor()
    end, 1, function()
      local red, green, blue = ColorPickerFrame:GetColorRGB()
      local alpha = 1 - OpacitySliderFrame:GetValue()
      tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], tdps.barbackdrop[4] = red, green, blue, alpha
      changeBarBackdropColor()
    end, tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], 1 - tdps.barbackdrop[4], 1)
    newBu(level, tdpsL.frameBorder, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, function()
      ColorPickerOkayButton:Hide()
      ColorPickerCancelButton:SetText("Close")
      local red, green, blue = ColorPickerFrame:GetColorRGB()
      local alpha = 1 - OpacitySliderFrame:GetValue()
      tdpsFrame:SetBackdropBorderColor(red, green, blue, alpha)
      tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4] = red, green, blue, alpha
    end, 1, function()
      local red, green, blue = ColorPickerFrame:GetColorRGB()
      local alpha = 1 - OpacitySliderFrame:GetValue()
      tdpsFrame:SetBackdropBorderColor(red, green, blue, alpha)
      tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4] = red, green, blue, alpha
    end, tdps.border[1], tdps.border[2], tdps.border[3], 1 - tdps.border[4], 1)
    newBu(level, tdpsL.frameBackdrop, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, function()
      ColorPickerOkayButton:Hide()
      ColorPickerCancelButton:SetText("Close")
      local red, green, blue = ColorPickerFrame:GetColorRGB()
      local alpha = 1 - OpacitySliderFrame:GetValue()
      tdpsFrame:SetBackdropColor(red, green, blue, alpha)
      tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4] = red, green, blue, alpha
    end, 1, function()
      local red, green, blue = ColorPickerFrame:GetColorRGB()
      local alpha = 1 - OpacitySliderFrame:GetValue()
      tdpsFrame:SetBackdropColor(red, green, blue, alpha)
      tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4] = red, green, blue, alpha
    end, tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], 1 - tdps.backdrop[4], 1)
    newBu(level, tdpsL.dimClassColors, nil, 1, nil, nil, 1, function()
      if tdpsColorAlpha - .1 < 0 then
        tdpsColorAlpha = 0
      else
        tdpsColorAlpha = tdpsColorAlpha - .1
      end
      changeBarColor()
    end)
    newBu(level, tdpsL.resetClassColors, nil, 1, nil, nil, 1, function()
      tdpsColorAlpha = 1
      changeBarColor()
    end)
    newBu(level, tdpsL.swapBarTextColor.."     ", nil, 1, nil, nil, 1, function()
      tdps.swapColor = not tdps.swapColor
      if tdps.swapColor then
        DropDownList3Button1:SetText(tdpsL.text)
      else
        DropDownList3Button1:SetText(tdpsL.bars)
      end
      changeBarColor()
    end)
  elseif level == 3 and UIDROPDOWNMENU_MENU_VALUE == "various" then
    newBu(level, tdpsL.hideInPvP, nil, nil, nil, nil, 1, function()
      tdps.hidePvP = not tdps.hidePvP
      visibilityEvent()
    end, nil, nil, tdps.hidePvP, nil, 1)
    newBu(level, tdpsL.hideWhenSolo, nil, nil, nil, nil, 1, function()
      tdps.hideSolo = not tdps.hideSolo
      visibilityEvent()
    end, nil, nil, tdps.hideSolo, nil, 1)
    newBu(level, tdpsL.hideInCombat, nil, nil, nil, nil, 1, function(self)
      tdps.hideIC = not tdps.hideIC
      if tdps.hideIC and tdps.hideOOC then
        _G[gsub(self:GetName(), "%d$", strmatch(self:GetName(), "%d$") + 1)]:Click()
      end
      visibilityEvent()
    end, nil, nil, tdps.hideIC, nil, 1)
    newBu(level, tdpsL.hideOutOfCombat, nil, nil, nil, nil, 1, function(self)
      tdps.hideOOC = not tdps.hideOOC
      if tdps.hideOOC and tdps.hideIC then
        _G[gsub(self:GetName(), "%d$", strmatch(self:GetName(), "%d$") - 1)]:Click()
      end
      visibilityEvent()
    end, nil, nil, tdps.hideOOC, nil, 1)
    newBu(level, "", nil, 1, nil, nil, nil, nil, nil, nil, nil, 1)
    newBu(level, tdpsL.growUpwards, nil, nil, nil, nil, 1, function()
      if tdps.anchor == "TOPLEFT" then
        tdps.anchor = "BOTTOMLEFT"
      else
        tdps.anchor = "TOPLEFT"
      end
      tdpsFrame:ClearAllPoints()
      tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor)
    end, nil, nil, function()
      if tdps.anchor == "BOTTOMLEFT" then
        return true
      end
    end, nil, 1)
    newBu(level, tdpsL.minimapButton, nil, nil, nil, nil, 1, toggleMinimapButton, nil, nil, tdps.showMinimapButton, nil,
    1)
    newBu(level, tdpsL.resetOnNewGroup, nil, nil, nil, nil, 1, function()
      tdps.autoReset = not tdps.autoReset
    end, nil, nil, tdps.autoReset, nil, 1)
    newBu(level, tdpsL.refreshEverySecond, nil, nil, nil, nil, 1, function()
      if tdps.speed == 2 then
        tdps.speed = 1
      else
        tdps.speed = 2
      end
    end, nil, nil, function()
      if tdps.speed == 1 then
        return true
      end
    end, nil, 1)
    newBu(level, "", nil, 1, nil, nil, nil, nil, nil, nil, nil, 1)
    newBu(level, tdpsL.trackSpellDetails, nil, nil, nil, nil, 1, function()
      tdps.trackSpells = not tdps.trackSpells
      if not tdps.trackSpells then
        deleteSpellData()
      end
    end, nil, nil, tdps.trackSpells, nil, 1)
    newBu(level, format(tdpsL.spells, tdps.tooltipSpells), nil, 1, nil, nil, 1, function()
      if tdps.tooltipSpells == 10 then
        tdps.tooltipSpells = 0
      else
        tdps.tooltipSpells = tdps.tooltipSpells + 1
      end
      DropDownList3Button12:SetFormattedText(tdpsL.spells, tdps.tooltipSpells)
    end)
    newBu(level, format(tdpsL.targets, tdps.tooltipTargets), nil, 1, nil, nil, 1, function()
      if tdps.tooltipTargets == 10 then
        tdps.tooltipTargets = 0
      else
        tdps.tooltipTargets = tdps.tooltipTargets + 1
      end
      DropDownList3Button13:SetFormattedText(tdpsL.targets, tdps.tooltipTargets)
    end)
    newBu(level, "", nil, 1, nil, nil, nil, nil, nil, nil, nil, 1)
    newBu(level, tdpsL.keepOnlyBossFights, nil, nil, nil, nil, 1, function()
      tdps.onlyBossSegments = not tdps.onlyBossSegments
    end, nil, nil, tdps.onlyBossSegments, nil, 1)
    newBu(level, format(tdpsL.history, tdpsNumberOfFights - 2), nil, 1, nil, nil, 1, changeNumberOfFights)
  elseif level == 4 and UIDROPDOWNMENU_MENU_VALUE == "size" then
    newBu(level, tdpsL.increase, nil, 1, nil, nil, 1, changeFont, "size", 1)
    newBu(level, tdpsL.decrease, nil, 1, nil, nil, 1, changeFont, "size", -1)
  elseif level == 4 and UIDROPDOWNMENU_MENU_VALUE == "font" then
    if GetLocale() == "koKR" then
      newBu(level, "굵은 글꼴", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\2002B.TTF]], function()
        if tdpsFont.name == [[Fonts\2002B.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "기본 글꼴", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\2002.TTF]], function()
        if tdpsFont.name == [[Fonts\2002.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "데미지 글꼴", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\K_Damage.TTF]], function()
        if tdpsFont.name == [[Fonts\K_Damage.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "퀘스트 글꼴", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\K_Pagetext.TTF]], function()
        if tdpsFont.name == [[Fonts\K_Pagetext.TTF]] then
          return true
        end
      end, nil, nil)
    elseif GetLocale() == "zhCN" then
      newBu(level, "默认", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\ZYKai_T.TTF]], function()
        if tdpsFont.name == [[Fonts\ZYKai_T.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "聊天", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\ZYHei.TTF]], function()
        if tdpsFont.name == [[Fonts\ZYHei.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "伤害数字", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\ZYKai_C.TTF]], function()
        if tdpsFont.name == [[Fonts\ZYKai_C.TTF]] then
          return true
        end
      end, nil, nil)
    elseif GetLocale() == "zhTW" then
      newBu(level, "預設", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\bLEI00D.TTF]], function()
        if tdpsFont.name == [[Fonts\bLEI00D.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "聊天", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\bHEI01B.TTF]], function()
        if tdpsFont.name == [[Fonts\bHEI01B.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "傷害數字", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\bKAI00M.TTF]], function()
        if tdpsFont.name == [[Fonts\bKAI00M.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "提示訊息", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\bHEI00M.TTF]], function()
        if tdpsFont.name == [[Fonts\bHEI00M.TTF]] then
          return true
        end
      end, nil, nil)
    else
      newBu(level, "Skurri", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\SKURRI.TTF]], function()
        if tdpsFont.name == [[Fonts\SKURRI.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "Visitor", nil, nil, nil, nil, nil, changeFont, "font",
      [[Interface\AddOns\TinyDPS\Fonts\visitor.ttf]], function()
        if tdpsFont.name == [[Interface\AddOns\TinyDPS\Fonts\visitor.ttf]] then
          return true
        end
      end, nil, nil)
      newBu(level, "Morpheus", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\MORPHEUS.TTF]], function()
        if tdpsFont.name == [[Fonts\MORPHEUS.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "Arial Narrow", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\ARIALN.TTF]], function()
        if tdpsFont.name == [[Fonts\ARIALN.TTF]] then
          return true
        end
      end, nil, nil)
      newBu(level, "Friz Quadrata TT", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\FRIZQT__.TTF]], function()
        if tdpsFont.name == [[Fonts\FRIZQT__.TTF]] then
          return true
        end
      end, nil, nil)
    end

    if GetLocale() == "ruRU" then
      newBu(level, "Nimrod MT", nil, nil, nil, nil, nil, changeFont, "font", [[Fonts\NIM_____.TTF]], function()
        if tdpsFont.name == [[Fonts\NIM_____.TTF]] then
          return true
        end
      end, nil, nil)
    end

    newBu(level, "Custom", nil, nil, nil, nil, nil, changeFont, "font", [[Interface\AddOns\TinyDPS\Fonts\custom.ttf]],
    function()
      if tdpsFont.name == [[Interface\AddOns\TinyDPS\Fonts\custom.ttf]] then
        return true
      end
    end, nil, nil)
  elseif level == 4 and UIDROPDOWNMENU_MENU_VALUE == "layout" then
    newBu(level, tdpsL.dps, nil, nil, nil, nil, 1, changeTextLayout, 8, nil, function()
      if band(tdps.layout, 8) > 0 then
        return true
      end
    end, nil, 1)
    newBu(level, tdpsL.rank, nil, nil, nil, nil, 1, function()
      tdps.showRank = not
      tdps.showRank
      tdpsRefresh()
    end, nil, nil, tdps.showRank, nil, 1)
    newBu(level, tdpsL.percent, nil, nil, nil, nil, 1, changeTextLayout, 4, nil, function()
      if band(tdps.layout, 4) > 0 then
        return true
      end
    end, nil, 1)
    newBu(level, tdpsL.amount, nil, nil, nil, nil, 1, changeTextLayout, 2, nil, function()
      if band(tdps.layout, 2) > 0 then
        return true
      end
    end, nil, 1)
    newBu(level, tdpsL.short, nil, nil, nil, nil, 1, changeTextLayout, 1, nil, function()
      if band(tdps.layout, 1) > 0 then
        return true
      end
    end, nil, 1)
  elseif level == 4 and UIDROPDOWNMENU_MENU_VALUE == "outline" then
    newBu(level, tdpsL.none, nil, nil, nil, nil, nil, changeFont, "outline", "", function()
      if tdpsFont.outline == "" and tdpsFont.shadow == 0 then
        return true
      end
    end)
    newBu(level, tdpsL.thin, nil, nil, nil, nil, nil, changeFont, "outline", "OUTLINE", function()
      if tdpsFont.outline == "OUTLINE" and tdpsFont.shadow == 0 then
        return true
      end
    end)
    newBu(level, tdpsL.thick, nil, nil, nil, nil, nil, changeFont, "outline", "THICKOUTLINE", function()
      if tdpsFont.outline == "THICKOUTLINE" and tdpsFont.shadow == 0 then
        return true
      end
    end)
    newBu(level, tdpsL.shadow, nil, nil, nil, nil, nil, changeFont, "shadow", 1, function()
      if tdpsFont.outline == "" and tdpsFont.shadow > 0 then
        return true
      end
    end)
    newBu(level, tdpsL.mono, nil, nil, nil, nil, nil, changeFont, "outline", "OUTLINE, MONOCHROME", function()
      if tdpsFont.outline == "OUTLINE, MONOCHROME" and tdpsFont.shadow == 0 then
        return true
      end
    end)
  elseif level == 4 and UIDROPDOWNMENU_MENU_VALUE == "height" then
    newBu(level, tdpsL.increase, nil, 1, nil, nil, 1, changeBarHeight, 1)
    newBu(level, tdpsL.decrease, nil, 1, nil, nil, 1, changeBarHeight, -1)
  elseif level == 4 and UIDROPDOWNMENU_MENU_VALUE == "spacing" then
    newBu(level, tdpsL.increase, nil, 1, nil, nil, 1, changeBarSpacing, 1)
    newBu(level, tdpsL.decrease, nil, 1, nil, nil, 1, changeBarSpacing, -1)
  end
end

local function tdpsSpellSort(x, y)
  if ttSpellMerge[x] > ttSpellMerge[y] then
    return true
  end
end

local function tdpsMobSort(x, y)
  if ttMobMerge[x] > ttMobMerge[y] then
    return true
  end
end

local function newBar(g)
  local dummybar = CreateFrame("Statusbar", "tdpsStatusBar", tdpsFrame)
  dummybar:SetFrameStrata("MEDIUM")
  dummybar:SetFrameLevel(2)
  dummybar:SetOrientation("HORIZONTAL")
  dummybar:EnableMouse(true)
  dummybar:EnableMouseWheel(true)
  dummybar:SetWidth(tdpsFrame:GetWidth() - 4)
  dummybar:SetHeight(tdps.barHeight)
  dummybar:Hide()
  --dummybar:SetPoint("RIGHT", tdpsFrame, "RIGHT", -2, 0)
  dummybar:SetBackdrop({
    bgFile = [[Interface\AddOns\TinyDPS\Textures\wglass.tga]],
    edgeFile = [[Interface\AddOns\TinyDPS\Textures\blank.tga]],
    tile = false,
    tileSize = 1,
    edgeSize = 1,
    insets = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
    }
  })
  dummybar:SetStatusBarTexture([[Interface\AddOns\TinyDPS\Textures\wglass.tga]])

  -- bar info
  dummybar.name, dummybar.guid, dummybar.n = strsplit("-", tdpsPlayer[g]["name"]), g, 0

  -- scripts
  dummybar:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self)
    GameTooltip:SetText(tdpsPlayer[g].name)

    -- tooltip title
    if tdpsF == 2 then
      GameTooltip:AddLine(format("%s %s", tdpsL.tipPrefix[tdpsV], tdpsL.currentFight), 1, .85, 0)
    else
      GameTooltip:AddLine(format("%s %s", tdpsL.tipPrefix[tdpsV], tdpsFight[tdpsF].name or "?"), 1, .85, 0)
    end

    -- own amount
    GameTooltip:AddDoubleLine(tdpsL.personal, tdpsPlayer[self.guid].fight[tdpsF][tdpsV].." (" ..
    round(tdpsPlayer[self.guid].fight[tdpsF][tdpsV] / (self.n) * 100, 0).."%)", 1, 1, 1, 1, 1, 1)

    -- pet amount
    local pet, petAmount = tdpsPlayer[g].pet, 0
    for i = 1, #pet do
      petAmount = petAmount + tdpsPet[pet[i]].fight[tdpsF][tdpsV]
    end
    if petAmount > 0 then
      GameTooltip:AddDoubleLine(tdpsL.byPets, petAmount.." ("..round(petAmount / (self.n) * 100, 0).."%)", 1, 1, 1, 1,
      1, 1)
    end

    -- spell details
    if tdps.trackSpells then
      -- merge the data of this player
      for k, v in pairs(tdpsPlayer[g].fight[tdpsF][tdpsV.."s"]) do
        for kk, vv in pairs(v) do
          ttSpellMerge[k] = (ttSpellMerge[k] or 0) + vv ttMobMerge[kk] = (ttMobMerge[kk] or 0) + vv
        end
      end
      for i = 1, #pet do
        for k, v in pairs(tdpsPet[pet[i]].fight[tdpsF][tdpsV.."s"]) do
          for kk, vv in pairs(v) do
            ttSpellMerge[k] = (ttSpellMerge[k] or 0) + vv ttMobMerge[kk] = (ttMobMerge[kk] or 0) + vv
          end
        end
      end

      -- display spells
      if tdps.tooltipSpells > 0 then
        GameTooltip:AddLine(tdpsL.topAbilities, 1, .85, 0)
      end
      for k, v in pairs(ttSpellMerge) do
        tinsert(ttSort, k)
      end
      sort(ttSort, tdpsSpellSort)
      for i = 1, tdps.tooltipSpells do
        if ttSort[i] then
          GameTooltip:AddDoubleLine(i..". "..ttSort[i], ttSpellMerge[ttSort[i]].." (" ..
          round(ttSpellMerge[ttSort[i]] / (self.n) * 100, 0).."%)", 1, 1, 1, 1, 1, 1)
        end
      end
      wipe(ttSort)

      -- display targets
      if tdps.tooltipTargets > 0 then
        GameTooltip:AddLine(tdpsL.topTargets, 1, .85, 0)
      end
      for k, v in pairs(ttMobMerge) do
        tinsert(ttSort, k)
      end
      sort(ttSort, tdpsMobSort)
      for i = 1, tdps.tooltipTargets do
        if ttSort[i] then
          GameTooltip:AddDoubleLine(i..". "..ttSort[i], ttMobMerge[ttSort[i]].." ("..round(ttMobMerge[ttSort[i]] /
          (self.n) * 100, 0).."%)", 1, 1, 1, 1, 1, 1)
        end
      end
      wipe(ttSort)
      wipe(ttSpellMerge)
      wipe(ttMobMerge)
    end

    -- display the tooltip
    GameTooltip:Show()
  end)

  dummybar:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  dummybar:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" and IsShiftKeyDown() then
      CloseDropDownMenus()
      GameTooltip:Hide()
      isMovingOrSizing = true
      tdpsAnchor:StartMoving()
    elseif button == "RightButton" then
      ToggleDropDownMenu(1, nil, tdpsDropDown, "cursor", 0, 0)
    elseif button == "MiddleButton" then
      reset()
    elseif button == "Button4" then
      changeFight(nil, 1)
    elseif button == "Button5" then
      changeFight(nil, 2)
    end
  end)

  dummybar:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
      tdpsAnchor:StopMovingOrSizing()
      isMovingOrSizing = nil
      -- set position of frame
      tdpsFrame:ClearAllPoints()
      tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor, 0, 0)
      -- save position of anchor
      local xOfs, yOfs = tdpsAnchor:GetCenter()
      local scale = tdpsAnchor:GetEffectiveScale()
      local uis = UIParent:GetScale()
      xOfs = xOfs * scale - GetScreenWidth() * uis / 2
      yOfs = yOfs * scale - GetScreenHeight() * uis / 2
      tdpsPosition.x = xOfs / uis
      tdpsPosition.y = yOfs / uis
    end
  end)

  dummybar:SetScript("OnMouseWheel", function(self, direction)
    scroll(direction)
  end)

  -- number fontstring
  dummybar.fontStringRight = dummybar:CreateFontString(nil, "OVERLAY")
  dummybar.fontStringRight:SetPoint("RIGHT", -1, tdpsTextOffset)
  dummybar.fontStringRight:SetJustifyH("RIGHT")
  dummybar.fontStringRight:SetFont(tdpsFont.name, tdpsFont.size, tdpsFont.outline)
  dummybar.fontStringRight:SetShadowColor(.05, .05, .05, 1)
  dummybar.fontStringRight:SetShadowOffset(tdpsFont.shadow, tdpsFont.shadow * -1)

  -- name fontstring
  dummybar.fontStringLeft = dummybar:CreateFontString(nil, "OVERLAY")
  dummybar.fontStringLeft:SetPoint("LEFT", 1, tdpsTextOffset)
  dummybar.fontStringLeft:SetPoint("RIGHT", dummybar.fontStringRight, "LEFT", -2, 1)
  dummybar.fontStringLeft:SetJustifyH("LEFT")
  dummybar.fontStringLeft:SetFont(tdpsFont.name, tdpsFont.size, tdpsFont.outline)
  dummybar.fontStringLeft:SetShadowColor(.05, .05, .05, 1)
  dummybar.fontStringLeft:SetShadowOffset(tdpsFont.shadow, tdpsFont.shadow * -1)

  -- colors
  local classR, classG, classB, classA = cColor[tdpsPlayer[g].class].r, cColor[tdpsPlayer[g].class].g,
  cColor[tdpsPlayer[g].class].b, tdpsColorAlpha
  if tdps.swapColor then
    dummybar:SetStatusBarColor(classR, classG, classB, classA)
    dummybar.fontStringRight:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
    dummybar.fontStringLeft:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
  else
    dummybar:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
    dummybar.fontStringRight:SetTextColor(classR, classG, classB, classA)
    dummybar.fontStringLeft:SetTextColor(classR, classG, classB, classA)
  end
  dummybar:SetBackdropColor(tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], tdps.barbackdrop[4])
  dummybar:SetBackdropBorderColor(0, 0, 0, 0)

  -- save bar
  tinsert(bar, dummybar)
end

local function makeCombatant(k, n, pgl, c)
  if c == "PET" then
    tdpsPet[k] = {
      name = n,
      guid = pgl,
      class = c,
      stamp = 0,
      fight = {},
    }
    while #tdpsPet[k].fight < tdpsNumberOfFights do
      tinsert(tdpsPet[k].fight, {
        d = 0,
        ds = {},
        h = 0,
        hs = {},
        t = 0,
      })
    end
  else
    tdpsPlayer[k] = {
      name = n,
      pet = pgl,
      class = c,
      stamp = 0,
      fight = {},
    }
    while #tdpsPlayer[k].fight < tdpsNumberOfFights do
      tinsert(tdpsPlayer[k].fight, {
        d = 0,
        ds = {},
        h = 0,
        hs = {},
        t = 0,
      })
    end
    newBar(k)
  end
end

local function trackSpell(amount, target, spell, dh)
  if tdps.trackSpells then
    dh = dh.."s"
    if not com.fight[1][dh][spell] then
      -- make the spell
      com.fight[1][dh][spell] = {}
    end
    if not com.fight[2][dh][spell] then
      com.fight[2][dh][spell] = {}
    end
    -- record the amount
    com.fight[1][dh][spell][target] = (com.fight[1][dh][spell][target] or 0) + amount
    com.fight[2][dh][spell][target] = (com.fight[2][dh][spell][target] or 0) + amount
  end
end

------------------------------------------------------------------------------------------------------------------------
-- Combat Event Handler --
------------------------------------------------------------------------------------------------------------------------

local function tdpsCombatEvent(self, event, ...)
  local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName,
  destFlags, destRaidFlags, arg12, arg13, arg14, arg15, arg16 = ...

  -- return when source is an outsider
  if sourceFlags % 8 == 0 then
    return
  end
  -- give units a name if they don't have one to prevent errors
  if not destName then
    destName = NONE
  end

  -- track absorbs
  if event == "SPELL_AURA_APPLIED" and destFlags % 8 > 0 and isAbsorb[arg12] then
  tdpsShield[sourceGUID..arg12..destGUID] = arg16
    return
  elseif event == "SPELL_AURA_REFRESH" and destFlags % 8 > 0 and isAbsorb[arg12] and
  tdpsShield[sourceGUID..arg12..destGUID] then
    -- launch a fake healing event
    if tdpsShield[sourceGUID..arg12..destGUID] - arg16 > 0 then
      tdpsCombatEvent(self, event, timestamp, "SPELL_HEAL", hideCaster, sourceGUID, sourceName, sourceFlags,
      sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg12, arg13, arg14,
      tdpsShield[sourceGUID..arg12..destGUID] - arg16, 0)
    end
    -- add the new value to the shield
    tdpsShield[sourceGUID..arg12..destGUID] = arg16
    return
  elseif event == "SPELL_AURA_REMOVED" and destFlags % 8 > 0 and isAbsorb[arg12] and
  tdpsShield[sourceGUID..arg12..destGUID] then
    -- launch a fake healing event
    if tdpsShield[sourceGUID..arg12..destGUID] - arg16 > 0 then
      tdpsCombatEvent(self, event, timestamp, "SPELL_HEAL", hideCaster, sourceGUID, sourceName, sourceFlags,
      sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg12, arg13, arg14,
      tdpsShield[sourceGUID..arg12..destGUID] - arg16, 0)
    end
    -- delete the shield
    tdpsShield[sourceGUID..arg12..destGUID] = nil
    return
  end

  -- return on invalid event, vehicle, friendly fire, hostile healing, evaded
  if not isValidEvent[event] or strsplit("-", sourceGUID) == "Vehicle" or (band(destFlags, 16) > 0 and isDamage[event])
  or (band(destFlags, 16) == 0 and isHeal[event]) or arg15 == "EVADE" then
    return
  end

  -- create summoned pets
  if event == "SPELL_SUMMON" then
    -- add pet when player summons
    local _, _, _, _, _, id = strsplit("-", destGUID)
    if UnitIsPlayer(sourceName) and not isExcludedPet[tonumber(id)] then
      -- make owner if necessary
      if not tdpsPlayer[sourceGUID] then
        makeCombatant(sourceGUID, sourceName, {sourceName..": "..destName}, getClass(sourceName))
      end
      -- make pointer
      tdpsLink[destGUID] = sourceName..": "..destName
      -- make pet if it does not exist yet
      if not tdpsPet[sourceName..": "..destName] then
        makeCombatant(sourceName..": "..destName, destName, destGUID, "PET")
      end
      -- add pet to owner if it's not there yet
      local found = false
      for i = 1, #tdpsPlayer[sourceGUID].pet do
        if tdpsPlayer[sourceGUID].pet[i] == sourceName..": "..destName then
          found = true
          break
        end
      end
      if not found then
        tinsert(tdpsPlayer[sourceGUID].pet, sourceName..": "..destName)
      end
    -- the summoner is also a pet (example: totems can summon elementals)
    elseif tdpsLink[sourceGUID] then
      -- owner's owner name
      local ownersOwnerName = strsplit(":", tdpsLink[sourceGUID])
      -- make pointer
      tdpsLink[destGUID] = ownersOwnerName..": "..destName
      -- make pet
      makeCombatant(ownersOwnerName..": "..destName, destName, destGUID, "PET")
      -- add pet to owner if it's not there yet
      local found = false
      for i = 1, #tdpsPlayer[UnitGUID(ownersOwnerName)].pet do
        if tdpsPlayer[UnitGUID(ownersOwnerName)].pet[i] == ownersOwnerName..": "..destName then
          found = true
          break
        end
      end
      if not found then
        tinsert(tdpsPlayer[UnitGUID(ownersOwnerName)].pet, ownersOwnerName..": "..destName)
      end
    end
    return
  end

  -- select or create combatant
  if tdpsPlayer[sourceGUID] then
    com = tdpsPlayer[sourceGUID]
  elseif tdpsPet[tdpsLink[sourceGUID]] then
    com = tdpsPet[tdpsLink[sourceGUID]]
  elseif UnitIsPlayer(sourceName) then
    makeCombatant(sourceGUID, sourceName, {}, getClass(sourceName))
    tdpsCombatEvent(self, event, ...)
    return
  elseif isPartyPet(sourceGUID) then
    -- get owner
    local ownerGUID, ownerName = getPetOwnerGUID(sourceGUID), getPetOwnerName(sourceGUID)
    -- make owner if it does not exist yet
    if not tdpsPlayer[ownerGUID] then
      makeCombatant(ownerGUID, ownerName, {ownerName..": "..sourceName}, getClass(ownerName))
    end
    -- make pointer
    tdpsLink[sourceGUID] = ownerName..": "..sourceName
    -- make pet if it does not exist yet
    if not tdpsPet[ownerName..": "..sourceName] then
      makeCombatant(ownerName..": "..sourceName, sourceName, sourceGUID, "PET")
    end
    -- add pet to owner if it's not there yet
    local found = false
    for i = 1, #tdpsPlayer[ownerGUID].pet do
      if tdpsPlayer[ownerGUID].pet[i] == ownerName..": "..sourceName then
        found = true
        break
      end
    end
    if not found then
      tinsert(tdpsPlayer[ownerGUID].pet, ownerName..": "..sourceName)
    end
    -- event
    tdpsCombatEvent(self, event, ...)
    return
  else
    return
  end

  -- track numbers
  local arg
  if isMiss[event] then
    if tdpsStartNewFight then
      startNewFight(destName, destGUID)
    end
  elseif isDamage[event] then
    if tdpsStartNewFight then
      startNewFight(destName, destGUID)
    end
    if event == "SWING_DAMAGE" then
      arg = arg12
      trackSpell(arg, destName, tdpsL.melee, "d")
    else
      arg = arg15
      trackSpell(arg, destName, arg13, "d")
    end
    tdpsFight[1].d, tdpsFight[2].d = tdpsFight[1].d + arg, tdpsFight[2].d + arg
    com.fight[1].d, com.fight[2].d = com.fight[1].d + arg, com.fight[2].d + arg
  elseif isHeal[event] then
    -- effective healing
    arg = arg15 - arg16
    if arg < 1 or not tdpsInCombat then
      -- stop on complete overheal or out of combat; heals will never start a new fight
      return
    end
    trackSpell(arg, destName, arg13, "h")
    tdpsFight[1].h, tdpsFight[2].h = tdpsFight[1].h + arg, tdpsFight[2].h + arg
    com.fight[1].h, com.fight[2].h = com.fight[1].h + arg, com.fight[2].h + arg
  end

  -- add combat time
  arg = timestamp - com.stamp
  if arg < 3.5 then
    com.fight[1].t = com.fight[1].t + arg
  else
    com.fight[1].t = com.fight[1].t + 3.5
  end
  if arg < 3.5 then
    com.fight[2].t = com.fight[2].t + arg
  else
    com.fight[2].t = com.fight[2].t + 3.5
  end

  -- save timestamp
  com.stamp = timestamp

  -- set onupdate
  tdpsAnchor:SetScript("OnUpdate", tdpsOnUpdate)
end

------------------------------------------------------------------------------------------------------------------------
-- Addon Scripts --
------------------------------------------------------------------------------------------------------------------------

tdpsFrame:RegisterEvent("ADDON_LOADED")
tdpsFrame:SetScript("OnEvent", function(self, event)
  local curVer = GetAddOnMetadata("TinyDPS", "Version")

  -- global version mismatch
  if curVer ~= tdps.version and tonumber(tdps.version) < 0.935 then
    initialiseSavedVariables()
    echo("Global variables have been reset to version "..curVer)
  end

  -- character version mismatch
  if curVer ~= tdpsVersion and tonumber(tdpsVersion) < 0.935 then
    initialiseSavedVariablesPerCharacter()
    echo("Character variables have been reset to version "..curVer)
    tdpsFrame:SetHeight(tdps.barHeight + 4)
  end

  -- save current version
  tdps.version = curVer
  tdpsVersion = curVer

  -- set position of anchor
  tdpsAnchor:ClearAllPoints()
  local scale = tdpsAnchor:GetEffectiveScale()
  local uis = UIParent:GetScale()
  tdpsAnchor:SetPoint("CENTER", UIParent, "CENTER", tdpsPosition.x * uis / scale, tdpsPosition.y * uis / scale)

  -- set position of frame
  tdpsFrame:ClearAllPoints()
  tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor)

  -- set width
  tdpsFrame:SetWidth(tdps.width)

  -- check for custom class colors
  if CUSTOM_CLASS_COLORS then
    cColor = CUSTOM_CLASS_COLORS
  else
    cColor = RAID_CLASS_COLORS
  end

  -- make bars if any
  for k in pairs(tdpsPlayer) do
    newBar(k)
  end

  -- set font and colors
  noData:SetFont(tdpsFont.name, tdpsFont.size, tdpsFont.outline)
  noData:SetShadowOffset(tdpsFont.shadow, tdpsFont.shadow * -1)
  tdpsFrame:SetBackdropBorderColor(tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4])
  tdpsFrame:SetBackdropColor(tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4])

  -- hide when necessary
  visibilityEvent()

  -- minimap button
  if tdps.showMinimapButton then
    tdpsButtonFrame:Show()
  else
    tdpsButtonFrame:Hide()
  end

  -- reset events
  tdpsFrame:UnregisterEvent("ADDON_LOADED")
  tdpsFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  tdpsFrame:SetScript("OnEvent", tdpsCombatEvent)
end)

-- all events that can show or hide the main window
tdpsAnchor:RegisterEvent("PLAYER_REGEN_ENABLED")
tdpsAnchor:RegisterEvent("PLAYER_REGEN_DISABLED")
tdpsAnchor:RegisterEvent("GROUP_ROSTER_UPDATE")
tdpsAnchor:RegisterEvent("PLAYER_ENTERING_WORLD")
tdpsAnchor:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tdpsAnchor:RegisterEvent("UPDATE_WORLD_STATES")

tdpsAnchor:SetScript("OnEvent", function(self, event, ...)
  visibilityEvent()
  if event == "GROUP_ROSTER_UPDATE" then
    if tdps.autoReset and tdpsPartySize == 0 and IsInGroup() then
      reset()
    end
    tdpsPartySize = GetNumGroupMembers()
  end
end)

-- onupdate
local sec = 2
function tdpsOnUpdate(self, elapsed)
  sec = sec + elapsed
  if sec > tdps.speed then
    checkCombat()
    if not tdpsInCombat then
      tdpsStartNewFight = true
      -- halted out of combat and restarted with combat (see function tdpsCombatEvent)
      tdpsAnchor:SetScript("OnUpdate", nil)
    end
    -- conditional refresh of the main window
    if tdpsFrame:IsVisible() and not isMovingOrSizing and not tdpsAnimationGroup:IsPlaying() then
      tdpsRefresh()
    end
    sec = 0
  end
end

tdpsAnchor:SetScript("OnUpdate", tdpsOnUpdate)

tdpsFrame:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" and IsShiftKeyDown() then
    CloseDropDownMenus()
    GameTooltip:Hide()
    isMovingOrSizing = true
    tdpsAnchor:StartMoving()
  elseif button == "RightButton" then
    ToggleDropDownMenu(1, nil, tdpsDropDown, "cursor", 0, 0)
  elseif button == "MiddleButton" then
    reset()
  elseif button == "Button4" then
    changeFight(nil, 1)
  elseif button == "Button5" then
    changeFight(nil, 2)
  end
end)

tdpsFrame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" then
    tdpsAnchor:StopMovingOrSizing()
    isMovingOrSizing = nil
    -- set position of frame
    tdpsFrame:ClearAllPoints()
    tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor, 0, 0)
    -- save position of anchor
    local xOfs, yOfs = tdpsAnchor:GetCenter()
    local scale = tdpsAnchor:GetEffectiveScale()
    local uis = UIParent:GetScale()
    xOfs = xOfs * scale - GetScreenWidth() * uis / 2
    yOfs = yOfs * scale - GetScreenHeight() * uis / 2
    tdpsPosition.x = xOfs / uis
    tdpsPosition.y = yOfs / uis
  end
end)

tdpsFrame:SetScript("OnMouseWheel", function(self, direction)
  scroll(direction)
end)

------------------------------------------------------------------------------------------------------------------------
-- Minimap Button Scripts --
------------------------------------------------------------------------------------------------------------------------

tdpsButtonFrame:SetScript("OnMouseDown", function(self, button)
  if button == "RightButton" then
    ToggleDropDownMenu(1, nil, tdpsDropDown, "cursor", 0, 0)
  end
  if button == "MiddleButton" then
    reset()
  end
end)

tdpsButtonFrame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" then
    toggle()
  end
end)

tdpsButtonFrame:SetScript("OnDragStart", function(self, button)
  tdpsButtonFrame:SetScript("OnUpdate", function(self, elapsed)
    local x, y = Minimap:GetCenter()
    local cx, cy = GetCursorPosition()
    x, y = cx / self:GetEffectiveScale() - x, cy / self:GetEffectiveScale() - y
    if x > Minimap:GetWidth() / 2 + tdpsButtonFrame:GetWidth() / 2 then
      x = Minimap:GetWidth() / 2 + tdpsButtonFrame:GetWidth() / 2
    end
    if x < Minimap:GetWidth() / 2 * -1 - tdpsButtonFrame:GetWidth() / 2 then
      x = Minimap:GetWidth() / 2 * -1 - tdpsButtonFrame:GetWidth() / 2
    end
    if y > Minimap:GetHeight() / 2 + tdpsButtonFrame:GetHeight() / 2 then
      y = Minimap:GetHeight() / 2 + tdpsButtonFrame:GetHeight() / 2
    end
    if y < Minimap:GetHeight() / 2 * -1 - tdpsButtonFrame:GetHeight() / 2 then
      y = Minimap:GetHeight() / 2 * -1 - tdpsButtonFrame:GetHeight() / 2
    end
    tdpsButtonFrame:ClearAllPoints()
    tdpsButtonFrame:SetPoint("CENTER", x, y)
  end)
end)

tdpsButtonFrame:SetScript("OnDragStop", function(self, button)
  tdpsButtonFrame:SetScript("OnUpdate", nil)
end)

tdpsButtonFrame:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(tdpsButtonFrame)
  GameTooltip:SetText("TinyDPS")

  if tdpsF == 2 then
    GameTooltip:AddLine(format("%s %s", tdpsL.tipPrefix[tdpsV], tdpsL.currentFight), 1, .85, 0)
  else
    GameTooltip:AddLine(format("%s %s", tdpsL.tipPrefix[tdpsV], tdpsFight[tdpsF].name), 1, .85, 0)
  end

  -- personal amount
  local ownAmount, ownTime, pet = 0, 0
  if tdpsPlayer[UnitGUID("player")] then
    pet, ownAmount, ownTime = tdpsPlayer[UnitGUID("player")].pet, tdpsPlayer[UnitGUID("player")].fight[tdpsF][tdpsV],
    tdpsPlayer[UnitGUID("player")].fight[tdpsF].t
    for i = 1, #pet do
      ownAmount = ownAmount + tdpsPet[pet[i]].fight[tdpsF][tdpsV]
      if tdpsPet[pet[i]].fight[tdpsF].t > ownTime then
        ownTime = tdpsPet[pet[i]].fight[tdpsF].t
      end
    end
    if ownAmount > 0 then
      GameTooltip:AddDoubleLine(UnitName("player"), format("%i (%i)", ownAmount, ownAmount / ownTime), 1, 1, 1, 1, 1, 1)
    end
  end

  -- raid amount
  local partyAmount, partyTime = 0, 0
  for k, v in pairs(tdpsPlayer) do
    partyAmount = partyAmount + v.fight[tdpsF][tdpsV]
    if v.fight[tdpsF].t > partyTime then
      partyTime = v.fight[tdpsF].t
    end
  end
  for k, v in pairs(tdpsPet) do
    partyAmount = partyAmount + v.fight[tdpsF][tdpsV]
    if v.fight[tdpsF].t > partyTime then
      partyTime = v.fight[tdpsF].t
    end
  end

  if partyAmount > ownAmount then
    GameTooltip:AddDoubleLine(tdpsL.raid, format("%i (%i)", partyAmount, partyAmount / partyTime), 1, 1, 1, 1, 1, 1)
  end

  GameTooltip:Show()
end)

tdpsButtonFrame:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)

------------------------------------------------------------------------------------------------------------------------
-- Resizing Scripts --
------------------------------------------------------------------------------------------------------------------------

tdpsResizeFrame:SetScript("OnEnter", function()
  tdpsResizeTexture:SetDesaturated(false)
  tdpsResizeTexture:SetAlpha(1)
end)

tdpsResizeFrame:SetScript("OnLeave", function()
  tdpsResizeTexture:SetDesaturated(true)
  tdpsResizeTexture:SetAlpha(0)
end)

tdpsResizeFrame:SetScript("OnMouseDown", function()
  isMovingOrSizing = true
  tdpsFrame:SetMinResize(60, tdpsFrame:GetHeight())
  tdpsFrame:SetMaxResize(400, tdpsFrame:GetHeight())
  tdpsFrame:StartSizing()
end)

tdpsResizeFrame:SetScript("OnMouseUp", function()
  tdpsFrame:StopMovingOrSizing()
  tdpsFrame:ClearAllPoints()
  tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor)
  isMovingOrSizing = nil
  tdps.width = tdpsFrame:GetWidth()
  for i = 1, #bar do
    bar[i]:SetWidth(tdpsFrame:GetWidth() - 4)
    bar[i]:SetValue(0)
  end
  tdpsRefresh()
end)
