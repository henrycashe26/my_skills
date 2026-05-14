#!/usr/bin/env bash
# ============================================================================
#  JCODE EXPLORER - An interactive tour of Jcode's features
# ============================================================================
set -euo pipefail

# ── Colors & Styling ────────────────────────────────────────────────────────
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDER='\033[4m'
RESET='\033[0m'
RED='\033[38;5;196m'
ORANGE='\033[38;5;208m'
YELLOW='\033[38;5;220m'
GREEN='\033[38;5;82m'
CYAN='\033[38;5;45m'
BLUE='\033[38;5;33m'
PURPLE='\033[38;5;141m'
PINK='\033[38;5;213m'
WHITE='\033[38;5;255m'
GRAY='\033[38;5;245m'
BG_DARK='\033[48;5;234m'
BG_DARKER='\033[48;5;232m'
BG_ACCENT='\033[48;5;236m'

# ── State ────────────────────────────────────────────────────────────────────
DISCOVERED=()
TOTAL_FEATURES=12
SCORE=0
CURRENT_ROOM="lobby"

# ── Utility Functions ────────────────────────────────────────────────────────
clear_screen() { printf '\033[2J\033[H'; }

slow_print() {
    local text="$1"
    local delay="${2:-0.02}"
    for (( i=0; i<${#text}; i++ )); do
        printf '%s' "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

press_enter() {
    echo ""
    printf "${DIM}  Press Enter to continue...${RESET}"
    read -r
}

print_bar() {
    local width=60
    printf "  ${GRAY}"
    printf '%.0s─' $(seq 1 $width)
    printf "${RESET}\n"
}

print_header() {
    local title="$1"
    clear_screen
    echo ""
    printf "  ${BG_ACCENT}${BOLD}${CYAN}  %-56s  ${RESET}\n" "$title"
    print_bar
    echo ""
}

discovered() {
    local feature="$1"
    for d in "${DISCOVERED[@]}"; do
        [[ "$d" == "$feature" ]] && return 0
    done
    DISCOVERED+=("$feature")
    SCORE=$((SCORE + 1))
    printf "\n  ${GREEN}${BOLD}  DISCOVERED!${RESET} ${GREEN}[$SCORE/$TOTAL_FEATURES]${RESET}\n"
    return 1
}

show_score() {
    local pct=$(( SCORE * 100 / TOTAL_FEATURES ))
    local filled=$(( SCORE * 20 / TOTAL_FEATURES ))
    local empty=$(( 20 - filled ))
    printf "\n  ${BOLD}Discovery Progress:${RESET} "
    printf "${GREEN}"
    printf '%.0s█' $(seq 1 $filled) 2>/dev/null || true
    printf "${GRAY}"
    printf '%.0s░' $(seq 1 $empty) 2>/dev/null || true
    printf "${RESET} ${WHITE}${SCORE}/${TOTAL_FEATURES}${RESET} ${DIM}(${pct}%%)${RESET}\n"
}

# ── Room: Title Screen ──────────────────────────────────────────────────────
title_screen() {
    clear_screen
    echo ""
    echo ""
    printf "${CYAN}${BOLD}"
    cat << 'LOGO'
         ╦╔═╗╔═╗╔╦╗╔═╗
         ║║  ║ ║ ║║║╣
        ╚╝╚═╝╚═╝═╩╝╚═╝
LOGO
    printf "${RESET}"
    printf "${PURPLE}${BOLD}"
    cat << 'LOGO2'
    ╔═╗─╔╗╔╗──╔╗──────────
    ║╔╝╔╝║║║──║║──────────
    ║╚╗╚╗║║║╔═╝║╔══╗╔═╗╔══╗╔═╗
    ║╔╝─║║║║║╔╗║║╔╗║║╔╝║══╣║╔╝
    ║╚╗╔╝║║╚╣╚╝║║╚╝║║║ ╠══║║║
    ╚═╝╚═╝╚═╩══╝╚══╝╚╝ ╚══╝╚╝
LOGO2
    printf "${RESET}"
    echo ""
    printf "  ${WHITE}${BOLD}An interactive tour of everything Jcode can do${RESET}\n"
    printf "  ${DIM}v0.12.1 | built by your Jcode agent${RESET}\n"
    echo ""
    print_bar
    echo ""
    printf "  ${YELLOW}You are a developer who just discovered Jcode.${RESET}\n"
    printf "  ${YELLOW}Explore each room to unlock features and level up.${RESET}\n"
    echo ""
    printf "  ${DIM}Tip: Some rooms have hidden interactions!${RESET}\n"
    echo ""
    press_enter
}

# ── Room: Lobby ──────────────────────────────────────────────────────────────
room_lobby() {
    while true; do
        print_header "THE LOBBY - Choose Your Adventure"
        show_score
        echo ""
        printf "  ${WHITE}You stand in the Jcode lobby. Doors lead in every direction.${RESET}\n\n"

        printf "  ${CYAN}${BOLD}1)${RESET} ${WHITE} The Workshop${RESET}        ${DIM}- Core agent powers${RESET}\n"
        printf "  ${GREEN}${BOLD}2)${RESET} ${WHITE} The Lab${RESET}             ${DIM}- Multi-provider & model magic${RESET}\n"
        printf "  ${PURPLE}${BOLD}3)${RESET} ${WHITE} The Library${RESET}          ${DIM}- Memory & sessions${RESET}\n"
        printf "  ${ORANGE}${BOLD}4)${RESET} ${WHITE} The Observatory${RESET}      ${DIM}- Ambient mode & automation${RESET}\n"
        printf "  ${PINK}${BOLD}5)${RESET} ${WHITE} The Forge${RESET}            ${DIM}- Self-development & hacking${RESET}\n"
        printf "  ${YELLOW}${BOLD}6)${RESET} ${WHITE} The Arcade${RESET}           ${DIM}- Scripting & pipelines${RESET}\n"
        printf "  ${BLUE}${BOLD}7)${RESET} ${WHITE} The Comms Tower${RESET}      ${DIM}- Pairing, dictation & mobile${RESET}\n"
        echo ""
        printf "  ${RED}${BOLD}q)${RESET} ${DIM}Exit the game${RESET}\n"
        echo ""
        printf "  ${BOLD}> ${RESET}"
        read -r choice

        case "$choice" in
            1) room_workshop ;;
            2) room_lab ;;
            3) room_library ;;
            4) room_observatory ;;
            5) room_forge ;;
            6) room_arcade ;;
            7) room_comms ;;
            q|Q) room_exit; return ;;
            *) ;;
        esac
    done
}

