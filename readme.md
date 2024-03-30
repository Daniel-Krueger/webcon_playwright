NVM to manage node.js version
https://github.com/coreybutler/nvm-windows/releases
https://github.com/coreybutler/nvm-windows/
The simplest (recommended) way to get NVM for Windows running properly is to uninstall any prior Node installation before installing NVM for Windows. It avoids all of the pitfalls listed below. However; you may not wish to nuke your Node installation if you've highly customized it

Command
nvm install latest
nvm use 21.7.1
https://playwright.dev/docs/intro

npm init playwright@latest

Initializing project in '.'
√ Do you want to use TypeScript or JavaScript? · JavaScript
√ Where to put your end-to-end tests? · tests
√ Add a GitHub Actions workflow? (y/N) · false
√ Install Playwright browsers (can be done manually via 'npx playwright install')? (Y/n) · true


# Test
npx playwright test

# Recording

https://playwright.dev/docs/codegen#recording-a-test