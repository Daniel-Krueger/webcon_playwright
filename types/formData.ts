import { chromium, Browser, Page } from "playwright";
import { test, expect } from "@playwright/test";
import { BaseField } from "./fields";
import { getIdFromUrl } from "./helpers";

declare const window: any;

export interface IFormData {
  fieldValues: BaseField[];
  pathId: number;
}

export class EnrichedFormData implements IFormData {
  fieldValues: BaseField[];
  pathId: number;
  pathName: string;
  private constructor(formData: IFormData) {
    this.fieldValues = formData.fieldValues;
    this.pathId = formData.pathId;
  }

  static async BuildInstance(
    page: Page,
    data: IFormData
  ): Promise<EnrichedFormData> {
    const url = page.url();
    let desktopUrl: string;
    if (url.indexOf("/start/") > -1) {
      desktopUrl = url
        .replace("/db/", "/api/nav/db/")
        .replace("/form", "/desktop");
    } else {
      const urlObject = new URL(url);
      desktopUrl = `${urlObject.origin}/api/nav/db/${getIdFromUrl(
        "db",
        url
      )}/app/${getIdFromUrl("app", url)}/element/${getIdFromUrl(
        "element",
        url
      )}/desktop`;
    }

    const liteModel = await (await page.request.get(desktopUrl)).json();
    const enrichedFormData = new EnrichedFormData(data);
    enrichedFormData.updateValuesFromModel(liteModel);
    return enrichedFormData;
  }

  private updateValuesFromModel(model: any) {
    var pathObject = model.liteData.liteModel.paths.find(
      (obj) => obj.id === this.pathId
    );
    this.pathName = pathObject.title;
    expect(this.pathName).not.toBeNull();
  }
}