# ── Room: Workshop (Core Agent) ─────────────────────────────────────────────
room_workshop() {
    print_header "THE WORKSHOP - Core Agent Powers"
    printf "  ${WHITE}Workbenches line the walls, covered in tools.${RESET}\n"
    printf "  ${WHITE}A sign reads: ${ITALIC}\"This is where the magic happens.\"${RESET}\n\n"

    printf "  ${CYAN}${BOLD}a)${RESET} Examine the ${BOLD}Tool Wall${RESET}        ${DIM}(file editing, search, bash)${RESET}\n"
    printf "  ${CYAN}${BOLD}b)${RESET} Open the ${BOLD}Agent Drawer${RESET}        ${DIM}(sub-agents & parallelism)${RESET}\n"
    printf "  ${CYAN}${BOLD}c)${RESET} Inspect the ${BOLD}Browser Setup${RESET}    ${DIM}(web automation)${RESET}\n"
    printf "  ${CYAN}${BOLD}r)${RESET} ${DIM}Return to lobby${RESET}\n"
    echo ""
    printf "  ${BOLD}> ${RESET}"
    read -r choice

    case "$choice" in
        a)
            print_header "TOOL WALL - File Editing, Search & Bash"
            discovered "tools" || true
            echo ""
            printf "  ${GREEN}${BOLD}Jcode's agent has access to powerful built-in tools:${RESET}\n\n"

            printf "  ${YELLOW}${BOLD}Read${RESET}   ${WHITE}Read any file with pagination support${RESET}\n"
            printf "         ${DIM}Read(file_path=\"src/main.rs\", offset=0, limit=100)${RESET}\n\n"

            printf "  ${YELLOW}${BOLD}Edit${RESET}   ${WHITE}Surgical string replacements in files${RESET}\n"
            printf "         ${DIM}Edit(file_path, old_string, new_string)${RESET}\n\n"

            printf "  ${YELLOW}${BOLD}Write${RESET}  ${WHITE}Create or overwrite entire files${RESET}\n"
            printf "         ${DIM}Write(file_path, content)${RESET}\n\n"

            printf "  ${YELLOW}${BOLD}Bash${RESET}   ${WHITE}Run any shell command, with background support${RESET}\n"
            printf "         ${DIM}Bash(command=\"cargo test\", timeout=120)${RESET}\n\n"

            printf "  ${YELLOW}${BOLD}Grep${RESET}   ${WHITE}Ripgrep-powered search across your codebase${RESET}\n"
            printf "         ${DIM}Grep(pattern=\"TODO\", path=\"src/\", glob=\"*.rs\")${RESET}\n\n"

            printf "  ${YELLOW}${BOLD}Glob${RESET}   ${WHITE}Fast file pattern matching${RESET}\n"
            printf "         ${DIM}Glob(pattern=\"**/*.py\")${RESET}\n\n"

            printf "  ${PURPLE}${ITALIC}  The agent uses these autonomously - it reads, edits, runs${RESET}\n"
            printf "  ${PURPLE}${ITALIC}  tests, and fixes bugs without you lifting a finger.${RESET}\n"
            press_enter
            ;;
        b)
            print_header "AGENT DRAWER - Sub-Agents & Parallelism"
            discovered "subagents" || true
            echo ""
            printf "  ${GREEN}${BOLD}Jcode can spawn sub-agents for complex tasks:${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Agent(${RESET}\n"
            printf "  ${CYAN}  description = \"Refactor auth module\"${RESET}\n"
            printf "  ${CYAN}  prompt = \"Refactor src/auth.rs to use...\"${RESET}\n"
            printf "  ${CYAN}  run_in_background = true${RESET}\n"
            printf "  ${CYAN}${BOLD})${RESET}\n\n"

            printf "  ${WHITE}${BOLD}Why this is powerful:${RESET}\n"
            printf "  ${WHITE}  - Multiple agents work in parallel on different files${RESET}\n"
            printf "  ${WHITE}  - Background agents don't block the main conversation${RESET}\n"
            printf "  ${WHITE}  - Each sub-agent has full tool access${RESET}\n"
            printf "  ${WHITE}  - Great for: multi-file refactors, research tasks${RESET}\n\n"

            printf "  ${PURPLE}${ITALIC}  Ask Jcode to \"refactor these 5 modules\" and watch${RESET}\n"
            printf "  ${PURPLE}${ITALIC}  it fan out agents to handle each one simultaneously.${RESET}\n"
            press_enter
            ;;
        c)
            print_header "BROWSER SETUP - Web Automation"
            discovered "browser" || true
            echo ""
            printf "  ${GREEN}${BOLD}Jcode can control a browser for you!${RESET}\n\n"

            printf "  ${WHITE}Setup:${RESET}  ${CYAN}jcode browser setup${RESET}\n"
            printf "  ${WHITE}Status:${RESET} ${CYAN}jcode browser status${RESET}\n\n"

            printf "  ${WHITE}${BOLD}Use cases:${RESET}\n"
            printf "  ${WHITE}  - Research documentation while coding${RESET}\n"
            printf "  ${WHITE}  - Test web apps you're building${RESET}\n"
            printf "  ${WHITE}  - Scrape reference data${RESET}\n"
            printf "  ${WHITE}  - Fill out forms and interact with web UIs${RESET}\n\n"

            printf "  ${PURPLE}${ITALIC}  Just ask: \"Go check the API docs at ...\" and the${RESET}\n"
            printf "  ${PURPLE}${ITALIC}  agent will open a browser and navigate for you.${RESET}\n"
            press_enter
            ;;
    esac
}

