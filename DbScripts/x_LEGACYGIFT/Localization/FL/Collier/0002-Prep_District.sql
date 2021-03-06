
-- Florida
-- Collier
-- GIFTED


declare @PrgStatusSeq int ;
select @PrgStatusSeq = sequence from PrgStatus where ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1' and DeletedDate is null and Name = 'Eligible'
If not exists (select 1 from PrgStatus where Name = 'Converted EP')
begin
	update PrgStatus set Sequence = Sequence+1 where ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1' and DeletedDate is null and Sequence > @PrgStatusSeq

	insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) 
	values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900', 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1', 3, convert(varchar(50), 'Converted EP'), 0, 0, '85AAB540-503F-4613-9F1F-A14C72764285', NULL, NULL)
end
GO


-- ImportPrgSections
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.ImportPrgSections') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.ImportPrgSections
GO

CREATE TABLE x_LEGACYGIFT.ImportPrgSections (
Enabled	bit	not null,
Sequence	int	not null,
SectionType		varchar(100)	not null,
SectionDefID	uniqueidentifier not null,
FooterFormTemplateID	uniqueidentifier null,
HeaderFormTemplateID	uniqueidentifier null
)

ALTER TABLE x_LEGACYGIFT.ImportPrgSections
	ADD CONSTRAINT PK_ImportPrgSectionss PRIMARY KEY CLUSTERED
(
	SectionDefID
)
GO
set nocount on;
insert x_LEGACYGIFT.ImportPrgSections values (1, 0, 'Custom Form / Dates', '65604BD1-01BD-4CD0-929F-A082BEE7CBC5',  'DC3596BD-8ECF-475A-966D-0D090C825580',  NULL) -- Custom Form   F: Dates   H:  (none)
--insert x_LEGACYGIFT.ImportPrgSections values (0, 1, 'Custom Form / EP Present Levels', 'DF806BE1-85C9-4A5C-A4D9-12D41D14147C',  'B659273D-D369-45BF-8F85-01B7857F0635',  NULL) -- Custom Form   F: EP Present Levels   H:  (none)
--insert x_LEGACYGIFT.ImportPrgSections values (0, 2, 'IEP Goals', 'F9BCB1A3-D7D2-43E8-9B92-E269B80A2C62',  NULL,  NULL) -- IEP Goals   F:  (none)   H:  (none)
--insert x_LEGACYGIFT.ImportPrgSections values (0, 3, 'IEP Services', '8EFD24A0-46F0-4734-999A-0B4CCE2C1519',  NULL,  NULL) -- IEP Services   F:  (none)   H:  (none)

-- select * from x_LEGACYGIFT.ImportPrgSections order by Sequence


/*   use this query to create the ImportFormTemplates insert queries (copy the insertline column date and paste above.  Change the PrgItemDef ID in different states if necessary.  
	
		the method of using the insert lines instead of directly inserting from the query facilitates changing Enabled to False where required.

select ItemDef = i.Name, SectionType = t.Name, SectionDefID = s.ID, s.Sequence, 
	FooterFormCode = f.Code, FooterFormName = f.Name, FooterFormID = f.Id, 
	HeaderFormCode = h.Code, HeaderFormName = h.Name, HeaderFormID = h.Id,
	insertline = replace('insert x_LEGACYGIFT.ImportPrgSections values ('+convert(char(1), 1)+', '+convert(varchar(3), s.Sequence)+', '''+t.Name+isnull(' / '+f.name,'')+isnull(' / '+h.name,'')+''', '''+convert(varchar(36),  s.ID)+''',  '''+isnull(convert(varchar(36), f.ID),'NULL')+''',  '''+isnull(convert(varchar(36), h.ID),'NULL'')'), '''NULL''', 'NULL')+' -- '+t.name+'   F: '+isnull(f.Name,' (none)') +'   H: '+isnull(h.Name,' (none)')
from PrgItemDef i 
join PrgSectionDef s on i.ID = s.ItemDefID
join PrgSectionType t on s.TypeID = t.ID
left join FormTemplate f on s.FormTemplateID = f.Id
left join FormTemplate h on s.HeaderFormTemplateID = h.Id
where i.ID = '69942840-0E78-498D-ADE3-7454F69EA178' -- EP - Converted
order by s.Sequence




*/



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.FormInputValueFields') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.FormInputValueFields
GO

create table x_LEGACYGIFT.FormInputValueFields (
FormTemplateID	uniqueidentifier	not null,
InputFieldID	uniqueidentifier	not null
)


ALTER TABLE x_LEGACYGIFT.FormInputValueFields
	ADD CONSTRAINT PK_FormInputValueFields PRIMARY KEY CLUSTERED
(
	InputFieldID
)

create index IX_x_LEGACYGIFT_FormInputValueFields_FormTemplateID on x_LEGACYGIFT.FormInputValueFields (FormTemplateID)
GO

