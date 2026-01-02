-------------------------------------------------------------------------------
-- MayTTK: Korean Localization (koKR)
-------------------------------------------------------------------------------
local addonName, addon = ...
if GetLocale() ~= "koKR" then return end

local L = addon.L

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s 로드됨! |cffffff00/ttk|r 설정 열기"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "활성화됨"
L["DISABLED"] = "비활성화됨"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r 프레임 잠김"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r 프레임 잠금 해제"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r 표시 켜짐"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r 표시 꺼짐"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r 위치 초기화됨"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r 미니맵 버튼 %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r 미리보기 켜짐 - 드래그하여 위치 조정"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r 미리보기 꺼짐"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r 데이터 삭제됨"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r 명령어: toggle | show | hide | lock | reset | minimap | preview | (빈칸 = 설정)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r 디버그 모드 켜짐"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r 디버그 모드 꺼짐"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r 설정"
L["HEADER_GENERAL"] = "일반"
L["HEADER_APPEARANCE"] = "외관"
L["HEADER_FRAME_STYLE"] = "프레임 스타일"
L["HEADER_POSITIONING"] = "위치 지정"

-- Settings Options
L["OPT_ENABLED"] = "애드온 활성화"
L["OPT_SHOW_UI"] = "TTK 표시"
L["OPT_LOCK_FRAME"] = "위치 잠금"
L["OPT_HISTORY"] = "추세 화살표 표시"
L["OPT_HISTORY_DESC"] = "추세 지표"
L["OPT_MINIMAP"] = "미니맵 버튼 표시"
L["OPT_FONT"] = "글꼴"
L["OPT_FONT_SIZE"] = "글꼴 크기"
L["OPT_COLORS"] = "색상"
L["OPT_TREND_STYLE"] = "추세 스타일"
L["OPT_SCALE"] = "크기"
L["OPT_SHOW_BG"] = "배경 표시"
L["OPT_SHOW_BORDER"] = "테두리 표시"
L["OPT_BG_OPACITY"] = "배경 투명도"
L["OPT_ATTACH_TARGET"] = "대상 프레임에 부착 (ElvUI/SUF 자동 감지)"
L["OPT_ANCHOR_POINT"] = "고정점"
L["OPT_ANCHOR_TO"] = "부착 위치"
L["OPT_OFFSET_X"] = "X 오프셋"
L["OPT_OFFSET_Y"] = "Y 오프셋"

-- Buttons
L["BTN_PREVIEW"] = "미리보기"
L["BTN_RESET_POS"] = "위치 초기화"
L["BTN_CLEAR_DATA"] = "데이터 삭제"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "처치 시간 계산기"
L["COMPARTMENT_LEFT_CLICK"] = "좌클릭"
L["COMPARTMENT_RIGHT_CLICK"] = "우클릭"
L["COMPARTMENT_SETTINGS"] = "설정 열기"
L["COMPARTMENT_TOGGLE"] = "애드온 전환"
L["MINIMAP_DRAG"] = "드래그하여 재배치"

