import { chromium, Browser, Page } from "playwright";
import { test, expect } from "@playwright/test";
import exp from "constants";

declare const window: any;

export interface IFormData {
  formInfo: IField[];
  pathId: number;
  currentStepId: number;
}

export interface IFieldContainer {
  controls: IField[];
}
export interface IField {
  label: string;
  locator: string;
  column: string;
}

export class TabField implements IField, IFieldContainer {
  locator: string;
  column: string = "Tab";
  controls: IField[];
  constructor(public label: string, public id: number, controls?: IField[]) {
    this.locator = `div[aria-controls='${this.column}_${this.id}']`;
    this.controls = controls ?? [];
  }
}

export class GroupField implements IField, IFieldContainer {
  locator: string;
  column: string = "Group";
  controls: IField[];
  constructor(public label: string, public id: number, controls?: IField[]) {
    this.locator = `#${this.column}_${this.id}`;
    this.controls = controls ?? [];
  }
}
export abstract class BaseField implements IField {
  locator: string;
  constructor(
    public label: string,
    public column: string,
    public value: any,
    public isRequired?: boolean
  ) {
    this.label = label;
    this.column = column;
    this.value = value;
    this.isRequired = isRequired ?? false;
  }
  checkRequired = async function (page: Page) {
    if (this.isRequired) {
      await expect(
        page.locator(`#${this.column} .requiredAttribute`),
        `Field ${this.label} (${this.column}) is not marked as required.`
      ).toBeVisible({ timeout: 200 });
    }
  };
  /** Sets the defined value and verifies, that the value is stored in the model. If the field is defined as required it's also checked whether this is true.*/
  set = async function (page: Page) {
    await this.checkRequired(page);
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
  constructor(label: string, column: string, value: any, isRequired?: boolean) {
    super(label, column, value, isRequired);
    this.locator = `#${this.column} input`;
  }
}
export class NumberField extends BaseField {
  constructor(label: string, column: string, value: any, isRequired?: boolean) {
    super(label, column, value, isRequired);
    this.locator = `#${this.column} input`;
  }
  override set = async function (page: Page) {
    await this.checkRequired(page);
    const element = page.locator(this.locator);
    const textValue = this.value?.toString();
    await element.fill(textValue);
    await element.blur();
    expect(
      await page.evaluate((columnName) => {
        return window.GetValue(columnName);
      }, this.column)
    ).toBe(textValue);
  };
}

export class MultiLineTextField extends BaseField {
  constructor(label: string, column: string, value: any, isRequired?: boolean) {
    super(label, column, value, isRequired);
    this.locator = `#${this.column} textarea`;
  }
}

export class ChooseFieldPopupSearch extends BaseField {
  constructor(label: string, column: string, value: any, isRequired?: boolean) {
    super(label, column, value, isRequired);
    this.locator = `#${this.column} button.picker-search-button`;
  }

  override set = async function (page: Page) {
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