# ── Room: Lab (Providers & Models) ──────────────────────────────────────────
room_lab() {
    print_header "THE LAB - Multi-Provider & Model Magic"
    discovered "providers" || true
    echo ""
    printf "  ${WHITE}Glowing screens show connections to AI providers worldwide.${RESET}\n\n"

    printf "  ${GREEN}${BOLD}Jcode supports 30+ providers out of the box:${RESET}\n\n"

    printf "  ${YELLOW}${BOLD}Tier 1 - Direct:${RESET}\n"
    printf "    ${WHITE}Claude (Anthropic) | OpenAI | Google Gemini | xAI${RESET}\n\n"

    printf "  ${YELLOW}${BOLD}Tier 2 - Aggregators:${RESET}\n"
    printf "    ${WHITE}OpenRouter | Azure | Bedrock | Together AI | DeepInfra${RESET}\n\n"

    printf "  ${YELLOW}${BOLD}Tier 3 - Local:${RESET}\n"
    printf "    ${WHITE}Ollama | LM Studio${RESET}\n\n"

    printf "  ${YELLOW}${BOLD}Tier 4 - Specialized:${RESET}\n"
    printf "    ${WHITE}Cursor | Copilot | DeepSeek | Mistral | Perplexity${RESET}\n\n"

    print_bar
    printf "\n  ${CYAN}${BOLD}Switch models on the fly:${RESET}\n"
    printf "    ${DIM}jcode -p openai -m gpt-5.5${RESET}\n"
    printf "    ${DIM}jcode -p claude -m claude-opus-4-6${RESET}\n"
    printf "    ${DIM}jcode -p ollama -m llama3${RESET}\n\n"

    printf "  ${CYAN}${BOLD}List available models:${RESET}\n"
    printf "    ${DIM}jcode model list${RESET}\n\n"

    printf "  ${PURPLE}${ITALIC}  Same powerful agent, any brain. Mix and match${RESET}\n"
    printf "  ${PURPLE}${ITALIC}  for cost, speed, or capability.${RESET}\n"
    press_enter
}

