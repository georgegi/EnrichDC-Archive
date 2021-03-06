BEGIN TRAN

set nocount on;update VC3ETL.LoadTable set LastLoadDate = NULL where ExtractDatabase='35612529-9F3D-4971-A3DD-90E795E39080';

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractDatabase TABLE (ID uniqueidentifier, Type uniqueidentifier, DatabaseType uniqueidentifier, Server varchar(64), DatabaseOwner varchar(64), DatabaseName varchar(128), Username varchar(32), Password varchar(32), LinkedServer varchar(100), IsLinkedServerManaged bit, LastExtractDate datetime, LastLoadDate datetime, SucceededEmail varchar(500), SucceededSubject text, SucceededMessage text, FailedEmail varchar(500), FailedSubject text, FailedMessage text, RetainSnapshot bit, DestTableTempSuffix varchar(30), DestTableFinalSuffix varchar(30), FileGroup varchar(64), Schedule uniqueidentifier, Name varchar(100), Enabled bit)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractDatabase VALUES ('35612529-9f3d-4971-a3dd-90e795e39080', '049884c0-518a-4c24-8772-cda3aeeefe0d', '58ba0c59-5087-4f38-b00b-f3480c93064b', NULL, NULL, NULL, NULL, NULL, NULL, 0, '6/19/2013 9:33:03 AM', '6/19/2013 9:33:03 AM', NULL, NULL, NULL, NULL, '{BrandName} {SisDatabase} import failed', NULL, 1, '_NEW', '_LOCAL', NULL, 'b588bec0-05e5-4891-8cf3-1d4fedee9edc', 'Gifted Data', 1)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_FlatFileExtractDatabase TABLE (ID uniqueidentifier, LocalCopyPath varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_FlatFileExtractDatabase VALUES ('35612529-9f3d-4971-a3dd-90e795e39080', 'E:\EnrichDataFiles\ZZ\Dummy\Gifted')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @dbo_InformExtractDatabase TABLE (ID uniqueidentifier, LastExtractRosterYear uniqueidentifier, LastLoadRosterYear uniqueidentifier)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @dbo_InformExtractDatabase VALUES ('35612529-9f3d-4971-a3dd-90e795e39080', 'a332bc88-b400-42e2-85aa-3a7f8c6aca54', 'a332bc88-b400-42e2-85aa-3a7f8c6aca54')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @dbo_EnrichFileFormatExtractDatabase TABLE (ID uniqueidentifier, LastLoadRosterYearID uniqueidentifier, LastExtractRosterYearID uniqueidentifier, OrgUnitID uniqueidentifier)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @dbo_EnrichFileFormatExtractDatabase VALUES ('35612529-9f3d-4971-a3dd-90e795e39080', 'ee98b081-65a6-4fdc-b3b9-1f4bc1de84d2', 'a332bc88-b400-42e2-85aa-3a7f8c6aca54', '6531ef88-352d-4620-af5d-ce34c54a9f53')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_FlatFileExtractTableType TABLE (ID char(1), Name varchar(50), TextQualifier char(1), ColumnDelimiter char(1))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_FlatFileExtractTableType VALUES ('C', 'Comma Delimitted File (CSV)', '"', ',')
INSERT INTO @VC3ETL_FlatFileExtractTableType VALUES ('D', 'Comma Delimitted File Dynamic', '"', ',')
INSERT INTO @VC3ETL_FlatFileExtractTableType VALUES ('P', 'Pipe Delimited File', NULL, '|')
INSERT INTO @VC3ETL_FlatFileExtractTableType VALUES ('W', 'Comma Delimitted File (CSV,Quoted Text)', '"', ',')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, SourceTable varchar(100), DestSchema varchar(50), DestTable varchar(50), PrimaryKey varchar(100), Indexes varchar(200), LastSuccessfulCount int, CurrentCount int, Filter varchar(1000), Enabled bit, IgnoreMissing bit, Columns varchar(7000), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractTable VALUES ('b342c5cb-2ff5-48cf-9c50-5d099afd48d3', '35612529-9f3d-4971-a3dd-90e795e39080', 'GiftedStudent', 'x_LEGACYGIFT', 'GiftedStudent', 'StudentRefID', NULL, 4543, 4543, NULL, 1, 0, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('ce7183e0-6e80-442d-b833-bb3137969f74', '35612529-9f3d-4971-a3dd-90e795e39080', 'GiftedGoal', 'x_LEGACYGIFT', 'GiftedGoal', 'GoalRefID', NULL, 9127, 9127, NULL, 1, 1, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('ad5735a9-e971-4486-aff8-d08eb58bda1a', '35612529-9f3d-4971-a3dd-90e795e39080', 'GiftedObjective', 'x_LEGACYGIFT', 'GiftedObjective', 'ObjectiveRefID', NULL, 18313, 18313, NULL, 1, 1, NULL, NULL)
INSERT INTO @VC3ETL_ExtractTable VALUES ('ee6a6f7c-15b1-4f85-90d1-d2590f3de588', '35612529-9f3d-4971-a3dd-90e795e39080', 'GiftedService', 'x_LEGACYGIFT', 'GiftedService', 'ServiceRefID', NULL, 6393, 6393, NULL, 1, 1, NULL, NULL)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_FlatFileExtractTable TABLE (ID uniqueidentifier, Type char(1), FileName varchar(50))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_FlatFileExtractTable VALUES ('b342c5cb-2ff5-48cf-9c50-5d099afd48d3', 'P', 'GiftedStudent.csv')
INSERT INTO @VC3ETL_FlatFileExtractTable VALUES ('ce7183e0-6e80-442d-b833-bb3137969f74', 'P', 'GiftedGoal.csv')
INSERT INTO @VC3ETL_FlatFileExtractTable VALUES ('ad5735a9-e971-4486-aff8-d08eb58bda1a', 'P', 'GiftedObjective.csv')
INSERT INTO @VC3ETL_FlatFileExtractTable VALUES ('ee6a6f7c-15b1-4f85-90d1-d2590f3de588', 'P', 'GiftedService.csv')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_LoadTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, Sequence int, SourceTable varchar(100), DestTable varchar(100), HasMapTable bit, MapTable varchar(100), KeyField varchar(250), DeleteKey varchar(50), ImportType int, DeleteTrans bit, UpdateTrans bit, InsertTrans bit, Enabled bit, SourceTableFilter varchar(1000), DestTableFilter varchar(1000), PurgeCondition varchar(1000), KeepMappingAfterDelete bit, StartNewTransaction bit, LastLoadDate datetime, MapTableMapID varchar(250), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_LoadTable VALUES ('8eea3a80-da45-4e34-b1d6-7bf3cd1b87b7', '35612529-9f3d-4971-a3dd-90e795e39080', 19, 'x_LEGACYGIFT.Transform_PrgInvolvement', 'PrgInvolvement', 1, 'x_LEGACYGIFT.MAP_PrgInvolvementID', 'StudentRefID', 'DestID', 1, 1, 1, 1, 1, NULL, 'd.EndDate is null', NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('2fa77b0c-2029-4672-bc76-ded7970ca30d', '35612529-9f3d-4971-a3dd-90e795e39080', 20, 'x_LEGACYGIFT.Transform_PrgItem', 'PrgItem', 1, 'x_LEGACYGIFT.MAP_EPStudentRefID', 'EpRefID, StudentRefID', 'DestID', 1, 0, 1, 1, 1, NULL, 'd.DefID = ''69942840-0E78-498D-ADE3-7454F69EA178''', '1=1', 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('a9bb8427-580c-40d6-b5cd-e70b3956ddb7', '35612529-9f3d-4971-a3dd-90e795e39080', 21, 'x_LEGACYGIFT.Transform_PrgInvolvement', 'PrgInvolvementStatus', 0, NULL, NULL, NULL, 2, 1, 0, 1,1, 'DestID not in (select InvolvementID from PrgInvolvementStatus where StatusID = ''0B5D5C72-5058-4BF5-A414-BDB27BD5DD94'')', 'InvolvementID not in (select ID from PrgInvolvement)', NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('4fc2fe71-f257-40c7-a2ed-8202e163884d', '35612529-9f3d-4971-a3dd-90e795e39080', 22, 'x_LEGACYGIFT.Transform_PrgItem', 'PrgVersion', 1, 'x_LEGACYGIFT.MAP_PrgVersionID', 'EpRefID', NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('72cee3e2-f947-45fb-8037-e94b18e32f6e', '35612529-9f3d-4971-a3dd-90e795e39080', 23, 'x_LEGACYGIFT.Transform_PrgItem', 'PrgIep', 0, NULL, NULL, NULL, 1, 0, 0, 1, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('08e5066d-7510-417f-a347-54bd06cd9bbf', '35612529-9f3d-4971-a3dd-90e795e39080', 24, 'x_LEGACYGIFT.Transform_PrgSectionFormInstance', 'FormInstance', 1, 'x_LEGACYGIFT.MAP_FormInstanceID', 'EPRefID, SectionDefID', 'FormInstanceID', 1, 1, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/5/2012 5:21:20 PM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('8fe3ac8e-ec3b-402e-899a-b6500d9dff96', '35612529-9f3d-4971-a3dd-90e795e39080', 25, 'x_LEGACYGIFT.Transform_PrgSectionFormInstance', 'PrgItemForm', 0, NULL, NULL, 'FormInstanceID', 1, 1, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/5/2012 5:21:20 PM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('c6b6905d-67e7-48c4-9ded-9ee7aeb8732e', '35612529-9f3d-4971-a3dd-90e795e39080', 26, 'x_LEGACYGIFT.Transform_PrgSectionFormInstance', 'FormInstanceInterval', 1, 'x_LEGACYGIFT.MAP_FormInstanceIntervalID', 'EPRefID, SectionDefID', 'FormInstanceIntervalID', 1, 1, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/5/2012 5:21:20 PM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('201d95b0-a69c-46f3-b042-306db36a854c', '35612529-9f3d-4971-a3dd-90e795e39080', 27, 'x_LEGACYGIFT.Transform_FormInputValue', 'FormInputValue', 1, 'x_LEGACYGIFT.MAP_FormInputValueID', 'IntervalID, InputFieldID', 'DestID', 1, 1, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/5/2012 5:21:20 PM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('2445eebd-087b-4dae-a0cc-80f768c2a014', '35612529-9f3d-4971-a3dd-90e795e39080', 28, 'x_LEGACYGIFT.Transform_FormInput_EPDates_Date', 'FormInputDateValue', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/5/2012 5:21:20 PM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('803d69e6-98cd-4f62-9e29-e13426d294ed', '35612529-9f3d-4971-a3dd-90e795e39080', 28, 'x_LEGACYGIFT.Transform_FormInput_EP_Present_Levels_Text', 'FormInputTextValue', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/5/2012 5:21:20 PM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('981c3554-5c22-4042-babd-aacead4ae8a7', '35612529-9f3d-4971-a3dd-90e795e39080', 28, 'x_LEGACYGIFT.Transform_FormInput_EPDates_SingleSelect', 'FormInputSingleSelectValue', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/5/2012 5:21:20 PM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('4594d39e-bcbd-458f-a6f4-28debaa8adf3', '35612529-9f3d-4971-a3dd-90e795e39080', 29, 'x_LEGACYGIFT.Transform_PrgSection', 'PrgSection', 1, 'x_LEGACYGIFT.MAP_PrgSectionID_NonVersioned', 'DefID, ItemID', 'DestID', 1, 0, 1, 1, 1, 'IsVersioned = 0', 'd.VersionID IS NULL AND d.ItemID in (select DestID from x_LEGACYGIFT.MAP_EPStudentRefID)', '1=1', 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('6f2bd600-befa-4073-b209-7db2b79ccddc', '35612529-9f3d-4971-a3dd-90e795e39080', 30, 'x_LEGACYGIFT.Transform_PrgSection', 'PrgSection', 1, 'x_LEGACYGIFT.MAP_PrgSectionID', 'DefID, VersionID', 'DestID', 1, 0, 1, 1, 1, 'IsVersioned = 1', 'd.VersionID in (select DestID from x_LEGACYGIFT.MAP_PrgVersionID)', '1=1', 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('3d473481-41fc-46e1-974d-ff5b4784934b', '35612529-9f3d-4971-a3dd-90e795e39080', 31, 'x_LEGACYGIFT.Transform_Student', 'IepDates', 0, NULL, NULL, NULL, 1, 0, 1, 1, 0, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('5a9f9aaf-9edb-458f-a8b7-9c7a1c9bc259', '35612529-9f3d-4971-a3dd-90e795e39080', 34, 'x_LEGACYGIFT.Transform_IepServices', 'IepServices', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('cd90e95d-a6cc-4547-9e70-945e2606b5bc', '35612529-9f3d-4971-a3dd-90e795e39080', 41, 'x_LEGACYGIFT.Transform_Schedule_Function()', 'Schedule', 1, 'x_LEGACYGIFT.MAP_ScheduleID', 'ServiceRefID', 'DestID', 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('ffc428c9-76eb-456d-9763-a8fa1278b785', '35612529-9f3d-4971-a3dd-90e795e39080', 42, 'x_LEGACYGIFT.Create_IepService_Snapshot', NULL, 0, NULL, NULL, NULL, 4, 0, 0, 0, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('49ca42b9-3341-4cda-9e25-7851f0606329', '35612529-9f3d-4971-a3dd-90e795e39080', 43, 'x_LEGACYGIFT.Transform_IepService_Snapshot', 'x_LEGACYGIFT.MAP_ServicePlanID', 0, NULL, NULL, NULL, 1, 0, 0, 1, 1, NULL, 'ID in (select isp.ID from IepServicePlan isp join x_LEGACYGIFT.MAP_PrgSectionID m ON m.DestID = isp.InstanceID where m.DefID = ''9AC79680-7989-4CC9-8116-1CCDB1D0AE5F'')', '1=1', 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('9afaf185-132a-4763-8e0b-a9cd85e23b0c', '35612529-9f3d-4971-a3dd-90e795e39080', 44, 'x_LEGACYGIFT.Transform_IepServicePlan_ss', 'ServicePlan', 0, NULL, NULL, 'DestID', 1, 0, 1, 1, 1, NULL, 'ID in (select isp.ID from IepServicePlan isp join x_LEGACYGIFT.MAP_PrgSectionID m ON m.DestID = isp.InstanceID where m.DefID = ''9AC79680-7989-4CC9-8116-1CCDB1D0AE5F'')', '1=1', 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('96ab7d6b-83c3-470f-a946-da7d043cc367', '35612529-9f3d-4971-a3dd-90e795e39080', 45, 'x_LEGACYGIFT.Transform_IepServicePlan_ss', 'IepServicePlan', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('d83c523b-4ae7-4afe-a326-1927026ddafc', '35612529-9f3d-4971-a3dd-90e795e39080', 46, 'x_LEGACYGIFT.Create_ServiceSchedule_Snapshot', NULL, 0, NULL, NULL, NULL, 4, 0, 0, 0, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('020b9cfe-0a76-4923-b861-0ffb2e83ee19', '35612529-9f3d-4971-a3dd-90e795e39080', 47, 'x_LEGACYGIFT.Transform_ServiceSchedule_Snapshot', 'ServiceSchedule', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('66ea733b-f51f-4e50-ac95-3a68124959e7', '35612529-9f3d-4971-a3dd-90e795e39080', 49, 'x_LEGACYGIFT.Transform_ServiceSchedule_Snapshot', 'ServiceScheduleServicePlan', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('6a8b29c3-426e-4ebe-919b-a9f5538a7864', '35612529-9f3d-4971-a3dd-90e795e39080', 50, 'x_LEGACYGIFT.Transform_PrgGoals', 'PrgGoals', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('61f62864-634b-466e-9e05-49e7f0140246', '35612529-9f3d-4971-a3dd-90e795e39080', 51, 'x_LEGACYGIFT.GoalAreaPivotView', 'x_LEGACYGIFT.MAP_GoalAreaPivot', 0, NULL, NULL, NULL, 2, 0, 0, 1, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('81915010-8362-490a-b35b-34195f8ca87f', '35612529-9f3d-4971-a3dd-90e795e39080', 52, 'x_LEGACYGIFT.Transform_IepGoalArea', 'IepGoalArea', 1, 'x_LEGACYGIFT.MAP_IepGoalAreaID', 'EPRefID, DefID', 'DestID', 1, 0, 0, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('67fbbbce-f59d-4502-806c-dd5f849cbc69', '35612529-9f3d-4971-a3dd-90e795e39080', 53, 'x_LEGACYGIFT.Transform_PrgGoal', 'PrgCrossVersionGoal', 1, 'x_LEGACYGIFT.MAP_PrgGoalID', 'GoalRefID, CrossVersionGoalID', NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('46a3ff82-52d9-45a0-976f-1d458fc38608', '35612529-9f3d-4971-a3dd-90e795e39080', 54, 'x_LEGACYGIFT.Transform_PrgGoal', 'PrgGoal', 0, NULL, 'GoalRefID', 'DestID', 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('ae4d2fb2-dcbc-4f13-85cc-d21993c77a6c', '35612529-9f3d-4971-a3dd-90e795e39080', 55, 'x_LEGACYGIFT.Transform_IepGoal', 'IepGoal', 0, NULL, NULL, NULL, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 0, '6/19/2013 9:33:03 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('c28cd005-4304-4597-a2a6-6bc602ba47df', '35612529-9f3d-4971-a3dd-90e795e39080', 57, 'x_LEGACYGIFT.Transform_IepGoalSubGoalAreaDef', 'IepGoalSubGoalAreaDef', 0, NULL, NULL, NULL, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('3a617cba-74a1-4792-9aaa-fa5b7878b89d', '35612529-9f3d-4971-a3dd-90e795e39080', 56, 'x_LEGACYGIFT.Transform_IepGoalSecondaryGoalAreaDef', 'IepGoalSecondaryGoalAreaDef', 0, NULL, NULL, NULL, 1, 1, 0, 1, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('3e06e409-0109-4679-976a-f8423f61afb7', '35612529-9f3d-4971-a3dd-90e795e39080', 58, 'x_LEGACYGIFT.Transform_PrgGoalObjective', 'PrgGoal', 1, 'x_LEGACYGIFT.MAP_PrgGoalObjectiveID', 'ObjectiveRefID', 'DestID', 1, 1, 1, 1, 1, NULL, 'd.ParentID in (SELECT DestID from x_LEGACYGIFT.Transform_PrgGoal)', NULL, 0, 0, '12/17/2012 10:13:21 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('9fe8a8a2-5f9c-4960-b23c-144a4bc012cb', '35612529-9f3d-4971-a3dd-90e795e39080', 60, 'x_LEGACYGIFT.Transform_PrgGoalProgress', 'PrgGoalProgress', 0, NULL, NULL, NULL, 1, 0, 0, 1, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:16:51 AM', NULL, NULL)
INSERT INTO @VC3ETL_LoadTable VALUES ('5b1516d1-f419-4e68-8da6-2d774e18a113', '35612529-9f3d-4971-a3dd-90e795e39080', 61, 'x_LEGACYGIFT.Transform_PrgGoalProgress_Objective', 'PrgGoalProgress', 0, NULL, NULL, NULL, 1, 0, 0, 1, 1, NULL, NULL, NULL, 0, 0, '12/17/2012 10:16:51 AM', NULL, NULL)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_LoadColumn TABLE (ID uniqueidentifier, LoadTable uniqueidentifier, SourceColumn varchar(500), DestColumn varchar(500), ColumnType char(1), UpdateOnDelete bit, DeletedValue varchar(500), NullValue varchar(500), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_LoadColumn VALUES ('21ca29b2-c97c-4b87-9ee8-00038413a5e7', '8eea3a80-da45-4e34-b1d6-7bf3cd1b87b7', 'StartDate', 'StartDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('1c65b4f6-09f6-4425-9836-0067a3eb928e', 'ae4d2fb2-dcbc-4f13-85cc-d21993c77a6c', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('0d4f42a4-bec3-41b6-b9a7-03ca9835cd80', '4fc2fe71-f257-40c7-a2ed-8202e163884d', 'DestID', 'ItemID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c8b8e2bc-855d-4c6a-a9b4-05697261dae8', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'WeeklyTue', 'WeeklyTue', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('bd754362-81b4-4ce0-93c6-073c0b33a03c', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'WeeklyMon', 'WeeklyMon', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('fc94b529-aa50-4a1c-b2f9-08c62c03ebc1', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'InstanceID', 'InstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('7ffd629c-2caa-40fe-ad64-09248d17365d', '4fc2fe71-f257-40c7-a2ed-8202e163884d', 'CreatedDate', 'DateCreated', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('290e8e57-7247-4bd4-bb54-0c74faa7cf9e', '9fe8a8a2-5f9c-4960-b23c-144a4bc012cb', 'ReportPeriodID', 'ReportPeriodID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e4c9ba1e-db0d-42f0-9938-0cfa112c73d6', '3a617cba-74a1-4792-9aaa-fa5b7878b89d', 'DefID', 'DefID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('eb41fc29-ac5c-4363-a1f4-0d57f179db35', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'NumericTarget', 'NumericTarget', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('4ea5becf-9b99-4f28-84ff-0da37e442628', '3d473481-41fc-46e1-974d-ff5b4784934b', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('9bba5480-529c-43d0-9a83-0f375b16bedb', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'StartDate', 'StartDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('52617907-3305-4392-98c0-1001757c0962', '8eea3a80-da45-4e34-b1d6-7bf3cd1b87b7', 'IsManuallyEnded', 'IsManuallyEnded', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('89017b88-5aa8-4ede-a2bb-10316fc02d86', 'c6b6905d-67e7-48c4-9ded-9ee7aeb8732e', 'IntervalID', 'IntervalID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d0026124-2f4d-47eb-bcd0-1570db38763b', '8eea3a80-da45-4e34-b1d6-7bf3cd1b87b7', 'EndDate', 'EndDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('52ee5f83-3176-44fe-ad91-1a27995b629b', '9fe8a8a2-5f9c-4960-b23c-144a4bc012cb', 'newid()', 'ID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('36686c6c-78a7-4e67-9dc0-1c7c25fb0245', '8fe3ac8e-ec3b-402e-899a-b6500d9dff96', 'AssociationTypeID', 'AssociationTypeID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('42d4e644-8023-4c9e-9884-1d4d914b71ca', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2e4184ad-32ad-42b3-89be-1dc3e34acec5', '201d95b0-a69c-46f3-b042-306db36a854c', 'Sequence', 'Sequence', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c6179b5c-1cba-4b27-a7b4-1dd049240ce1', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'StartDate', 'StartDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('428ea119-52ca-45aa-b20f-2013f109d62c', '49ca42b9-3341-4cda-9e25-7851f0606329', 'ServiceRefID', 'ServiceRefID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('aa8153ce-ce4a-4597-bb2f-21394e03c0de', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'GoalStatement', 'GoalStatement', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('b054416f-ce0f-4967-b781-21481b96d61f', 'c6b6905d-67e7-48c4-9ded-9ee7aeb8732e', 'CompletedDate', 'CompletedDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('33d82700-2374-4777-8bba-21f34cfd5253', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'EndedBy', 'EndedBy', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c363f8f3-e589-4cb3-a4d7-291663b3b5ed', 'c6b6905d-67e7-48c4-9ded-9ee7aeb8732e', 'FormInstanceIntervalID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('281e73fc-7244-46ad-a28c-2bbdcc4afe0c', '6f2bd600-befa-4073-b209-7db2b79ccddc', 'FormInstanceID', 'FormInstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('45250b34-c3da-400a-8f6a-2d2e5d693a54', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'IsProbeGoal', 'IsProbeGoal', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e93acaf8-73ba-4c2f-a92a-2f702b80de92', '6a8b29c3-426e-4ebe-919b-a9f5538a7864', 'UseProgressReporting', 'UseProgressReporting', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('3e618b56-2518-4873-afab-30ef21c90b38', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'BaselineScoreID', 'BaselineScoreID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('de18f9c4-fe22-42bd-925b-32d190f4a7bf', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'SchoolID', 'SchoolID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('64c35b26-a5b9-43be-9095-33a1e414dd38', '96ab7d6b-83c3-470f-a946-da7d043cc367', 'DeliveryStatement', 'DeliveryStatement', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('ab04de72-b4e6-4a22-9800-33a2f178b1a3', '96ab7d6b-83c3-470f-a946-da7d043cc367', 'InstanceID', 'InstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('104e4897-72c9-4116-b22f-361a92d0fe64', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'StartDate', 'StartDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('0c8c3576-b4cd-4e8a-a761-3957bf8a1d13', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'ProbeTypeID', 'ProbeTypeID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('b2f6f917-3049-45c1-bcbb-3b335c6f3232', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'WeeklySun', 'WeeklySun', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('ab27c9a3-e817-4744-8ba8-3c279c8c77c8', '3d473481-41fc-46e1-974d-ff5b4784934b', 'InitialEvaluationDate', 'InitialEvaluationDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('cb78fe56-0fef-469b-b760-3d4249389086', '2445eebd-087b-4dae-a0cc-80f768c2a014', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('dc2e74d6-c40d-40a6-88dc-3fa0f6bf143e', '3e06e409-0109-4679-976a-f8423f61afb7', 'InstanceID', 'InstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('02cfd701-6848-40c3-8c83-403d3ec31435', '5a9f9aaf-9edb-458f-a8b7-9c7a1c9bc259', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('215f15b9-ca1c-4d47-898d-4217fd3f6315', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'IsApprovalPending', 'IsApprovalPending', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('07ba09f1-ee67-4c10-afad-44b687a2974c', '020b9cfe-0a76-4923-b861-0ffb2e83ee19', 'LocationDescription', 'LocationDescription', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('f8f68ed8-0da5-453d-8dc0-46159324fea3', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'WeeklyFri', 'WeeklyFri', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('60105a1b-f78f-4738-acb0-4679fb4860b9', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'DefID', 'DefID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('ece1577c-4c0c-4942-aad4-472620c3b80c', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'Sequence', 'Sequence', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('06421bb7-830e-4e8a-811e-47718364bcfd', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'UnitID', 'UnitID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('bca6ac85-d898-4ed8-b0bd-48d7bb8e225c', 'a9bb8427-580c-40d6-b5cd-e70b3956ddb7', 'DestID', 'InvolvementID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('14e4adb3-3e96-4304-bb42-49c5df279629', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'ProbeScheduleID', 'ProbeScheduleID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('5f9f92fc-d751-4d79-8d81-4a75bf173525', '8fe3ac8e-ec3b-402e-899a-b6500d9dff96', 'ItemID', 'ItemID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d9d88f93-ee7e-4290-b455-4b03944cbaf6', '4594d39e-bcbd-458f-a6f4-28debaa8adf3', 'FormInstanceID', 'FormInstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('3e6c6987-adf9-436c-b8f8-4bf17d1a3fb8', 'c6b6905d-67e7-48c4-9ded-9ee7aeb8732e', 'CompletedBy', 'CompletedBy', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('de5cea3c-4442-47d2-a8bb-4c92643bf4c9', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'ApprovedDate', 'ApprovedDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('ea3bd5ea-9694-4a6c-b09e-4d7e76cb5018', '4fc2fe71-f257-40c7-a2ed-8202e163884d', 'CreatedByID', 'CreatedByID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('4d15c881-0005-4fe9-96b3-5010b5b970d4', '981c3554-5c22-4042-babd-aacead4ae8a7', 'SelectedOptionID', 'SelectedOptionID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('058f99e8-205c-46d3-a529-50fbbb9a2a9b', '3e06e409-0109-4679-976a-f8423f61afb7', 'CrossVersionGoalID', 'CrossVersionGoalID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('bd225cb9-449f-4df1-86ef-51524ff5dc18', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'Amount', 'Amount', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('3be53534-e1c3-4f41-aea6-525b51830416', '08e5066d-7510-417f-a347-54bd06cd9bbf', 'TemplateID', 'TemplateID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('16603b00-77e6-4d05-b757-52d097c23735', '3d473481-41fc-46e1-974d-ff5b4784934b', 'NextEvaluationDate', 'NextEvaluationDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('8b385ef4-92f0-4292-9860-547ec3ffe13d', '6f2bd600-befa-4073-b209-7db2b79ccddc', 'HeaderFormInstanceID', 'HeaderFormInstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('7ac7d37b-59ef-40b7-a53b-5720f47d444f', '4594d39e-bcbd-458f-a6f4-28debaa8adf3', 'ItemID', 'ItemID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2ce75194-0fe7-4664-8994-576088c5d945', '3e06e409-0109-4679-976a-f8423f61afb7', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('77da97b8-7d67-4501-9650-586adedbf795', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'StudentID', 'StudentID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2662a4f2-7784-48f7-813c-58cb6dd3f665', '8eea3a80-da45-4e34-b1d6-7bf3cd1b87b7', 'StudentID', 'StudentID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('cb2ea216-940f-4a6e-9e18-5a4a9d8cf891', '81915010-8362-490a-b35b-34195f8ca87f', 'DefID', 'DefID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('fc70a0dc-efec-4371-ba07-5b792949fed1', 'c28cd005-4304-4597-a2a6-6bc602ba47df', 'DefID', 'DefID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('de739ff9-cd9a-40e6-8d2c-5d8948faf2cf', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'EndStatusID', 'EndStatusID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('50a4b02c-deb7-4fe4-8207-5da443423260', '020b9cfe-0a76-4923-b861-0ffb2e83ee19', 'Name', 'Name', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('4c3c4485-59d0-4e88-9f88-5e252db0f437', '8eea3a80-da45-4e34-b1d6-7bf3cd1b87b7', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('04830ba0-4ab8-4ff4-a4be-5f309bbf9ac2', '61f62864-634b-466e-9e05-49e7f0140246', 'GoalRefID', 'GoalRefID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('1088aa46-5316-4cec-9616-603f2fe90d08', '020b9cfe-0a76-4923-b861-0ffb2e83ee19', 'LocationID', 'LocationID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('336c15d6-3fb1-406e-996e-608ce690d385', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'IndDefID', 'IndDefID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('82e4158d-2aad-4cfc-acbd-60ba5ae8f353', '201d95b0-a69c-46f3-b042-306db36a854c', 'InputFieldID', 'InputFieldID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('587c155d-2b76-4b9a-b494-60dc0b279847', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'WeeklyWed', 'WeeklyWed', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('f7a2b707-230e-4f0f-be3e-64cdcf0a0be1', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'DefID', 'DefID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('aef8b817-597c-411b-a263-650eed748d87', '3e06e409-0109-4679-976a-f8423f61afb7', 'Sequence', 'Sequence', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('34f3b6c2-42f4-4899-9ecf-659598791117', '8eea3a80-da45-4e34-b1d6-7bf3cd1b87b7', 'ProgramID', 'ProgramID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('78bb8a29-db4c-4776-8ff6-681b150484b4', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'TypeID', 'TypeID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('dccd8503-1a70-49c7-a120-69d5023f693f', '3e06e409-0109-4679-976a-f8423f61afb7', 'GoalStatement', 'GoalStatement', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('9c6d220a-7e77-49c4-87a6-6bc2c0addbfb', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'CreatedBy', 'CreatedBy', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('3c185f97-28f6-42c8-b15c-6d6e5e28a85c', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'RatioOutOfTarget', 'RatioOutOfTarget', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('34bcfe64-8cc2-4312-bad9-6d81e65a1c32', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'RatioPartTarget', 'RatioPartTarget', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('8842da3c-dba7-4f54-ab8c-6dd334fcb630', '5b1516d1-f419-4e68-8da6-2d774e18a113', 'newid()', 'ID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d2b73280-75fe-4476-9ca0-712bf6fc805e', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'StartDate', 'StartDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('00f8f5c3-637c-4a4c-a330-71cb25a68494', '9fe8a8a2-5f9c-4960-b23c-144a4bc012cb', 'GoalID', 'GoalID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('dfaba340-546a-4f96-83f9-737554ebe082', 'ae4d2fb2-dcbc-4f13-85cc-d21993c77a6c', 'GoalAreaID', 'GoalAreaID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('8404d723-b3da-4287-bf3d-73b0c97ff635', '6f2bd600-befa-4073-b209-7db2b79ccddc', 'DefID', 'DefID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('4fe77970-5360-458a-8efe-78614165703b', '08e5066d-7510-417f-a347-54bd06cd9bbf', 'FormInstanceID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e8d2ad7c-2e11-441e-a477-7a269508c199', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'WeeklySat', 'WeeklySat', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e4b9402d-8c79-4fa6-a300-7ad24fc85a4a', 'a9bb8427-580c-40d6-b5cd-e70b3956ddb7', 'EndDate', 'EndDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('1e825584-ac46-4d89-974c-7b8342a0e725', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'EndDate', 'EndDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('26a8dc95-c360-466a-81da-7cbe280f2a58', '6a8b29c3-426e-4ebe-919b-a9f5538a7864', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('786807ea-702d-4cfe-9ca3-7ce2c2dcdc1c', '4594d39e-bcbd-458f-a6f4-28debaa8adf3', 'DefID', 'DefID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('03a3bc9b-6f73-45d9-bbfe-7d94dad936de', '4fc2fe71-f257-40c7-a2ed-8202e163884d', 'VersionFinalizedDate', 'DateFinalized', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c69d4af0-3491-4308-af51-80feab6197e0', '96ab7d6b-83c3-470f-a946-da7d043cc367', 'EsyID', 'EsyID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('b6c4c3f4-4b33-4462-acda-83240272df22', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'IsEnded', 'IsEnded', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d894392f-d43d-4805-9a16-833f93dd8492', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'ItemOutcomeID', 'ItemOutcomeID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('a1959a67-9eb3-4ddc-a98f-84bcef375bb6', '4594d39e-bcbd-458f-a6f4-28debaa8adf3', 'OnLatestVersion', 'OnLatestVersion', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('fe117328-3738-4233-b785-855ed58a4029', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'CreatedDate', 'CreatedDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('6591aaae-d3c5-409d-adad-863ddcf6a64a', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'InvolvementID', 'InvolvementID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('b3ee3712-2a2b-418d-9a18-86666debad47', '67fbbbce-f59d-4502-806c-dd5f849cbc69', 'CrossVersionGoalID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d65a8e0a-51b2-4699-9ce3-8cb8a7d712f8', '81915010-8362-490a-b35b-34195f8ca87f', 'InstanceID', 'InstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e608ac42-ec40-4730-a198-8de34ce925b7', '020b9cfe-0a76-4923-b861-0ffb2e83ee19', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('05fd1712-4647-4ce0-afb9-8df014c5aec0', 'ae4d2fb2-dcbc-4f13-85cc-d21993c77a6c', 'EsyID', 'EsyID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('bf72af70-0416-4603-8aff-8e7260f7ed53', '4fc2fe71-f257-40c7-a2ed-8202e163884d', 'VersionDestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('87eb3184-f1a8-4c37-87da-8eb124ced77a', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'ApprovedByID', 'ApprovedByID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('34ee4023-55fa-4bf2-8663-8ef826c11c1e', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'IsEnabled', 'IsEnabled', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d9cf776a-4a76-4644-b577-8f0632d3c09e', '8eea3a80-da45-4e34-b1d6-7bf3cd1b87b7', 'VariantID', 'VariantID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('f45fca5e-c0a7-4fae-82f9-93b9830a25b6', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'RubricTargetID', 'RubricTargetID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('9aecf438-8425-4d69-b82e-9494698cddf7', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e1755efd-2be8-4ca2-8c71-94eaa658c14a', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'StartStatusID', 'StartStatusID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('0fe2359d-4981-4163-9161-95432ee05171', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'FrequencyID', 'FrequencyID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c75fc63c-6f9f-4798-bd35-95cf61166d79', '4fc2fe71-f257-40c7-a2ed-8202e163884d', 'ApprovedByID', 'ApprovedByID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('03a81b68-f1df-4f49-a07b-996b9b92e00c', '6f2bd600-befa-4073-b209-7db2b79ccddc', 'ItemID', 'ItemID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('1649da48-db80-4841-8478-9aa95a989e05', '020b9cfe-0a76-4923-b861-0ffb2e83ee19', 'ProviderID', 'ProviderID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('9ebfa4d8-43fb-4480-a399-9b8604756e36', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'FrequencyID', 'FrequencyID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('66704674-1d4b-4305-8581-9de3580dc6c8', '72cee3e2-f947-45fb-8037-e94b18e32f6e', 'IsTransitional', 'IsTransitional', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('09802578-5db6-49b1-bbd8-9ff0558173d0', '3a617cba-74a1-4792-9aaa-fa5b7878b89d', 'GoalID', 'GoalID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('a35feadf-0238-4f80-ba18-a19247f7882f', '3e06e409-0109-4679-976a-f8423f61afb7', 'ParentID', 'ParentID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('acfb21c3-35d1-4067-a718-a2048ba1ad48', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'StudentID', 'StudentID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('9b60ae4a-256a-4714-82ca-a6fcf4fd1afa', '5a9f9aaf-9edb-458f-a8b7-9c7a1c9bc259', 'DeliveryStatement', 'DeliveryStatement', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('86000389-7c2b-406b-b164-a8449a5206dc', '4594d39e-bcbd-458f-a6f4-28debaa8adf3', 'HeaderFormInstanceID', 'HeaderFormInstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('5a29be9e-a165-40da-a924-a92661f4f555', 'a9bb8427-580c-40d6-b5cd-e70b3956ddb7', 'StatusID', 'StatusID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('1c02bdd9-5e76-4caa-9f42-aa6aed424a7b', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'IndTarget', 'IndTarget', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('49191631-c098-4056-bdda-ab96a82a2d6b', '96ab7d6b-83c3-470f-a946-da7d043cc367', 'CategoryID', 'CategoryID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('ceef6184-0f0b-4d9f-b686-adcea5ea8893', '66ea733b-f51f-4e50-ac95-3a68124959e7', 'ScheduleID', 'ScheduleID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c0f43db3-e562-4ed1-9a31-b1161e2dcb3c', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'ServiceTypeID', 'ServiceTypeID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('b77e8213-66b2-4418-9032-b511b7de5a9c', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'Revision', 'Revision', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('baccc239-f77d-4f70-b25b-b5896b4ac270', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'EndDate', 'EndDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e56b0201-cfd6-420c-8e03-b5e91c618acf', '803d69e6-98cd-4f62-9e29-e13426d294ed', 'PresentLevel', 'Value', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('43b5b604-cfba-43ff-8671-b6585864107b', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'WeeklyThu', 'WeeklyThu', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2a365d24-d5b9-40f3-bf73-b77ae879e71a', '6a8b29c3-426e-4ebe-919b-a9f5538a7864', 'ReportFrequencyID', 'ReportFrequencyID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('cf3f5129-4b3e-407b-b161-b988b815b292', '3e06e409-0109-4679-976a-f8423f61afb7', 'TypeID', 'TypeID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('eb6ffa9a-88b5-439e-a31c-b98aa2f23cce', 'c6b6905d-67e7-48c4-9ded-9ee7aeb8732e', 'FormInstanceID', 'InstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('0563a00c-53b1-4296-9683-bab420cce583', '96ab7d6b-83c3-470f-a946-da7d043cc367', 'DirectID', 'DirectID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('6c5a6446-6b15-40ae-90be-be10a814fcc2', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'LastOccurrence', 'LastOccurrence', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('3add3507-fc37-4cab-b9ec-be6a99d92484', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'TypeID', 'TypeID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('32469633-60dc-4331-9089-be870a4ceeb3', '4594d39e-bcbd-458f-a6f4-28debaa8adf3', 'VersionID', 'VersionID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('47687f2b-537f-45b3-a59e-bee19dfc445e', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('6b9f4164-4b6e-429a-bfb6-bfb701caeb39', '4594d39e-bcbd-458f-a6f4-28debaa8adf3', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('b46ee036-a6d5-4b39-be9e-c033b652ef27', '4fc2fe71-f257-40c7-a2ed-8202e163884d', 'IsApprovalPending', 'IsApprovalPending', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('08acc79d-6280-4539-8df4-c0927ad43f74', '8fe3ac8e-ec3b-402e-899a-b6500d9dff96', 'CreatedDate', 'CreatedDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2daee209-512d-436b-b9e8-c182918ca883', '3e06e409-0109-4679-976a-f8423f61afb7', 'TargetDate', 'TargetDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('4908d18a-c2a9-4ecb-8ad8-c3166dfb40d5', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'GradeLevelID', 'GradeLevelID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('3938e89d-c044-4160-8bec-c4b924b9085a', '66ea733b-f51f-4e50-ac95-3a68124959e7', 'ServicePlanID', 'ServicePlanID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('842bd710-adac-4b3a-ad38-c7b0491af50c', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'TimesPerDay', 'TimesPerDay', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('3de9ecca-4af3-40e0-b64e-c85d7fa9fd03', '2445eebd-087b-4dae-a0cc-80f768c2a014', 'DateValue', 'Value', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('8e59f1b0-6a7f-47b1-8d91-c8ee9a6142a9', 'ae4d2fb2-dcbc-4f13-85cc-d21993c77a6c', 'PostSchoolAreaDefID', 'PostSchoolAreaDefID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d1b5a734-f2ce-410d-be0b-ca9fd00d1f96', '96ab7d6b-83c3-470f-a946-da7d043cc367', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('ac706ed1-05c7-4716-9ae4-cd4901a0d751', 'a9bb8427-580c-40d6-b5cd-e70b3956ddb7', 'NEWID()', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('a7471eaa-082f-4416-be1b-cdc8910d6fe8', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'EndedDate', 'EndedDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('7c1d5afc-c18a-473c-abe8-cdcfa7893484', '8fe3ac8e-ec3b-402e-899a-b6500d9dff96', 'CreatedBy', 'CreatedBy', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('6ff4f5c0-f4de-4ac6-be5e-cecc55b0801a', '6f2bd600-befa-4073-b209-7db2b79ccddc', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('f9f3eb22-c207-4c5c-a255-cf3c6b566ff4', '61f62864-634b-466e-9e05-49e7f0140246', 'GoalAreaDefIndex', 'GoalAreaDefIndex', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c589c987-8eab-4fd6-b2d8-cfafd4d110f2', '5b1516d1-f419-4e68-8da6-2d774e18a113', 'ReportPeriodID', 'ReportPeriodID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d12adf63-ccb9-4d1e-8a78-d0b34f8929a7', '81915010-8362-490a-b35b-34195f8ca87f', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('f7daeef0-067f-4458-b870-d155e6888f34', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'EndDate', 'EndDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e7a8e004-9011-4b8f-ba16-d1ffd6eb3a78', '3e06e409-0109-4679-976a-f8423f61afb7', 'IsProbeGoal', 'IsProbeGoal', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('d5f1b588-1c26-4847-b2a3-d28446bdf0c3', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'Sequence', 'Sequence', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('6bd13614-cd37-4af1-b627-d3c1b08be60f', '9afaf185-132a-4763-8e0b-a9cd85e23b0c', 'ProviderTitleID', 'ProviderTitleID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('1334418a-17bb-4b17-b4f7-d4ef474844d4', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'PlannedEndDate', 'PlannedEndDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2dbfb655-0a3c-4ed8-92e4-d7cb1158d66c', 'c28cd005-4304-4597-a2a6-6bc602ba47df', 'GoalID', 'GoalID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('9ff3b1bf-f7cd-4031-80f5-d873df9390b3', '72cee3e2-f947-45fb-8037-e94b18e32f6e', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('be534f10-8e93-4c02-b565-d9a42a9ed0a2', '201d95b0-a69c-46f3-b042-306db36a854c', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('bbbaef0d-e509-4f77-90cd-db6a21d02c02', '981c3554-5c22-4042-babd-aacead4ae8a7', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('40771043-ec0d-452e-b2ab-dbd12cbb83a3', '61f62864-634b-466e-9e05-49e7f0140246', 'GoalAreaCode', 'GoalAreaCode', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('f17cc212-6cbc-42c5-ae1b-df502962ff00', '803d69e6-98cd-4f62-9e29-e13426d294ed', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2cf8fd19-4b14-4562-a039-e0e851b2dc5e', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'DestID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('7f830c6f-4514-456b-8349-e1c9f017258a', 'cd90e95d-a6cc-4547-9e70-945e2606b5bc', 'FrequencyAmount', 'FrequencyAmount', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('64a120cb-c7f9-4314-b93f-e326188a7c18', '201d95b0-a69c-46f3-b042-306db36a854c', 'IntervalID', 'IntervalID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c15ce6a0-b2ae-4550-b834-e4250690b18d', '3d473481-41fc-46e1-974d-ff5b4784934b', 'NextReviewDate', 'NextReviewDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('a416af57-4ff0-4c8a-b954-e647537899f2', '6f2bd600-befa-4073-b209-7db2b79ccddc', 'VersionID', 'VersionID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('c27b6c03-08d6-4a96-91a1-e679d575b43e', '8fe3ac8e-ec3b-402e-899a-b6500d9dff96', 'FormInstanceID', 'ID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('4fc90f53-0e05-4c8f-b8f1-e80e6f033a30', '4fc2fe71-f257-40c7-a2ed-8202e163884d', 'ApprovedDate', 'ApprovedDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('7aa43f93-3ad1-4430-8d05-f0bdda131cc5', '3d473481-41fc-46e1-974d-ff5b4784934b', 'LatestEvaluationDate', 'LatestEvaluationDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('3c9dd024-de3c-49ee-835b-f36af085fd2b', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'CrossVersionGoalID', 'CrossVersionGoalID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('4224a9a4-22d1-4150-925d-f6d3d146b20b', '96ab7d6b-83c3-470f-a946-da7d043cc367', 'ExcludesID', 'ExcludesID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('98871c14-6527-4463-8a00-f94810eb22da', '5b1516d1-f419-4e68-8da6-2d774e18a113', 'GoalID', 'GoalID', 'K', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('7bfeddab-f6c9-41a4-9e1d-fa9e4b8e7b2e', '6f2bd600-befa-4073-b209-7db2b79ccddc', 'OnLatestVersion', 'OnLatestVersion', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2dab1296-a6de-47f9-a3d9-fb126b481379', '81915010-8362-490a-b35b-34195f8ca87f', 'FormInstanceID', 'FormInstanceID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('2cf2d5f8-a727-45e7-b729-fbb18034111d', '49ca42b9-3341-4cda-9e25-7851f0606329', 'newid()', 'DestID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('e70751df-5266-482e-b392-fc3be8f3a427', '46a3ff82-52d9-45a0-976f-1d458fc38608', 'TargetDate', 'TargetDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('4539e9f4-f2a0-4c03-bb1f-fe7daaf0baa4', 'a9bb8427-580c-40d6-b5cd-e70b3956ddb7', 'StartDate', 'StartDate', 'C', 0, NULL, NULL, NULL)

-- new column added to PrgItem table in 9.x.x.x
INSERT INTO @VC3ETL_LoadColumn VALUES ('6330445A-4A07-4953-92A8-4FE7786824EB', '2fa77b0c-2029-4672-bc76-ded7970ca30d', 'OID', 'OID', 'C', 0, NULL, NULL, NULL)

-- Insert records in the destination tables that do not already exist
INSERT INTO VC3ETL.ExtractDatabase SELECT Source.* FROM @VC3ETL_ExtractDatabase Source LEFT JOIN VC3ETL.ExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.FlatFileExtractDatabase SELECT Source.* FROM @VC3ETL_FlatFileExtractDatabase Source LEFT JOIN VC3ETL.FlatFileExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO dbo.InformExtractDatabase SELECT Source.* FROM @dbo_InformExtractDatabase Source LEFT JOIN dbo.InformExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO dbo.EnrichFileFormatExtractDatabase SELECT Source.* FROM @dbo_EnrichFileFormatExtractDatabase Source LEFT JOIN dbo.EnrichFileFormatExtractDatabase Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.FlatFileExtractTableType SELECT Source.* FROM @VC3ETL_FlatFileExtractTableType Source LEFT JOIN VC3ETL.FlatFileExtractTableType Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.ExtractTable SELECT Source.* FROM @VC3ETL_ExtractTable Source LEFT JOIN VC3ETL.ExtractTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.FlatFileExtractTable SELECT Source.* FROM @VC3ETL_FlatFileExtractTable Source LEFT JOIN VC3ETL.FlatFileExtractTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.LoadTable SELECT Source.* FROM @VC3ETL_LoadTable Source LEFT JOIN VC3ETL.LoadTable Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO VC3ETL.LoadColumn SELECT Source.*, 1 FROM @VC3ETL_LoadColumn Source LEFT JOIN VC3ETL.LoadColumn Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL

delete d
-- select d.*
from VC3ETL.LoadColumn d join 
@VC3ETL_LoadTable lt on d.LoadTable = lt.ID left join
@VC3ETL_LoadColumn s on d.ID = s.ID
where s.ID is null

-- Update records in the destination table that already exist
UPDATE Destination SET Destination.Type = Source.Type, Destination.DatabaseType = Source.DatabaseType, Destination.Server = Source.Server, Destination.DatabaseOwner = Source.DatabaseOwner, Destination.DatabaseName = Source.DatabaseName, Destination.Username = Source.Username, Destination.Password = Source.Password, Destination.LinkedServer = Source.LinkedServer, Destination.IsLinkedServerManaged = Source.IsLinkedServerManaged, Destination.LastExtractDate = Source.LastExtractDate, Destination.LastLoadDate = Source.LastLoadDate, Destination.SucceededEmail = Source.SucceededEmail, Destination.SucceededSubject = Source.SucceededSubject, Destination.SucceededMessage = Source.SucceededMessage, Destination.FailedEmail = Source.FailedEmail, Destination.FailedSubject = Source.FailedSubject, Destination.FailedMessage = Source.FailedMessage, Destination.RetainSnapshot = Source.RetainSnapshot, Destination.DestTableTempSuffix = Source.DestTableTempSuffix, Destination.DestTableFinalSuffix = Source.DestTableFinalSuffix, Destination.FileGroup = Source.FileGroup, Destination.Schedule = Source.Schedule, Destination.Name = Source.Name, Destination.Enabled = Source.Enabled FROM @VC3ETL_ExtractDatabase Source JOIN VC3ETL.ExtractDatabase Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.LocalCopyPath = Source.LocalCopyPath FROM @VC3ETL_FlatFileExtractDatabase Source JOIN VC3ETL.FlatFileExtractDatabase Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.LastExtractRosterYear = Source.LastExtractRosterYear, Destination.LastLoadRosterYear = Source.LastLoadRosterYear FROM @dbo_InformExtractDatabase Source JOIN dbo.InformExtractDatabase Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.LastLoadRosterYearID = Source.LastLoadRosterYearID, Destination.LastExtractRosterYearID = Source.LastExtractRosterYearID, Destination.OrgUnitID = Source.OrgUnitID FROM @dbo_EnrichFileFormatExtractDatabase Source JOIN dbo.EnrichFileFormatExtractDatabase Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.Name = Source.Name, Destination.TextQualifier = Source.TextQualifier, Destination.ColumnDelimiter = Source.ColumnDelimiter FROM @VC3ETL_FlatFileExtractTableType Source JOIN VC3ETL.FlatFileExtractTableType Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.ExtractDatabase = Source.ExtractDatabase, Destination.SourceTable = Source.SourceTable, Destination.DestSchema = Source.DestSchema, Destination.DestTable = Source.DestTable, Destination.PrimaryKey = Source.PrimaryKey, Destination.Indexes = Source.Indexes, Destination.LastSuccessfulCount = Source.LastSuccessfulCount, Destination.CurrentCount = Source.CurrentCount, Destination.Filter = Source.Filter, Destination.Enabled = Source.Enabled, Destination.IgnoreMissing = Source.IgnoreMissing, Destination.Columns = Source.Columns, Destination.Comments = Source.Comments FROM @VC3ETL_ExtractTable Source JOIN VC3ETL.ExtractTable Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.Type = Source.Type, Destination.FileName = Source.FileName FROM @VC3ETL_FlatFileExtractTable Source JOIN VC3ETL.FlatFileExtractTable Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.ExtractDatabase = Source.ExtractDatabase, Destination.Sequence = Source.Sequence, Destination.SourceTable = Source.SourceTable, Destination.DestTable = Source.DestTable, Destination.HasMapTable = Source.HasMapTable, Destination.MapTable = Source.MapTable, Destination.KeyField = Source.KeyField, Destination.DeleteKey = Source.DeleteKey, Destination.ImportType = Source.ImportType, Destination.DeleteTrans = Source.DeleteTrans, Destination.UpdateTrans = Source.UpdateTrans, Destination.InsertTrans = Source.InsertTrans, Destination.Enabled = Source.Enabled, Destination.SourceTableFilter = Source.SourceTableFilter, Destination.DestTableFilter = Source.DestTableFilter, Destination.PurgeCondition = Source.PurgeCondition, Destination.KeepMappingAfterDelete = Source.KeepMappingAfterDelete, Destination.StartNewTransaction = Source.StartNewTransaction, Destination.LastLoadDate = Source.LastLoadDate, Destination.MapTableMapID = Source.MapTableMapID, Destination.Comments = Source.Comments FROM @VC3ETL_LoadTable Source JOIN VC3ETL.LoadTable Destination ON Source.ID = Destination.ID
UPDATE Destination SET Destination.LoadTable = Source.LoadTable, Destination.SourceColumn = Source.SourceColumn, Destination.DestColumn = Source.DestColumn, Destination.ColumnType = Source.ColumnType, Destination.UpdateOnDelete = Source.UpdateOnDelete, Destination.DeletedValue = Source.DeletedValue, Destination.NullValue = Source.NullValue, Destination.Comments = Source.Comments FROM @VC3ETL_LoadColumn Source JOIN VC3ETL.LoadColumn Destination ON Source.ID = Destination.ID

set nocount off;

COMMIT TRAN
