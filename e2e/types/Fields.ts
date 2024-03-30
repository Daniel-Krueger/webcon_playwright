import { chromium, Browser, Page } from "playwright";
import { test, expect } from "@playwright/test";

declare const window: any;

export interface Data {
  fieldValues: BaseField[];
}
export abstract class BaseField {
  Label: string;
  Column: string;
  Value: any;
  Locator: string;
  constructor(Label: string, Column: string, Value: any) {
    this.Label = Label;
    this.Column = Column;
    this.Value = Value;
  }

  setAndExpect = async function (page: Page) {
    const element = page.locator(this.Locator);
    await element.fill(this.Value);
    await element.blur();
    expect(
      await page.evaluate((columnName) => {
        return window.GetValue(columnName);
      }, this.Column)
    ).toBe(this.Value);
  };
}

export class TextField extends BaseField {
  constructor(Label: string, Column: string, Value: any) {
    super(Label, Column, Value);
    this.Locator = `#${this.Column} input`;
  }
}

export class MultiLineTextField extends BaseField {
  constructor(Label: string, Column: string, Value: any) {
    super(Label, Column, Value);
    this.Locator = `#${this.Column} textarea`;
  }
}

export class ChooseField extends BaseField {
  constructor(Label: string, Column: string, Value: any) {
    super(Label, Column, Value);
    this.Locator = `#${this.Column} button.picker-search-button`;
  }

  override setAndExpect = async function (page: Page) {
    await page.locator(this.Locator).click();
    await page.locator(".picker-search__input").fill(this.Value);
    await page.locator(".picker-search__input").press("Enter");
    await page.locator("td:nth-child(1)").click();
    const regEx = new RegExp(".*#" + this.Value);
    expect(
      await page.evaluate((columnName) => {
        return window.GetValue(columnName);
      }, this.Column)
    ).toMatch(regEx);
  };
}
