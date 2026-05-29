# Ascend Makefile - Development Commands

.PHONY: help gen build run clean devices

# Default device - Use ID for reliability
DEVICE_ID ?= CF410C2F-CC12-4D3E-940A-D4B7758FA395
DEVICE_NAME ?= iPhone 17 Pro

help: ## Show this help message
	@echo "Ascend Development Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

gen: ## Regenerate Swift gRPC code from the proto/ submodule
	@echo "🔧 Syncing proto submodule..."
	@git submodule update --remote --recursive proto
	@echo "🔧 Generating Swift code..."
	@protoc \
		--proto_path=proto \
		--proto_path=vendor/protos \
		--swift_out=Ascend/Generated \
		--plugin=protoc-gen-grpc-swift=$$(brew --prefix)/bin/protoc-gen-grpc-swift-2 \
		--grpc-swift_out=Ascend/Generated \
		proto/program/program.proto proto/session/session.proto
	@echo "🔧 Patching generated code for grpc-swift 2.2.3..."
	@sed -i '' -E '/^[[:space:]]+type: \.(unary|clientStreaming|serverStreaming|bidirectionalStreaming)$$/d' \
		Ascend/Generated/program/program.grpc.swift Ascend/Generated/session/session.grpc.swift
	@sed -i '' -E 's/method: "([^"]+)",$$/method: "\1"/' \
		Ascend/Generated/program/program.grpc.swift Ascend/Generated/session/session.grpc.swift
	@echo "✅ Swift code generated!"

build: ## Build the app
	@echo "🔨 Building Ascend for $(DEVICE_NAME)..."
	@xcodebuild \
		-project Ascend.xcodeproj \
		-scheme Ascend \
		-configuration Debug \
		-destination 'generic/platform=iOS Simulator' \
		-derivedDataPath build \
		build | xcbeautify || cat

run: ## Build and run on simulator
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
