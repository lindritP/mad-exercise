# Build & run the app in the iOS Simulator without opening Xcode.
#
#   make run                      -> build, boot simulator, install, launch (print() output in terminal)
#   make run DEVICE="iPhone 17"   -> same, on another simulator
#   make help                     -> list all commands

SHELL       := /bin/bash
.SHELLFLAGS := -o pipefail -c

PROJECT   := mad-exercise.xcodeproj
SCHEME    := mad-exercise
BUNDLE_ID := project.mad-exercise
APP_NAME  := mad-exercise
DEVICE    ?= iPhone 17 Pro
CONFIG    ?= Debug
DERIVED   := build
APP       := $(DERIVED)/Build/Products/$(CONFIG)-iphonesimulator/$(APP_NAME).app
DEST      := platform=iOS Simulator,name=$(DEVICE)

# Use xcbeautify for readable build output if installed (make setup), else xcodebuild -quiet
ifneq ($(shell command -v xcbeautify),)
  PRETTY := | xcbeautify
else
  PRETTY :=
  QUIET  := -quiet
endif

XCODEBUILD := xcodebuild -project $(PROJECT) -scheme $(SCHEME) -configuration $(CONFIG) \
              -destination '$(DEST)' -derivedDataPath $(DERIVED) $(QUIET)

.DEFAULT_GOAL := help
.PHONY: help setup lsp devices boot sim build install launch run logs stop test clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

setup: ## Install helper tools via Homebrew (xcbeautify, xcode-build-server)
	brew install xcbeautify xcode-build-server

lsp: ## Generate buildServer.json so SourceKit-LSP in VS Code understands the project
	xcode-build-server config -project $(PROJECT) -scheme $(SCHEME)

devices: ## List available simulators
	xcrun simctl list devices available

boot: ## Boot the simulator (DEVICE=...)
	@xcrun simctl boot "$(DEVICE)" 2>/dev/null || true
	@xcrun simctl bootstatus "$(DEVICE)" -b >/dev/null

sim: boot ## Boot and show the Simulator window
	open -a Simulator

build: ## Compile the app for the simulator
	$(XCODEBUILD) build $(PRETTY)

install: sim ## Install the built app on the simulator
	xcrun simctl install "$(DEVICE)" "$(APP)"

launch: ## Launch the app, streaming its print() output here (Ctrl+C to stop)
	xcrun simctl launch --console-pty --terminate-running-process "$(DEVICE)" $(BUNDLE_ID)

run: build install launch ## Build + install + launch

logs: ## Stream the app's system log (os_log / Logger)
	xcrun simctl spawn "$(DEVICE)" log stream --level debug --predicate 'process == "$(APP_NAME)"'

stop: ## Terminate the app in the simulator
	@xcrun simctl terminate "$(DEVICE)" $(BUNDLE_ID) 2>/dev/null || true

test: ## Run unit + UI tests
	$(XCODEBUILD) test $(PRETTY)

clean: ## Delete build output
	rm -rf $(DERIVED)
