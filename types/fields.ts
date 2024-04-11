import { chromium, Browser, Page } from "playwright";
import { test, expect, Locator } from "@playwright/test";
import exp from "constants";
import { error } from "console";

declare const window: any;

export enum FieldActionType {
  // Example values, replace with your actual ActionType enum members
  SetAndCheck,
  CheckOnly,
}

interface FieldOptions {
  isRequired?: boolean;
  action?: FieldActionType;
}

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
  isRequired: boolean;
  /** The default action type will be Set and check, you can overwrite it with an option. */
  actionType: FieldActionType;
  constructor(
    public label: string,
    public column: string,
    public value: any,
    options?: FieldOptions
  ) {
    this.isRequired = options?.isRequired ?? false;
    this.actionType = options?.action ?? FieldActionType.SetAndCheck;
  }

  action = async function (page: Page) {
    switch (this.actionType) {
      case FieldActionType.CheckOnly:
        await this.checkValue(page);
        break;
      case FieldActionType.SetAndCheck:
        await this.set(page);
        break;
      default:
        throw "not implemented";
    }
  };
  checkValue = async function (page: Page) {
    const elementLocator = page.locator(`#${this.column}`);
    let valueLocator: Locator;
    console.log(
      "Number of inputs " + (await elementLocator.locator("input").count())
    );
    if ((await elementLocator.locator("input").count()) == 1) {
      expect(await elementLocator.locator("input").inputValue()).toBe(
        this.value.toString()
      );
    } else {
      expect(await elementLocator.locator(".form-control-readonly").innerText).toBe(
        this.value.toString()
      );
    }    
  };
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
  constructor(
    label: string,
    column: string,
    value: any,
    options?: FieldOptions
  ) {
    super(label, column, value, options);
    this.locator = `#${this.column} input`;
  }
}
export class NumberField extends BaseField {
  constructor(
    label: string,
    column: string,
    value: any,
    options?: FieldOptions
  ) {
    super(label, column, value, options);
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
  constructor(
    label: string,
    column: string,
    value: any,
    options?: FieldOptions
  ) {
    super(label, column, value, options);
    this.locator = `#${this.column} textarea`;
  }
}

export class ChooseFieldPopupSearch extends BaseField {
  constructor(
    label: string,
    column: string,
    value: any,
    options?: FieldOptions
  ) {
    super(label, column, value, options);
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