# ── Room: Library (Memory & Sessions) ───────────────────────────────────────
room_library() {
    print_header "THE LIBRARY - Memory & Sessions"
    echo ""
    printf "  ${WHITE}Floor-to-ceiling bookshelves. Each book is a past conversation.${RESET}\n\n"

    printf "  ${PURPLE}${BOLD}a)${RESET} The ${BOLD}Memory Vault${RESET}     ${DIM}(persistent memory across sessions)${RESET}\n"
    printf "  ${PURPLE}${BOLD}b)${RESET} The ${BOLD}Session Archive${RESET}   ${DIM}(resume, replay, rename)${RESET}\n"
    printf "  ${PURPLE}${BOLD}r)${RESET} ${DIM}Return to lobby${RESET}\n"
    echo ""
    printf "  ${BOLD}> ${RESET}"
    read -r choice

    case "$choice" in
        a)
            print_header "MEMORY VAULT - Persistent Memory"
            discovered "memory" || true
            echo ""
            printf "  ${GREEN}${BOLD}Jcode remembers things across sessions!${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Commands:${RESET}\n"
            printf "    ${WHITE}jcode memory list${RESET}      ${DIM}See all stored memories${RESET}\n"
            printf "    ${WHITE}jcode memory search${RESET}    ${DIM}Search by keyword${RESET}\n"
            printf "    ${WHITE}jcode memory export${RESET}    ${DIM}Export to JSON${RESET}\n"
            printf "    ${WHITE}jcode memory import${RESET}    ${DIM}Import from JSON${RESET}\n"
            printf "    ${WHITE}jcode memory stats${RESET}     ${DIM}Memory statistics${RESET}\n\n"

            printf "  ${WHITE}${BOLD}What it remembers:${RESET}\n"
            printf "  ${WHITE}  - Your coding preferences and style${RESET}\n"
            printf "  ${WHITE}  - Project-specific context and conventions${RESET}\n"
            printf "  ${WHITE}  - Past decisions and their reasoning${RESET}\n"
            printf "  ${WHITE}  - Things you explicitly tell it to remember${RESET}\n\n"

            printf "  ${PURPLE}${ITALIC}  Say \"Remember that I prefer tabs over spaces\"${RESET}\n"
            printf "  ${PURPLE}${ITALIC}  and it'll know next time.${RESET}\n"
            press_enter
            ;;
        b)
            print_header "SESSION ARCHIVE - Resume & Replay"
            discovered "sessions" || true
            echo ""
            printf "  ${GREEN}${BOLD}Every conversation is saved and resumable!${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Resume a session:${RESET}\n"
            printf "    ${WHITE}jcode --resume${RESET}             ${DIM}List & pick a session${RESET}\n"
            printf "    ${WHITE}jcode --resume <ID>${RESET}        ${DIM}Jump back into a specific one${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Rename sessions:${RESET}\n"
            printf "    ${WHITE}jcode session rename <ID> \"My Project\"${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Replay sessions:${RESET}\n"
            printf "    ${WHITE}jcode replay <file>${RESET}        ${DIM}Watch a session play back in TUI${RESET}\n\n"

            printf "  ${WHITE}${BOLD}Why this matters:${RESET}\n"
            printf "  ${WHITE}  - Pick up exactly where you left off${RESET}\n"
            printf "  ${WHITE}  - Full context is preserved (no re-explaining)${RESET}\n"
            printf "  ${WHITE}  - Great for long-running projects${RESET}\n"
            press_enter
            ;;
    esac
}

