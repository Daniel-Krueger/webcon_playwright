import { test, expect, Page } from "@playwright/test";
import { getAuthenticatedPage } from "../types/authentication";
import { ChooseFieldPopupSearch, MultiLineTextField, TextField } from "../types/fields";
import { IFormData, EnrichedFormData } from "../types/formData";
import { getIdFromUrl, showDetailsInfoTab } from "../types/helpers";
import environment from "../.auth/simpleApprovalEnvironment";


const submitData: IFormData = {
  fieldValues: [
    new TextField("Title", "AttText1Glob", "My title"),
    new ChooseFieldPopupSearch("Responsible", "AttChoose1", "Demo Two"),
    new MultiLineTextField(
      "Description",
      "AttLong1",
      "My long text\r\nsome new line."
    ),
  ],
  pathId: 292, // Submit
};

const approvalData: IFormData = {
  fieldValues: [
    new MultiLineTextField("Decision", "AttLong2", "Yes, it's approved."),
  ],
  pathId: 293, // Approve
};

test.describe.serial("Submit and approve", () => {
  let signature: string;
  // Element id to us, in case a specific test should be used/debugged.
  let wfElementId: number = 2270;

  test("Submit workflow as user 1", async ({ browser }) => {
    // Target url
    let url =
      environment.hostname + "/db/14/app/50/start/wf/78/dt/85/form?def_comid=1";

    // Authenticate
    const page = await getAuthenticatedPage(browser, url, environment.userOne);

    // Update data with multilingual labels
    const data = await EnrichedFormData.BuildInstance(page, submitData);

    // Set value and verify it was set.
    for (const field of data.fieldValues) {
      await field.setAndExpect(page);
    }

    // Path transition
    await page.getByRole("button", { name: data.pathName }).click();

    // Check the "green" notification of the successful path transition is displayed
    signature = await page.locator(".signature-button").innerText();
    await page.locator(".signature-button").click();

    // Get started workflow instance id by displaying the form again and get the id from the url.
    // Using a test scoped variable  makes it accessible in the other tests.
    let elementUrl = await page.url();
    wfElementId = getIdFromUrl("element", elementUrl);
  });

  test("Approve as user two", async ({ browser }) => {
    // Target url
    let url = environment.hostname + `/db/14/app/50/element/${wfElementId}`;

    // Authenticate
    const page = await getAuthenticatedPage(browser, url, environment.userTwo);

    // Verify that the workflow is in step 'In approval' by checking that this step is marked as 'Active' in the information panel.
    await showDetailsInfoTab(page);
    expect(await page.locator(".step-info-row--active").innerText()).toBe(
      "In approval"
    );

    // Update data with multilingual labels
    const data = await EnrichedFormData.BuildInstance(page, approvalData);

    // Set value and verify it was set.
    for (const field of data.fieldValues) {
      await field.setAndExpect(page);
    }

    // Check the "green" notification of the successful path transition is displayed
    await page.getByRole("button", { name: data.pathName }).click();
    expect(await page.locator(".signature-button")).toBeVisible();
  });

  test("Verify is approved", async ({ browser }) => {
    // Target url
    let url = environment.hostname + `/db/14/app/50/element/${wfElementId}`;
    // Authenticate
    const page = await getAuthenticatedPage(browser, url, environment.userTwo);

    // Verify that the workflow is in step 'Approved' by checking that this step is marked as 'Active' in the information panel.
    await showDetailsInfoTab(page);
    expect(await page.locator(".step-info-row--active").innerText()).toBe(
      "Approved"
    );
  });
});
