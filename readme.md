# Overview
These are just a few nodes taken during the preparation and installation of Playwright. Mostly these are excerpts from the official documentation.

# Tool installation
## NVM to manage node.js version

https://github.com/coreybutler/nvm-windows/releases
https://github.com/coreybutler/nvm-windows/
The simplest (recommended) way to get NVM for Windows running properly is to **uninstall any prior Node installation before installing NVM for Windows**. It avoids all of the pitfalls listed below. However; you may not wish to nuke your Node installation if you've highly customized it

After NVM installation:
Terminal commands:
nvm install latest
nvm use 21.7.1

## Playwright
https://playwright.dev/docs/intro

npm init playwright@latest

Initializing project in '.'
√ Do you want to use TypeScript or JavaScript? · Typescript
√ Where to put your end-to-end tests? · tests
√ Add a GitHub Actions workflow? (y/N) · false
√ Install Playwright browsers (can be done manually via 'npx playwright install')? (Y/n) · true


## VS Code extension
Playwright Test for VSCode
https://marketplace.visualstudio.com/items?itemName=ms-playwright.playwright

# Playwright 
# Test
Terminal commands:
npx playwright test
npx playwright test -ui

# Recording
https://playwright.dev/docs/codegen#recording-a-test

# Blog posts
These are related blog posts ordered by publishing date and there respective branch.
- https://daniels-notes.de/posts/2024/playwright<br/>
  https://github.com/Daniel-Krueger/webcon_playwright/tree/iteration1