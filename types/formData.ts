import { chromium, Browser, Page } from "playwright";
import { test, expect } from "@playwright/test";
import { IField } from "./fields";
import { getIdFromUrl } from "./helpers";

declare const window: any;

export interface IFormData {
  controls: IField[];
  pathId: number;
  currentStepId: number;
}

export class EnrichedFormData implements IFormData {
  controls: IField[];
  pathId: number;
  /** The translated path title for the current user*/
  pathTitle: string;
  currentStepId: number;
  /** The translated path title for the current user */
  currentStepTitle: number;
  private constructor(formData: IFormData) {
    this.controls = formData.controls;
    this.pathId = formData.pathId;
    this.currentStepId = formData.currentStepId;
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
    if (this.pathId > 0) {
      var pathObject = model.liteData.liteModel.paths.find(
        (obj) => obj.id === this.pathId
      );
      this.pathTitle = pathObject.title;
      expect(this.pathTitle).not.toBeNull();
    }
    var stepObject =
      model.liteData.liteModel.formInfo.stepsHistoryInfo.stepInfos.find(
        (obj) => obj.stepId === this.currentStepId
      );
    this.currentStepTitle = stepObject.stepName;
    expect(this.currentStepTitle).not.toBeNull();
  }
}
