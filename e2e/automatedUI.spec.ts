import { test, expect, Page } from "@playwright/test";
import { getAuthenticatedPage } from "../types/authentication";
import { EnrichedFormData } from "../types/formData";
import {
  getIdFromUrl,
  setAndCheckControls,
  showDetailsInfoTab,
} from "../types/helpers";
import environment from "../.auth/simpleApprovalEnvironment";

import { data as submitData } from "./automatedUI/Automated UI/Start/formData";
import { data as approvalData } from "./automatedUI/Automated UI/In approval/formData";
import { data as approvedData } from "./automatedUI/Automated UI/Approved/formData";

test.describe.serial("Submit and approve", () => {
  let signature: string;
  // Element id to us, in case a specific test should be used/debugged.
  let wfElementId: number = 2304;

  test("Submit workflow as user 1", async ({ browser }) => {
    // Target url
    let url =
      environment.hostname + "/db/14/app/50/start/wf/78/dt/85/form?def_comid=1";

    // Authenticate
    const page = await getAuthenticatedPage(browser, url, environment.userOne);

    // Update data with multilingual labels
    const data = await EnrichedFormData.BuildInstance(page, submitData);

    // Verify that the workflow is in step 'In approval' by checking that this step is marked as 'Active' in the information panel.
    await showDetailsInfoTab(page);
    expect(await page.locator(".step-info-row--active").innerText()).toBe(
      data.currentStepTitle
    );

    // Set value and verify it was set.
    await setAndCheckControls(page, data.controls);

    // Path transition
    await page.getByRole("button", { name: data.pathTitle }).click();

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

    // Update data with multilingual labels
    const data = await EnrichedFormData.BuildInstance(page, approvalData);

    // Verify that the workflow is in step 'In approval' by checking that this step is marked as 'Active' in the information panel.
    await showDetailsInfoTab(page);
    expect(await page.locator(".step-info-row--active").innerText()).toBe(
      data.currentStepTitle
    );

    // Set value and verify it was set.
    await setAndCheckControls(page, data.controls);

    // Check the "green" notification of the successful path transition is displayed
    await page.getByRole("button", { name: data.pathTitle }).click();
    expect(await page.locator(".signature-button")).toBeVisible();
  });

  test("Verify is approved", async ({ browser }) => {
    // Target url
    let url = environment.hostname + `/db/14/app/50/element/${wfElementId}`;
    // Authenticate
    const page = await getAuthenticatedPage(browser, url, environment.userOne);

    // Update data with multilingual labels
    const data = await EnrichedFormData.BuildInstance(page, approvedData);

    // Verify that the workflow is in step 'In approval' by checking that this step is marked as 'Active' in the information panel.
    await showDetailsInfoTab(page);
    expect(await page.locator(".step-info-row--active").innerText()).toBe(
      data.currentStepTitle
    );
  });
});
