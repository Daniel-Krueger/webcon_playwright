import { chromium, Browser, Page } from "playwright";
import { test, expect } from "@playwright/test";

declare const window: any;

export abstract class BaseField {
  label: string;
  column: string;
  value: any;
  locator: string;
  constructor(label: string, column: string, value: any) {
    this.label = label;
    this.column = column;
    this.value = value;
  }

  setAndExpect = async function (page: Page) {
    const element = page.locator(this.locator);
    await element.fill(this.value);
    await element.blur();
    expect(
      await page.evaluate((columnName) => {
        return window.GetValue(columnName);
      }, this.column)
    ).toBe(this.value);
  };
}

export class TextField extends BaseField {
  constructor(label: string, column: string, value: any) {
    super(label, column, value);
    this.locator = `#${this.column} input`;
  }
}

export class MultiLineTextField extends BaseField {
  constructor(label: string, column: string, value: any) {
    super(label, column, value);
    this.locator = `#${this.column} textarea`;
  }
}

export class ChooseField extends BaseField {
  constructor(label: string, column: string, value: any) {
    super(label, column, value);
    this.locator = `#${this.column} button.picker-search-button`;
  }

  override setAndExpect = async function (page: Page) {
    await page.locator(this.locator).click();
    await page.locator(".picker-search__input").fill(this.value);
    await page.locator(".picker-search__input").press("Enter");
    await page.locator("td:nth-child(1)").click();
    const regEx = new RegExp(".*#" + this.value);
    expect(
      await page.evaluate((columnName) => {
        return window.GetValue(columnName);
      }, this.column)
    ).toMatch(regEx);
  };
}