insert x_LEGACYGIFT.FormInputValueFields
select ftl.TemplateID, ftii.ID
-- select ft.Name, ftii.InputAreaID, ftc.IsRepeatable, ftii.Sequence, ftii.Label, ftl.TemplateID, FormTemplateInputItemID = ftii.ID, insertline = 'insert x_LEGACYGIFT.FormInputValueFields values ('''+convert(varchar(36), ftl.TemplateID)+''', '''+convert(varchar(36), ftii.ID)+''') -- '+ftii.Label+''
from dbo.FormTemplate ft 
join dbo.FormTemplateLayout ftl on ft.ID = ftl.TemplateID
join dbo.FormTemplateControl ftc on ftl.ControlID = ftc.ID
join dbo.FormTemplateControlType ftct on ftc.TypeID = ftct.ID
join dbo.FormTemplateInputItem ftii on ftc.ID = ftii.InputAreaID 
join (select TemplateID = FooterFormTemplateID from x_LEGACYGIFT.ImportPrgSections where FooterFormTemplateID is not null
	union all
	select TemplateID = HeaderFormTemplateID from x_LEGACYGIFT.ImportPrgSections where HeaderFormTemplateID is not null
	) s on ftl.TemplateID = s.TemplateID
where ftct.Name = 'Input Area'
and ftii.ID not in (select InputFieldID from x_LEGACYGIFT.FormInputValueFields)
order by ft.Name, ftii.Sequence


-- since this will evidently always be different from district to district, create this view here with the hard-coded IDs
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.EPDatesPivot') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.EPDatesPivot
GO

create view x_LEGACYGIFT.EPDatesPivot
as
select u.*, InputItemType =  iit.Name, InputItemTypeID = iit.ID
from (
	select EPRefID, DateValue = EPMeetingDate, InputFieldID = '5A25FA40-9E96-4421-88C2-24C177CAF414' -- EP Meeting Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, EPMeetingDate, InputFieldID = '9BD0C775-AD94-46C3-953D-2005854E2D13' -- EP Initiation Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, s.LastEPDate, InputFieldID = '2C41063F-F8A1-45A9-9A7F-96794A77419B' -- Last EP Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
--
	select EPRefID, NULL, InputFieldID = 'FDD3B407-77D3-4FB2-8EAE-3DE0D35A6821' -- Special Review Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
---
	select EPRefID, s.DurationDate, InputFieldID = 'D022A416-7E74-4CF0-9007-4224949D1702' -- Duration Date:
	from x_LEGACYGIFT.GiftedStudent s
	union all
	select EPRefID, NULL, InputFieldID = 'A2E3EB67-6A1F-4B88-99C9-4027B37D4ECA' -- EP Level: (SingleSelect)
	from x_LEGACYGIFT.GiftedStudent s
	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go






/*		different approach (not automated): use the following query to create the insert statements for the x_LEGACYGIFT.FormInputValueFields table


select ft.Name, ftii.InputAreaID, ftc.IsRepeatable, ftii.Sequence, ftii.Label, ftl.TemplateID, FormTemplateInputItemID = ftii.ID,
	insertline = 'insert x_LEGACYGIFT.FormInputValueFields values ('''+convert(varchar(36), ftl.TemplateID)+''', '''+convert(varchar(36), ftii.ID)+''') -- '+ftii.Label+''
from dbo.FormTemplate ft 
join dbo.FormTemplateLayout ftl on ft.ID = ftl.TemplateID
join dbo.FormTemplateControl ftc on ftl.ControlID = ftc.ID
join dbo.FormTemplateControlType ftct on ftc.TypeID = ftct.ID
join dbo.FormTemplateInputItem ftii on ftc.ID = ftii.InputAreaID 
join (select TemplateID = FooterFormTemplateID from x_LEGACYGIFT.ImportPrgSections where FooterFormTemplateID is not null
	union all
	select TemplateID = HeaderFormTemplateID from x_LEGACYGIFT.ImportPrgSections where HeaderFormTemplateID is not null
	) s on ftl.TemplateID = s.TemplateID
where ftct.Name = 'Input Area'
order by ft.Name, ftii.Sequence



This is an extract from the formletviewbuilder query that shows the input field ids that we will need to insert the date values

	--	EP Meeting Date:     < Date1 >    (Date)
	FormInputValue v_0_0 on
		v_0_0.InputFieldId = '228379F1-0C95-4D69-95DA-BFB437FFB6C5' AND
		v_0_0.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_0 on vv_0_0.ID = v_0_0.ID JOIN

	--	EP Initiation Date:     < Date2 >    (Date)
	FormInputValue v_0_1 on
		v_0_1.InputFieldId = '63CB1358-9540-4469-8C2C-6DBFB6613037' AND
		v_0_1.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_1 on vv_0_1.ID = v_0_1.ID JOIN

	--	Last EP Date:     < Date3 >    (Date)
	FormInputValue v_0_2 on
		v_0_2.InputFieldId = '4C561605-316A-498F-8793-E74300782C9B' AND
		v_0_2.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_2 on vv_0_2.ID = v_0_2.ID JOIN

	--	Duration Date:     < Date5 >    (Date)
	FormInputValue v_0_3 on
		v_0_3.InputFieldId = '94CD1E37-59A4-4B4C-B7AC-811E657F94FE' AND
		v_0_3.Intervalid = i.ID JOIN
	FormInputDateValue vv_0_3 on vv_0_3.ID = v_0_3.ID JOIN
*/





if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'GiftedConversionWrapUp')
drop procedure x_LEGACYGIFT.GiftedConversionWrapUp
go

create procedure x_LEGACYGIFT.GiftedConversionWrapUp
as
-- this should run for all districts in all states
update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')

exec dbo.Util_VerifyProgramDataAssumptions 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1'

GO


--select * from PrgMilestoneDef where ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')
-- select * from PrgMilestoneDef where ProgramID = 'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1'
