import { chromium, Browser, Page } from "playwright";
import { test, expect } from "@playwright/test";
import { BaseField, GroupField, IField, IFormData, TabField } from "./fields";
import { EnrichedFormData } from "./formData";
import { group } from "console";

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

  await page.locator("#formContainer #toolbar").first().waitFor();
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

export async function setAndCheckControls(page: Page, controls: IField[]) {
  for (const control of controls) {
    if (control instanceof TabField) {
      // Activate the tab and process all controls.
      await page
        .locator(
          "ul:not(.tab-panel__header__hidden-content) " + control.locator
        )
        .click();
      await setAndCheckControls(page, control.controls);
    } else if (control instanceof GroupField) {
      const groupElement = page.locator(control.locator + "children");
      if ((await groupElement.all()).length == 0) {
        await groupElement.click();
      }      
      await setAndCheckControls(page, control.controls);
    } else if (control instanceof BaseField) {
      await control.set(page);
    }
  }
}
