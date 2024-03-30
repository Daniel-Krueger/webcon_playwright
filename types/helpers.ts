import { chromium, Browser, Page } from "playwright";
import { test, expect } from "@playwright/test";

export function getIdFromUrl(precedingElement: string, url: string): number {
  const regex = new RegExp("/" + precedingElement + "/([0-9]+)(/|$)");
  const matches = url.match(regex);

  // Check if matches is not null and has at least two elements
  if (matches && matches.length == 3) {
    return Number(matches[1]); // Return the first captured group
  } else
    throw `The provided URL '${url}' return no or multiple matches for '${precedingElement}'`;
}

export async function showDetailsInfoTab(page: Page) {
  // Are steps visible
  //expect(await page.locator("div[data-name='stepInfos']")).toBeVisible();

  await page.locator("#formContainer #toolbar").waitFor();
  if ((await page.locator("div[data-name='stepInfos']").isVisible()) == false) {
    // Is details tab of info panel visible
    if ((await page.locator("#info-panel").isVisible()) == false) {
      // Activate info panel
      await page.locator(".infoBtn").click();
    }
    // Show details tab regardless of whether it's currently displayed or not.
    await page.locator("#info-panel").click();
  }
  expect(await page.locator("div[data-name='stepInfos']")).toBeVisible();
}