# ── Room: Observatory (Ambient Mode) ────────────────────────────────────────
room_observatory() {
    print_header "THE OBSERVATORY - Ambient Mode & Automation"
    discovered "ambient" || true
    echo ""

    printf "  ${WHITE}Through the glass dome, you see Jcode watching your workspace${RESET}\n"
    printf "  ${WHITE}like a silent guardian, ready to act.${RESET}\n\n"

    printf "  ${GREEN}${BOLD}Ambient Mode: Jcode works while you're away${RESET}\n\n"

    printf "  ${CYAN}${BOLD}Commands:${RESET}\n"
    printf "    ${WHITE}jcode ambient status${RESET}    ${DIM}Is it running?${RESET}\n"
    printf "    ${WHITE}jcode ambient log${RESET}       ${DIM}What has it been doing?${RESET}\n"
    printf "    ${WHITE}jcode ambient trigger${RESET}   ${DIM}Manually trigger a cycle${RESET}\n"
    printf "    ${WHITE}jcode ambient stop${RESET}      ${DIM}Stop ambient mode${RESET}\n\n"

    printf "  ${WHITE}${BOLD}What Ambient Mode does:${RESET}\n"
    printf "  ${WHITE}  - Watches for file changes in your project${RESET}\n"
    printf "  ${WHITE}  - Can run linters, tests, or builds automatically${RESET}\n"
    printf "  ${WHITE}  - Proactively suggests fixes or improvements${RESET}\n"
    printf "  ${WHITE}  - Operates with permission controls${RESET}\n\n"

    printf "  ${CYAN}${BOLD}Permission management:${RESET}\n"
    printf "    ${WHITE}jcode permissions${RESET}       ${DIM}Review pending permission requests${RESET}\n\n"

    printf "  ${PURPLE}${ITALIC}  Imagine: you save a file with a bug, and Jcode${RESET}\n"
    printf "  ${PURPLE}${ITALIC}  notices and fixes it before you even run the code.${RESET}\n"
    press_enter
}

