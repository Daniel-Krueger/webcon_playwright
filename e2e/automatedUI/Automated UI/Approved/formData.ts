import * as FieldDefinitions from "types/fields"
import { IFormData } from "types/formData"

export const data: IFormData = {
// pathId: 295, // test path visibility: Visible
currentStepId: 229, // Approved
controls: [
new FieldDefinitions.MultiLineTextField("Decision", "AttLong2","My long text\nsome new line.",{
isRequired: false,
editability: FieldDefinitions.FieldEditability.ReadOnly,
visibility: FieldDefinitions.FieldVisibility.Visible,
action: FieldDefinitions.FieldActionType.CheckOnly,
}),
new FieldDefinitions.TabPanelField("New tab panel", 1023, [
new FieldDefinitions.TabField("General", 1026, [
new FieldDefinitions.TextField("Title", "AttText1Glob","Some title",{
isRequired: true,
editability: FieldDefinitions.FieldEditability.ReadOnly,
visibility: FieldDefinitions.FieldVisibility.Visible,
action: FieldDefinitions.FieldActionType.CheckOnly,
}),
new FieldDefinitions.MultiLineTextField("Description", "AttLong1","Yes, it's approved.",{
isRequired: true,
editability: FieldDefinitions.FieldEditability.ReadOnly,
visibility: FieldDefinitions.FieldVisibility.Visible,
action: FieldDefinitions.FieldActionType.CheckOnly,
}),
]),
new FieldDefinitions.TabField("Second tab", 1025, [
new FieldDefinitions.NumberField("Input field", "AttInt1",2.0,{
isRequired: true,
editability: FieldDefinitions.FieldEditability.ReadOnly,
visibility: FieldDefinitions.FieldVisibility.Visible,
action: FieldDefinitions.FieldActionType.CheckOnly,
}),
new FieldDefinitions.GroupField("Output", 1027, [
new FieldDefinitions.NumberField("Output by form rule", "AttInt2",4.0,{
isRequired: true,
editability: FieldDefinitions.FieldEditability.ReadOnly,
visibility: FieldDefinitions.FieldVisibility.Visible,
action: FieldDefinitions.FieldActionType.CheckOnly,
}),
new FieldDefinitions.NumberField("Output by form rule with business rule", "AttInt3",6.0,{
isRequired: true,
editability: FieldDefinitions.FieldEditability.Editable,
visibility: FieldDefinitions.FieldVisibility.Hidden,
action: FieldDefinitions.FieldActionType.SetAndCheck,
}),
]),
]),
]),
new FieldDefinitions.GroupField("Roles", 1024, [
new FieldDefinitions.ChooseFieldPopupSearch("Responsible", "AttChoose1","Demo Two",{
isRequired: true,
editability: FieldDefinitions.FieldEditability.ReadOnly,
visibility: FieldDefinitions.FieldVisibility.Visible,
action: FieldDefinitions.FieldActionType.CheckOnly,
}),
]),
]}

