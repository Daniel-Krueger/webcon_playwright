
# Important information
## General
Before you continue with the post or heading over to the GitHub repository you should take the following into account:
1. No previous experience<br/>
   I'm just on a beginner level in terms of Playwright and TypeScript. Experienced persons would have done a few things differently with the test creation let alone aspects like scaling. 
2. InstantChange™️ / Breaking changes<br/>
   I will be using the same approach as I preach when creating processes:
   - Create a prototype
   - Gain experience 
   - Restart if necessary 
   - Deploy an improved version<br/>
  
   This means that the current version is just a prototype and I'm sure, that there will be breaking changes. Nevertheless, my aim is to provide and easy to use framework.
3. Collaboration<br/>
   I've never really collaborated in the context of GitHub repositories. Maybe it's a good time to gain experience with this. If you want to participate, you can reach out to me.
4. Multilingual support / changing labels<br/>
   While this is a strength of WEBCON BPS, this makes it quite hard for automated testing. I don't like the idea, that a test fails just because someone changed the language of the test user or changed the label. On the other hand, this is what UI tests are about, to a degree at least. I've not yet decided on a concept on how to approach this. 
5. Blog post focus<br/>
   My posts will focus on using the custom logic and not on Playwright or TypeScript in general. At the moment, it's also not my focus to provide tests which can be in attended environment. For example, the browser will be open at the end of the tests.
6. Recording tests<br/>
   At first I started with [generating test](https://playwright.dev/docs/codegen#recording-a-test), but I quickly moved to coded tests. For these, I created some classes / functions which simplify the actual test definition. 

## Target audience
Even so I'm going for an easy-to-use test creation, I assume that you already have experience with VS Code, JavaScript/TypeScript or are willing to learn it on your own.


## License
For this repository I've chosen the license [GNU General Public License v3.0](https://choosealicense.com/licenses/gpl-3.0/). This is an excerpt from the referenced page from 2024-03-31.

>Permissions of this strong copyleft license **are conditioned on making available complete source code** of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights. 
>
>| Permissions    | Conditions                   | Limitations |
>|----------------|------------------------------|-------------|
>| Commercial use | Disclose source              | Liability   |
>| Distribution   | License and copyright notice | Warranty    |
>| Modification   | Same license                 |             |
>| Patent use     | State changes                |             |
>| Private use    |                              |             |


# Overview
These are just a few nodes taken during the preparation and installation of Playwright. Mostly these are excerpts from the official documentation.

## Tool installation
## NVM to manage node.js version

https://github.com/coreybutler/nvm-windows/releases
https://github.com/coreybutler/nvm-windows/
The simplest (recommended) way to get NVM for Windows running properly is to **uninstall any prior Node installation before installing NVM for Windows**. It avoids all of the pitfalls listed below. However; you may not wish to nuke your Node installation if you've highly customized it

After NVM installation:
Terminal commands:
nvm install latest
nvm use 21.7.1

### Playwright
https://playwright.dev/docs/intro

npm init playwright@latest

Initializing project in '.'
√ Do you want to use TypeScript or JavaScript? · Typescript
√ Where to put your end-to-end tests? · tests
√ Add a GitHub Actions workflow? (y/N) · false
√ Install Playwright browsers (can be done manually via 'npx playwright install')? (Y/n) · true


### VS Code extension
Playwright Test for VSCode
https://marketplace.visualstudio.com/items?itemName=ms-playwright.playwright

## Playwright 
# Test
Terminal commands:
npx playwright test
npx playwright test -ui

## Recording
https://playwright.dev/docs/codegen#recording-a-test

## Blog posts
https://daniels-notes.de/tags/#automated-ui-tests