# ── Room: Forge (Self-Dev) ──────────────────────────────────────────────────
room_forge() {
    print_header "THE FORGE - Self-Development & Hacking"
    echo ""
    printf "  ${WHITE}The forge glows hot. Here, Jcode modifies ${ITALIC}itself${RESET}${WHITE}.${RESET}\n\n"

    printf "  ${PINK}${BOLD}a)${RESET} The ${BOLD}Self-Dev Anvil${RESET}    ${DIM}(modify the agent's own code)${RESET}\n"
    printf "  ${PINK}${BOLD}b)${RESET} The ${BOLD}Debug Console${RESET}     ${DIM}(inspect internals live)${RESET}\n"
    printf "  ${PINK}${BOLD}c)${RESET} The ${BOLD}Skills Shelf${RESET}      ${DIM}(custom skills & commands)${RESET}\n"
    printf "  ${PINK}${BOLD}r)${RESET} ${DIM}Return to lobby${RESET}\n"
    echo ""
    printf "  ${BOLD}> ${RESET}"
    read -r choice

    case "$choice" in
        a)
            print_header "SELF-DEV ANVIL - Modify the Agent Itself"
            discovered "selfdev" || true
            echo ""
            printf "  ${GREEN}${BOLD}Jcode can modify its own harness!${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Launch self-dev mode:${RESET}\n"
            printf "    ${WHITE}jcode self-dev${RESET}             ${DIM}Start a canary session${RESET}\n"
            printf "    ${WHITE}jcode self-dev --build${RESET}     ${DIM}Build & test before launching${RESET}\n\n"

            printf "  ${WHITE}${BOLD}What this means:${RESET}\n"
            printf "  ${WHITE}  - The agent can edit its own system prompt${RESET}\n"
            printf "  ${WHITE}  - Add new tools or modify existing ones${RESET}\n"
            printf "  ${WHITE}  - Fix bugs in itself${RESET}\n"
            printf "  ${WHITE}  - Runs as a \"canary\" so it doesn't break your main install${RESET}\n\n"

            printf "  ${RED}${BOLD}  This is the recursive singularity room.${RESET}\n"
            printf "  ${PURPLE}${ITALIC}  The AI improving the AI. Handle with care.${RESET}\n"
            press_enter
            ;;
        b)
            print_header "DEBUG CONSOLE - Inspect Internals"
            discovered "debug" || true
            echo ""
            printf "  ${GREEN}${BOLD}Peek under the hood of a running Jcode server:${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Commands:${RESET}\n"
            printf "    ${WHITE}jcode debug list${RESET}           ${DIM}List active sessions${RESET}\n"
            printf "    ${WHITE}jcode debug state${RESET}          ${DIM}Current server state${RESET}\n"
            printf "    ${WHITE}jcode debug history${RESET}        ${DIM}Message history${RESET}\n"
            printf "    ${WHITE}jcode debug sessions${RESET}       ${DIM}All sessions info${RESET}\n"
            printf "    ${WHITE}jcode debug message \"...\"${RESET}  ${DIM}Inject a message${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Live state broadcasting:${RESET}\n"
            printf "    ${WHITE}jcode --debug-socket${RESET}       ${DIM}Broadcasts all TUI state changes${RESET}\n\n"

            printf "  ${PURPLE}${ITALIC}  Great for building extensions, debugging issues,${RESET}\n"
            printf "  ${PURPLE}${ITALIC}  or understanding what the agent is thinking.${RESET}\n"
            press_enter
            ;;
        c)
            print_header "SKILLS SHELF - Custom Skills"
            discovered "skills" || true
            echo ""
            printf "  ${GREEN}${BOLD}Jcode has a skills system for reusable behaviors:${RESET}\n\n"

            printf "  ${CYAN}${BOLD}Built-in skills:${RESET}\n"
            printf "    ${WHITE}/optimization${RESET}  ${DIM}Performance tuning workflow${RESET}\n\n"

            printf "  ${WHITE}${BOLD}What skills do:${RESET}\n"
            printf "  ${WHITE}  - Pre-packaged expert workflows${RESET}\n"
            printf "  ${WHITE}  - Invoked with slash commands: /skillname${RESET}\n"
            printf "  ${WHITE}  - Can define metrics, methodologies, and checklists${RESET}\n"
            printf "  ${WHITE}  - Think of them as \"expert modes\" for the agent${RESET}\n\n"

            printf "  ${PURPLE}${ITALIC}  The /optimization skill, for example, makes the agent${RESET}\n"
            printf "  ${PURPLE}${ITALIC}  measure before optimizing, attribute bottlenecks,${RESET}\n"
            printf "  ${PURPLE}${ITALIC}  and validate improvements with real metrics.${RESET}\n"
            press_enter
            ;;
    esac
}

