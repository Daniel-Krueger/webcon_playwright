import { chromium, Browser, Page } from "playwright";

export async function getWindowsAuthenticatedPage(
  browser: Browser,
  targetURL: string,
  username: string,
  password: string
) {
  const context = await browser.newContext({
    httpCredentials: {
      password: password,
      username: username,
    },
  });
  //await context.setHTTPCredentials({username: '.\\demo1', password: 'WIXCyjd3ii4eXIrbALet'});
  const page = await context.newPage();
  let url = new URL(targetURL);
  let returnUrl = encodeURI(url.href.substring(url.origin.length));
  await page.goto(url.origin + "/api/login/authorize?ReturnUrl=" + returnUrl);
  return page;
}
