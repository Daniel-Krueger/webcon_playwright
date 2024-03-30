import { test, expect, Page } from "@playwright/test";
import { ChooseField, MultiLineTextField, TextField } from "../types/fields";
import { IFormData, EnrichedFormData } from "../types/formData";
import environment from "../.auth/environment";
import { getAuthenticatedPage } from "../types/authentication";
import { getIdFromUrl, showDetailsInfoTab } from "../types/helpers";

declare const window: any;

const submitData: IFormData = {
  fieldValues: [
    new TextField("Title", "AttText1Glob", "My title"),
    new MultiLineTextField(
      "Description",
      "AttLong1",
      "My long text\r\nsome new line."
    ),
    new ChooseField("Responsible", "AttChoose1", "Demo Two"),
  ],
  pathId: 292, // Submit
};

const approveData: IFormData = {
  fieldValues: [
    new MultiLineTextField("Decision", "AttLong2", "Yes, it's approved."),
  ],
  pathId: 293, // Approve
};

test.describe.serial("Submit and approve", () => {
  let signature: string;
  let wfElementId: number = 2268;

  test("Submit Workflow as user 1", async ({ browser }) => {
    let url =
      environment.hostname + "/db/14/app/50/start/wf/78/dt/85/form?def_comid=1";
    const page = await getAuthenticatedPage(browser, url, environment.userOne);
    const data = await EnrichedFormData.BuildInstance(page, submitData);
    for (const field of data.fieldValues) {
      await field.setAndExpect(page);
    }

    await page.getByRole("button", { name: data.pathName }).click();

    signature = await page.locator(".signature-button").innerText();
    await page.locator(".signature-button").click();
    let elementUrl = await page.url();
    wfElementId = getIdFromUrl("element", elementUrl);
  });

  test("Approve as user two", async ({ browser }) => {
    let url = environment.hostname + `/db/14/app/50/element/${wfElementId}`;
    const page = await getAuthenticatedPage(browser, url, environment.userTwo);
    const data = await EnrichedFormData.BuildInstance(page, approveData);
     for (const field of data.fieldValues) {
      await field.setAndExpect(page);
    }
    await page.getByRole("button", { name: data.pathName }).click();
    expect(await page.locator(".signature-button")).toBeVisible();
  });

  test("Verify is approved", async ({ browser }) => {
    let url = environment.hostname + `/db/14/app/50/element/${wfElementId}`;
    const page = await getAuthenticatedPage(browser, url, environment.userTwo);
    await showDetailsInfoTab(page);
    expect(await page.locator(".step-info-row--active").innerText()).toBe(
      "Approved"
    );
  });
});