# ── Room: Arcade (Scripting) ────────────────────────────────────────────────
room_arcade() {
    print_header "THE ARCADE - Scripting & Pipelines"
    discovered "scripting" || true
    echo ""
    printf "  ${WHITE}Arcade cabinets hum. Each one is a different way to use Jcode${RESET}\n"
    printf "  ${WHITE}in scripts, CI/CD, and automation pipelines.${RESET}\n\n"

    printf "  ${GREEN}${BOLD}jcode run - One-shot mode:${RESET}\n"
    printf "    ${DIM}jcode run \"Explain this error: \$(cat error.log)\"${RESET}\n"
    printf "    ${DIM}jcode run --json \"List all TODO comments\"${RESET}\n"
    printf "    ${DIM}jcode run --ndjson \"Refactor main.py\"${RESET}\n\n"

    printf "  ${GREEN}${BOLD}jcode repl - Simple REPL (no TUI):${RESET}\n"
    printf "    ${DIM}jcode repl${RESET}\n"
    printf "    ${DIM}Great for: SSH sessions, simple terminals, piping${RESET}\n\n"

    printf "  ${GREEN}${BOLD}Pipeline examples:${RESET}\n"
    printf "    ${DIM}# Analyze every changed file${RESET}\n"
    printf "    ${DIM}git diff --name-only | xargs -I{} jcode run \"Review {}\"${RESET}\n\n"
    printf "    ${DIM}# Generate commit messages${RESET}\n"
    printf "    ${DIM}git diff --staged | jcode run \"Write a commit message\"${RESET}\n\n"
    printf "    ${DIM}# CI/CD code review${RESET}\n"
    printf "    ${DIM}jcode run --json \"Any security issues?\" > report.json${RESET}\n\n"

    printf "  ${GREEN}${BOLD}Server mode:${RESET}\n"
    printf "    ${DIM}jcode serve${RESET}       ${DIM}Start background daemon${RESET}\n"
    printf "    ${DIM}jcode connect${RESET}     ${DIM}Connect to running server${RESET}\n"
    printf "    ${DIM}Multiple clients can share one server!${RESET}\n\n"

    printf "  ${PURPLE}${ITALIC}  The --json and --ndjson flags make Jcode a building${RESET}\n"
    printf "  ${PURPLE}${ITALIC}  block in any automation pipeline.${RESET}\n"
    press_enter
}

