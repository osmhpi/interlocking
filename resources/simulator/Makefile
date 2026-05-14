node_modules: package.json package-lock.json interlocking/interlocking.js
	npm ci

build: app/welcome/configuration.json node_modules
	npm run build

dev: app/welcome/configuration.json node_modules
	npm run dev

web: build
	npm run start
