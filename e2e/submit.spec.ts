import { test, expect } from "@playwright/test";
import { ChooseField, Data, MultiLineTextField, TextField } from "./Fields";
import environment from "../.auth/environment.json";
import { getWindowsAuthenticatedPage } from "./authentication";
declare const window: any;

const data: Data = {
  fieldValues: [
    new TextField("Title", "AttText1Glob", "My title"),
    new MultiLineTextField(
      "Description",
      "AttLong1",
      "My long text\r\nsome new line."
    ),
    new ChooseField("Responsible", "AttChoose1", "Demo Two"),
  ],
};

test("Submit Workflow as user 1", async ({ browser }) => {
  let url =
    environment.hostname + "/db/14/app/50/start/wf/78/dt/85/form?def_comid=1";
  const page = await getWindowsAuthenticatedPage(
    browser,
    url,
    environment.userOne.username,
    environment.userOne.password
  );
  for (const field of data.fieldValues) {
    await field.setAndExpect(page);
  }

  await page.evaluate(() => {
    window.webcon.businessRules.moveToNextStep(292);
  });

  await page.waitForURL(environment.hostname + "/db/14/app/50");
});

test("test", async ({ page }) => {
  const demo1User = "WIN-1VCPISF669L\\demo1:WIXCyjd3ii4eXIrbALet";
  const authHeader = "Basic " + btoa(demo1User);
  page.setExtraHTTPHeaders({ Authorization: authHeader });
  await page.goto(
    "https://bps.daniels-notes.de/api/login/authorize?ReturnUrl=%2Fdb%2F14%2Fapp%2F50%2Fstart%2Fwf%2F78%2Fdt%2F85%2Fform%3Fdef_comid%3D1"
  );
  await page.getByRole("link", { name: "Windows Active Directory" }).click();

  let test = await page.waitForResponse(
    "https://bps.daniels-notes.de/api/login/authorize.*"
  );
  //let request = await page.waitForRequest("https://bps.daniels-notes.de/api/login/authorize.*");

  await page
    .locator(
      "#AttText1Glob > .validation-error-panel > .row > .col-sm-5 > .typography > .stylePanel > .attributeLabelRequirednessWrapper"
    )
    .click();

  // await page.goto('https://bps.daniels-notes.de/');
  // await page.getByRole('link', { name: 'AU Automated UI' }).click();
  // await page.getByText('Start', { exact: true }).click();
  // await page.getByRole('combobox').selectOption('2');
  // await page.getByRole('button', { name: 'Start' }).click();
  // await page.getByLabel('Business entity').click();
  // await page.getByLabel('Title').click();
  // await page.getByLabel('Title').fill('My title');
  // await page.getByLabel('Title').press('Tab');
  // await page.getByPlaceholder(' ').fill('My description');
  // await page.getByPlaceholder(' ').press('Tab');
  // await page.getByLabel('Search', { exact: true }).click();
  // await page.getByPlaceholder('Text to search').click();
  // await page.getByPlaceholder('Text to search').fill('Demo two');
  // await page.getByPlaceholder('Text to search').press('Enter');
  // await page.locator('td:nth-child(4)').click();
  // await page.getByRole('button', { name: 'Submit' }).click();
});