# ── Room: Comms Tower (Pairing & Mobile) ─────────────────────────────────────
room_comms() {
    print_header "THE COMMS TOWER - Pairing, Dictation & Mobile"
    discovered "comms" || true
    echo ""
    printf "  ${WHITE}Radio dishes point in all directions. Jcode can be controlled${RESET}\n"
    printf "  ${WHITE}from your phone, your voice, and remote machines.${RESET}\n\n"

    printf "  ${GREEN}${BOLD}Mobile Pairing:${RESET}\n"
    printf "    ${WHITE}jcode pair${RESET}            ${DIM}Generate a pairing code${RESET}\n"
    printf "    ${WHITE}jcode pair --list${RESET}     ${DIM}See paired devices${RESET}\n"
    printf "    ${WHITE}jcode pair --revoke${RESET}   ${DIM}Remove a device${RESET}\n\n"
    printf "    ${PURPLE}${ITALIC}Control Jcode from an iOS/web client!${RESET}\n\n"

    printf "  ${GREEN}${BOLD}Voice Dictation:${RESET}\n"
    printf "    ${WHITE}jcode dictate${RESET}         ${DIM}Speak to your agent${RESET}\n"
    printf "    ${WHITE}jcode transcript${RESET}      ${DIM}Inject transcribed text${RESET}\n\n"
    printf "    ${PURPLE}${ITALIC}Talk to your code. Literally.${RESET}\n\n"

    printf "  ${GREEN}${BOLD}Global Hotkey:${RESET}\n"
    printf "    ${WHITE}jcode setup-hotkey${RESET}    ${DIM}Set up Alt+; to launch Jcode${RESET}\n\n"

    printf "  ${GREEN}${BOLD}App Launcher:${RESET}\n"
    printf "    ${WHITE}jcode setup-launcher${RESET}  ${DIM}Add to Spotlight/app launcher${RESET}\n\n"

    printf "  ${GREEN}${BOLD}System Restart:${RESET}\n"
    printf "    ${WHITE}jcode restart${RESET}         ${DIM}Save/restore open windows across reboot${RESET}\n\n"

    printf "  ${PURPLE}${ITALIC}  Jcode on your phone while you're on the couch.${RESET}\n"
    printf "  ${PURPLE}${ITALIC}  The future is weird and wonderful.${RESET}\n"
    press_enter
}

# ── Room: Exit ──────────────────────────────────────────────────────────────
room_exit() {
    print_header "QUEST COMPLETE"
    show_score
    echo ""

    if [[ $SCORE -eq $TOTAL_FEATURES ]]; then
        printf "  ${YELLOW}${BOLD}  PERFECT SCORE! You've discovered every feature!${RESET}\n\n"
        printf "  ${WHITE}You are now a Jcode Grandmaster.${RESET}\n"
    elif [[ $SCORE -ge 8 ]]; then
        printf "  ${GREEN}${BOLD}  Excellent exploration!${RESET}\n\n"
        printf "  ${WHITE}You've uncovered most of Jcode's secrets.${RESET}\n"
        printf "  ${DIM}  Run the game again to find what you missed!${RESET}\n"
    elif [[ $SCORE -ge 4 ]]; then
        printf "  ${CYAN}${BOLD}  Good start!${RESET}\n\n"
        printf "  ${WHITE}There's still a lot to discover.${RESET}\n"
        printf "  ${DIM}  Each room has multiple things to examine.${RESET}\n"
    else
        printf "  ${PURPLE}${BOLD}  Just getting started!${RESET}\n\n"
        printf "  ${WHITE}Come back and explore more rooms.${RESET}\n"
    fi

    echo ""
    print_bar
    echo ""

    printf "  ${BOLD}${WHITE}Quick Reference Card:${RESET}\n\n"
    printf "  ${CYAN}jcode${RESET}                     ${DIM}Launch interactive TUI${RESET}\n"
    printf "  ${CYAN}jcode run \"...\"${RESET}            ${DIM}One-shot command${RESET}\n"
    printf "  ${CYAN}jcode --resume${RESET}             ${DIM}Resume a past session${RESET}\n"
    printf "  ${CYAN}jcode -p ollama -m llama3${RESET}  ${DIM}Use any provider/model${RESET}\n"
    printf "  ${CYAN}jcode memory list${RESET}          ${DIM}See what it remembers${RESET}\n"
    printf "  ${CYAN}jcode ambient status${RESET}       ${DIM}Check ambient mode${RESET}\n"
    printf "  ${CYAN}jcode pair${RESET}                 ${DIM}Connect your phone${RESET}\n"
    printf "  ${CYAN}jcode self-dev${RESET}             ${DIM}Hack on Jcode itself${RESET}\n"
    printf "  ${CYAN}jcode usage${RESET}                ${DIM}Check usage limits${RESET}\n"
    echo ""
    printf "  ${DIM}Jcode v0.12.1 | https://github.com/1jehuang/jcode${RESET}\n"
    echo ""
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
    # Check terminal supports what we need
    if [[ ! -t 0 ]]; then
        echo "This game needs an interactive terminal!"
        exit 1
    fi

    title_screen
    room_lobby
}

main "$@"
