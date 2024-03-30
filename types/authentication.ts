import { chromium, Browser, Page } from "playwright";

export interface IEnvironment {
  hostname: string;
  [key: string]: string | any;
}
export interface IUser {
  username: string;
  password: string;
  authenticationType: AuthenticationType;
}

export enum AuthenticationType {
  Windows = 1,
  AzureAD = 2
}

export async function getAuthenticatedPage(
  browser: Browser,
  targetURL: string,
  user: IUser
): Promise<Page> {
  if (user.authenticationType == AuthenticationType.Windows) {
    return getWindowsAuthenticatedPage(browser, targetURL, user);
  }
  throw `Authentication type '${user.authenticationType}' is not implemented`;
}

async function getWindowsAuthenticatedPage(
  browser: Browser,
  targetURL: string,
  user: IUser
) {
  const context = await browser.newContext({
    httpCredentials: {
      username: user.username,
      password: user.password,
    },
  });
  //await context.setHTTPCredentials({username: '.\\demo1', password: 'WIXCyjd3ii4eXIrbALet'});
  const page = await context.newPage();
  let url = new URL(targetURL);
  let returnUrl = encodeURI(url.href.substring(url.origin.length));
  await page.goto(url.origin + "/api/login/authorize?ReturnUrl=" + returnUrl);
  return page;
}
