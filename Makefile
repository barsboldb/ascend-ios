# Ascend Makefile - Development Commands

.PHONY: help gen build run clean devices

# Default device - Use ID for reliability
DEVICE_ID ?= CF410C2F-CC12-4D3E-940A-D4B7758FA395
DEVICE_NAME ?= iPhone 17 Pro

help: ## Show this help message
	@echo "Ascend Development Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

gen: ## Generate Xcode project from project.yml
	@echo "🔧 Generating Xcode project..."
	@xcodegen generate
	@echo "✅ Project generated!"

build: ## Build the app
	@echo "🔨 Building Ascend for $(DEVICE_NAME)..."
	@xcodebuild \
		-project Ascend.xcodeproj \
		-scheme Ascend \
		-configuration Debug \
		-destination 'platform=iOS Simulator,OS=26.2,name=iPhone 17 Pro' \
		-derivedDataPath build \
		build | xcbeautify || cat

run: build ## Build and run on simulator (use DEVICE=name to specify)
	@./run.sh "$(DEVICE)"

devices: ## List available simulators
	@echo "📱 Available iOS Simulators:"
	@xcrun simctl list devices available | grep "iPhone\|iPad" | grep -v "unavailable"

clean: ## Clean build artifacts
	@echo "🧹 Cleaning..."
	@rm -rf build
	@rm -rf ~/Library/Developer/Xcode/DerivedData/Ascend-*
	@echo "✅ Clean complete!"

logs: ## Show simulator logs
	@xcrun simctl spawn booted log stream --level debug --predicate 'processImagePath contains "Ascend"'
