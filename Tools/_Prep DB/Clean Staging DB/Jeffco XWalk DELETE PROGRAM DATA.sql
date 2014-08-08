

set nocount on; -- set nocount off;

begin tran

set xact_abort on

declare @SaveStudents table (StudentID uniqueidentifier null, OldNumber varchar(50) not null, OldFirstname varchar(50) not null, OldLastname varchar(50) not null, NewNumber varchar(50), NewFirstname varchar(50) not null, NewLastname varchar(50) not null) ; 

declare @zg uniqueidentifier ; select @zg = '00000000-0000-0000-0000-000000000000'


-- delete manually entered students from previous x_WalkIEP imports
if exists (select 1 from sys.objects where name = 'x_WalkIEP.MAP_StudentRefID')
begin

delete ServicePlan where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID)
delete Attachment where VersionID in (select VersionID from PrgItem where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID))
delete PrgItem where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID)
delete PrgInvolvement where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID)
delete PrgVersionIntent where ItemIntentId in (select ID from PrgItemIntent where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID))
delete PrgItemIntent where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID)
delete StudentRosterYear where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID)
delete StudentClassRosterHistory where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID)
delete StudentGradeLevelHistory where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID)
delete StudentGroupStudent where StudentID in (select DestID from x_WalkIEP.MAP_StudentRefID)

delete Student where ID in (select DestID from x_WalkIEP.MAP_StudentRefID)
end

declare @attachmentfile table (ID uniqueidentifier not null)
insert @attachmentfile
select a.ID 
from Attachment a join 
FileData f on a.FileID = f.ID 

delete a
from @attachmentfile af 
join Attachment a on af.ID = a.ID

delete f
from @attachmentfile af 
join FileData f on af.ID = f.ID

-- delete sample student guardians from the mapping table
delete m from EFF.Map_StudentGuardianID m join EFF.StudentGuardians g on m.ID = g.GuardianID join @SaveStudents s on g.StudentID = s.OldNumber ; print 'Delete Guardian ID from MAP table : ' + convert(varchar(10), @@rowcount)

--select * from @SaveStudents -- test it

delete x from Attachment x left join PrgItem i on x.ItemID = i.ID where x.StudentID not in (
	select isnull(y.StudentID, @zg) 
	from @SaveStudents y
	union 
	select isnull(z.StudentID, @zg) 
	from @SaveStudents z join PrgItem on z.StudentID = i.StudentID) ; print 'Attachment : ' + convert(varchar(10), @@rowcount)

delete x from PrgDocument x join PrgItem i on x.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgDocument : ' + convert(varchar(10), @@rowcount)

delete x from IepDisabilityEligibility x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID  where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepDisabilityEligibility : ' + convert(varchar(10), @@rowcount)
delete x from IepGoal x join PrgGoal g on x.ID = g.ID join PrgSection ps on g.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID  where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepGoal : ' + convert(varchar(10), @@rowcount)
delete x from PrgGoalArea x join PrgGoals gs on x.InstanceID = gs.ID join PrgSection ps on gs.ID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'PrgGoalArea : ' + convert(varchar(10), @@rowcount)

delete x from IepJustification x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepJustification : ' + convert(varchar(10), @@rowcount)
delete x from IepPostSchoolArea x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepPostSchoolArea : ' + convert(varchar(10), @@rowcount)
delete x from IepSpecialFactor x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepSpecialFactor : ' + convert(varchar(10), @@rowcount)
delete x from IepTestAccom x join IepAccommodation ia on x.AccommodationID = ia.ID join IepAccommodationCategory iac on ia.CategoryID = iac.ID join PrgSection ps on ia.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepTestAccom : ' + convert(varchar(10), @@rowcount)

-- delete x from MosRelatedService x join PrgMatrixOfServices pms on x.MatrixOfServicesID = pms.ID join PrgItem i on pms.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'MosRelatedService : ' + convert(varchar(10), @@rowcount)
delete x from PrgActivity x join PrgItem i on x.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivity : ' + convert(varchar(10), @@rowcount)
delete x from PrgActivitySchedule x join PrgItem i on x.ItemId = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)
delete x from PrgGoal x join PrgSection ps on x.InstanceID = ps.ID join PrgItem i on ps.ItemId = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgGoal : ' + convert(varchar(10), @@rowcount)
delete x from PrgInterventionSubVariant x join PrgItem i on x.InterventionID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgInterventionSubVariant : ' + convert(varchar(10), @@rowcount)

delete x from PrgCrossVersionGoal x where ID not in (select CrossVersionGoalID from PrgGoal) ; print 'PrgCrossVersionGoal : ' + convert(varchar(10), @@rowcount)

delete x from PrgItemRel x join PrgItem i on x.InitiatingItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItemRel : ' + convert(varchar(10), @@rowcount)
delete x from PrgItemTeamMember x join PrgItem i on x.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'PrgItemTeamMember : ' + convert(varchar(10), @@rowcount)
-- delete x from PrgMatrixOfServices x join PrgItem i on x.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMatrixOfServices : ' + convert(varchar(10), @@rowcount)
delete x from PrgMilestone x join PrgItem i on x.StartingItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMilestone : ' + convert(varchar(10), @@rowcount)

delete x from PrgActivityBatch x join PrgItem i on x.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivityBatch : ' + convert(varchar(10), @@rowcount)
delete x from MedicaidExtractIssue x join ServiceDeliveryStudent y on y.ID = x.ServiceDeliveryStudentID where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'MedicaidExtractIssue : ' + convert(varchar(10), @@rowcount)
delete x from ServiceDeliveryStudent x where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServiceDeliveryStudent : ' + convert(varchar(10), @@rowcount)

delete x from ServicePlanDiagnosisCode x join ServicePlan y on x.PlanID = y.ID where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServicePlanDiagnosisCode : ' + convert(varchar(10), @@rowcount)

delete x from IepServicePlan x join ServicePlan sp on x.ID = sp.ID where sp.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'IepServicePlan : ' + convert(varchar(10), @@rowcount)
delete x from ServicePlan x where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServicePlan : ' + convert(varchar(10), @@rowcount)

delete x from PrgSection x join PrgItem i on x.ItemID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgSection : ' + convert(varchar(10), @@rowcount)

delete x from IepDisability x where deleteddate is not null  ; print 'IepDisability : ' + convert(varchar(10), @@rowcount) -- maintained by config import
delete x from IepPlacementOption x where DeletedDate is not null or Sequence = 99  ; print 'IepPlacementOption : ' + convert(varchar(10), @@rowcount)-- maintained by config import

-- new 
delete x from IepDisability x where x.DeterminationFormTemplateID is null 




-- set nocount off;
delete x from ServiceSchedule x where ID not in (select z.ID from ServiceSchedule z join ServiceScheduleServicePlan sssp on z.ID = sssp.ScheduleID join ServicePlan sp on sssp.ServicePlanID = sp.ID  where sp.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) )  ; print 'ServiceSchedule : ' + convert(varchar(10), @@rowcount)-- ??
delete x from ServiceSchedule x where ID not in (select z.ID from ServiceSchedule z join PrgLocation pl on z.LocationID = pl.ID where pl.DeletedDate is not null) ; print 'ServiceSchedule (for PrgLocation) : ' + convert(varchar(10), @@rowcount)-- ??
delete x from Schedule x where ID not in (select ID from ServiceSchedule ss) and ID not in (select distinct ProbeScheduleID from PrgGoal)  ; print 'Schedule : ' + convert(varchar(10), @@rowcount)-- ??
--Msg 547, Level 16, State 0, Line 115
--The DELETE statement conflicted with the REFERENCE constraint "FK_PrgGoal#ProbeSchedule#". The conflict occurred in database "Enrich_DCB2_CO_Mesa51", table "dbo.PrgGoal", column 'ProbeScheduleID'.
-- delete x from Schedule x 


delete s
-- select s.ID, pg.ID, ss.ID 
from Schedule s left join 
PrgGoal pg on s.ID = pg.ProbeScheduleID left join
ServiceSchedule ss on ss.ID = s.ID
where pg.ID is null and ss.ID is null

--select distinct ProbeScheduleID from PrgGoal 
--select * from PrgGoal g join PrgSection s on g.InstanceID = s.ID join PrgItem i on s.ItemID = i.ID left join @SaveStudents ss on i.StudentID = ss.StudentID where ss.StudentID is null



delete ServiceFrequency where DeletedDate is not null  /* Sequence = 99 */ ; print 'ServiceFrequency : ' + convert(varchar(10), @@rowcount) -- is there any benefit in attempting to delete Legacy data?

--update IepServiceDef set DefaultProviderTitleID = NULL where DefaultProviderTitleID in (select ID from ServiceProviderTitle t where t.DeletedDate is not null and t.ID not in (select distinct p.ProviderTitleID from UserProfile p where p.ProviderTitleID is not null) )
delete t from ServiceProviderTitle t where t.DeletedDate is not null and t.ID not in (select distinct p.ProviderTitleID from UserProfile p where p.ProviderTitleID is not null) ; print 'ServiceProviderTitle : ' + convert(varchar(10), @@rowcount) -- is there any benefit in attempting to delete Legacy data?

--delete s from Student s join x_WalkIEP.MAP_StudentRefID m on m.DestID = s.ID where m.LegacyData = 1 ; print 'Student : ' + convert(varchar(10), @@rowcount) -- s.ManuallyEntered = 1 -- is there any benefit in attempting to delete Legacy data?

delete x from ServiceDef sd join UserProfileServiceDefPermission x on sd.ID = x.ServiceDefID where sd.DeletedDate is not null and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents)) ; print 'UserProfileServiceDefPermission : ' + convert(varchar(10), @@rowcount) 
delete x from ServiceDef sd join ServiceDefDiagnosisCode x on sd.ID = x.ServiceDefID where sd.ID   in (select ID from ServiceDef where DeletedDate is not null )and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents))
delete x from ServiceDef sd join ServiceDefProcedure x on sd.ID = x.ServiceDefID where sd.ID  in (select ID from ServiceDef where DeletedDate is not null ) and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents))
delete sd from ServiceDef sd where DeletedDate is not null and sd.ID in (select ID from ServiceDef where DeletedDate is not null ) and sd.ID not in (select DefID from ServicePlan where StudentID in (select isnull(StudentID, @zg) from @SaveStudents)) ; print 'ServiceDef : ' + convert(varchar(10), @@rowcount) 


update sd set DefaultLocationID = NULL from ServiceDef sd where DefaultLocationID in (select ID from PrgLocation where DeletedDate is not null)


delete PrgLocation where DeletedDate is not null ; print 'PrgLocation : ' + convert(varchar(10), @@rowcount) -- is there any benefit in attempting to delete Legacy data?


-- moved PrgInvolvement
-- delete PrgItemTeamMember ; print 'PrgItemTeamMember : ' + convert(varchar(10), @@rowcount) -- ?.												Duplicate
delete x from Schedule x left join (
	select g.ID, g.ProbeScheduleID, i.StudentID
	from PrgGoal g join 
		PrgSection ps on g.InstanceID = ps.ID join 
		PrgItem i on ps.ItemID = i.ID 
	) g on x.ID = g.ProbeScheduleID left join (
	select sp.ID ServicePlanID, ss.ID ServiceScheduleID, sp.StudentID
	from ServiceSchedule ss join
		ServiceScheduleServicePlan sssp on ss.ID = sssp.ScheduleID join 
		ServicePlan sp on sssp.ServicePlanID = sp.ID
	) v on x.ID = v.ServiceScheduleID
where not (v.StudentID in (select isnull(StudentID, @zg) from @SaveStudents) or g.StudentID in (select isnull(StudentID, @zg) from @SaveStudents)) ; print 'Schedule : ' + convert(varchar(10), @@rowcount) -- ?

delete x from MedicaidCertification x ; print 'MedicaidCertification : ' + convert(varchar(10), @@rowcount)

delete x from ServiceDelivery x join ServiceDeliveryStudent sds on x.ID = sds.DeliveryID where sds.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ServiceDelivery : ' + convert(varchar(10), @@rowcount)
delete x from PrgVersionIntent x join PrgItemIntent i on x.ItemIntentId = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents); print 'PrgVersionIntent : ' + convert(varchar(10), @@rowcount)
delete x from PrgItemIntent x where x.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItemIntent : ' + convert(varchar(10), @@rowcount)

delete x from ProbeScore x join ProbeTime t on x.ProbeTimeID = t.ID  where t.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ProbeScore : ' + convert(varchar(10), @@rowcount)
delete x from ProbeTime x where x.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'ProbeTime : ' + convert(varchar(10), @@rowcount)

delete x from PrgGoalProgress x join PrgGoal g on x.GoalID = g.ID join PrgSection ps on g.InstanceID = ps.ID join PrgItem i on ps.ItemID = i.ID where i.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgGoalProgress : ' + convert(varchar(10), @@rowcount)
delete x from FormInstanceBatch x join FormInstance fi on x.Id = fi.FormInstanceBatchId join StudentForm sf on fi.Id = sf.Id where sf.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'FormInstanceBatch : ' + convert(varchar(10), @@rowcount)
-- ??
delete x from FormInstanceBatchRule x ; print 'FormInstanceBatchRule : ' + convert(varchar(10), @@rowcount)
delete x from FormInstanceInterval x join PrgItemForm pif on x.InstanceId = pif.ID join PrgItem i on pif.ItemID = i.ID where i.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents)  ; print 'FormInstanceInterval : ' + convert(varchar(10), @@rowcount)

delete x from StudentFormInstanceBatch x join FormInstance fi on x.id = fi.FormInstanceBatchID join StudentForm sf on fi.ID = sf.ID where sf.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'StudentFormInstanceBatch : ' + convert(varchar(10), @@rowcount)

delete x from PrgSection x join PrgItem y on y.ID = x.ItemID where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgSection : ' + convert(varchar(10), @@rowcount)

delete x from FormInstance x join PrgItemForm pif on x.Id = pif.ID join PrgItem i on pif.ItemID = i.ID where i.StudentId not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'FormInstance : ' + convert(varchar(10), @@rowcount)
-- assume PrgItemForm, a subclass of FormInstance, is cascade deleted

delete x from PrgActivitySchedule x join PrgItem y on y.ID = x.ItemId where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

delete x from PrgActivitySchedule x join IntvTool y on y.ID = x.ToolID join PrgItem z on z.ID = y.InterventionID where z.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

delete x from IntvTool x join PrgItem y on y.ID = x.InterventionID where y.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgActivitySchedule : ' + convert(varchar(10), @@rowcount)

-- moved this commented line here because there was an FK error on InitiatingIepID.  Not sure why it was commented out previously
delete x from PrgMatrixOfServices x join PrgItem i on x.ID = i.ID where i.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgMatrixOfServices : ' + convert(varchar(10), @@rowcount)
-- moved prgitem here because other deletion queries depend on it
delete x from PrgItem x where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgItem : ' + convert(varchar(10), @@rowcount)
delete x from PrgInvolvement x where x.StudentID not in (select isnull(StudentID, @zg) from @SaveStudents) ; print 'PrgInvolvement : ' + convert(varchar(10), @@rowcount)


delete dbo.PrgItemOutcome where NextStatusID in (select ID from PrgStatus where IsExit = 1 and ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and (DeletedDate is not null or Sequence = 99)) ; print 'PrgItemOutcome : ' + convert(varchar(10), @@rowcount) 

delete PrgStatus where IsExit = 1 and ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and (DeletedDate is not null or Sequence = 99) ; print 'PrgStatus : ' + convert(varchar(10), @@rowcount) 


--delete x from MosRatingDef x join PrgGoalAreaDef d on x.PrgGoalAreaDefID = x.ID where d.DeletedDate is not null and d.Sequence = 99

delete x from PrgGoalAreaDef x where x.DeletedDate is not null and x.Sequence = 99 -- IN FLA DO NOT DELETE under Sequence 99!!!


delete pts
-- select pts.*
from (select Number from School where deleteddate is null group by Number having COUNT(*) > 1) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 
join ProbeTypeSchool pts on h.ID = pts.SchoolID ; print 'ProbeTypeSchool : ' + convert(varchar(10), @@rowcount) 

-- where duplicate schools have been manually entered, save 1 of them
delete h
-- select h.*
from (select Number from School where deleteddate is null group by Number having COUNT(*) > 1) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 
where convert(varchar(36), h.ID) > (
	select top 1 convert(varchar(36), hd.ID)
	from School hd 
	where hd.Number = h.Number 
	order by hd.ManuallyEntered desc, hd.Street, convert(varchar(36), hd.ID) -- 1. save the SIS entered duplicate school,   2) keep the one with a street address, 3) arbitrarily order by GUID to pick one at random
	) ; print 'School : ' + convert(varchar(10), @@rowcount)

-- delete soft-deleted schools
delete pts
-- select pts.*
from (select Number from School where deleteddate is not null ) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 
join ProbeTypeSchool pts on h.ID = pts.SchoolID ; print 'ProbeTypeSchool : ' + convert(varchar(10), @@rowcount) 



-- NEW - only necessary sometimes.   It may be necessary to exclude records that should be preserved.  
declare @delstudents table (StudentID uniqueidentifier not null)
insert @delstudents
select x.ID -- select * 
from Student x 
where x.ManuallyEntered = 1
and ID not in (select isnull(StudentID, @zg) from @SaveStudents)

--select x.ID -- select * 
--into #TEST_delstudents
--from Student x 
--where x.ManuallyEntered = 1



delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join 
StudentRosterYear x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentGradeLevelHistory x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentSchoolHistory x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentTeacherClassRoster x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
TranscriptCourse x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentClassRosterHistory x on n.StudentID = x.StudentId

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentGroupStudent x on n.StudentID = x.StudentId


delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
StudentRecordException x on n.StudentID = x.Student2ID


delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
DisciplineIncident x on n.StudentID = x.StudentID

delete x 
-- select ManStud = s.ManuallyEntered, x.*
from @delstudents n join
ReportCardScore x on n.StudentID = x.Student


	delete x
	-- select x.*
	from @delstudents n join
	MedicaidAuthorization x on n.StudentID = x.StudentID 


	delete x
	-- select x.*
	from @delstudents n join
	StudentPhoto x on n.StudentID = x.StudentID 


	delete x
	from @delstudents n join
	ProbeType x on n.StudentID = x.CustomForStudentID 
	
	delete x
	--select x.*
	from @delstudents n join 
	TestBindingStudent x on n.studentId = x.studentID 

	delete x
	-- select x.*
	from @delstudents n join
	MedicaidEligibilityHistory x on n.StudentID = x.StudentID

	--delete x
	---- select n.*
	--from #TEST_delstudents n join
	--MedicaidEligibilityHistory x on n.ID = x.StudentID

	delete x
	-- select x.*
	from @delstudents n join
	Student x on n.StudentID = x.ID
--Msg 547, Level 16, State 0, Line 311 -- 1
--The DELETE statement conflicted with the REFERENCE constraint "FK_MedicaidEligibilityHistory#Student#MedicaidEligibilityHistories". The conflict occurred in database "Enrich_DC1_CO_Adams50", table "dbo.MedicaidEligibilityHistory", column 'StudentID'.
--Msg 547, Level 16, State 0, Line 316
--The DELETE statement conflicted with the REFERENCE constraint "FK_MedicaidEligibilityHistory#Student#MedicaidEligibilityHistories". The conflict occurred in database "Enrich_DC1_CO_Adams50", table "dbo.MedicaidEligibilityHistory", column 'StudentID'.


delete x
-- select x.*
from ProbeTypeSchool x join 
School s on x.SchoolID = s.ID
where s.ManuallyEntered = 1

delete x
from School x 
where x.ManuallyEntered = 1


delete h
-- select h.*
from (select Number from School where deleteddate is not null) n
join School h on n.Number = h.Number and h.ManuallyEntered = 1 and h.ID not in (select SchoolID from dbo.T_FCAT_ReadingAndMath) ; print 'School : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentRecordException x on s.ID = x.Student2ID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null ; print 'StudentRecordException : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentTeacherClassRoster x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'StudentTeacherClassRoster : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentRosterYear x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'StudentRosterYear : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
TranscriptCourse x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'TranscriptCourse : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
DisciplineIncident x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'DisciplineIncident : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentClassRosterHistory x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null  ; print 'StudentClassRosterHistory : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentGradeLevelHistory x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.StudentID is null  ; print 'StudentGradeLevelHistory : ' + convert(varchar(10), @@rowcount)

delete x
-- select s.ManuallyEntered, s.*
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentSchoolHistory x on s.ID = x.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.StudentID is null  ; print 'StudentSchoolHistory : ' + convert(varchar(10), @@rowcount)

-- the from and where clauses must match for the next 2 queries
delete sgs
from (select Number from Student group by Number having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentGroupStudent sgs on s.ID = sgs.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.StudentID is null ; print 'StudentGroupStudent by Number : ' + convert(varchar(10), @@rowcount)


-- these would be deleted
select z.studentid, s.ManuallyEntered, s.*
from (select Number = isnull(Number,'') from Student group by isnull(Number,'') having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 left join
@SaveStudents z on s.ID = z.StudentID

--select * from @SaveStudents

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ stop here	rollback
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

delete x
from PrgItemIntent x
left join @SaveStudents s on x.StudentId = s.StudentID
where s.StudentID is null ; print 'PrgItemIntent : ' + convert(varchar(10), @@rowcount)

delete s
-- select s.ManuallyEntered, s.*
from (select Number = isnull(Number,'') from Student group by isnull(Number,'') having COUNT(*) > 1 ) n join 
Student s on n.Number = s.Number and s.ManuallyEntered = 1 and s.IsActive = 1 left join
@SaveStudents z on s.ID = z.StudentID ; print 'Student by Number : ' + convert(varchar(10), @@rowcount)

-- the from and where clauses must match for the next 2 queries
delete sgs
from (select FirstName, LastName, DOB from Student where IsActive = 1 group by FirstName, LastName, DOB having COUNT(*) > 1 ) fld join 
Student s on fld.FirstName = s.FirstName and fld.LastName = s.LastName and fld.DOB = s.DOB and s.ManuallyEntered = 1 and s.IsActive = 1 join
StudentGroupStudent sgs on s.ID = sgs.StudentID left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null ; print 'StudentGroupStudent by Last, First, DOB : ' + convert(varchar(10), @@rowcount)

delete s
-- select s.ManuallyEntered, s.*
from (select FirstName, LastName, DOB from Student where IsActive = 1 group by FirstName, LastName, DOB having COUNT(*) > 1 ) fld join 
Student s on fld.FirstName = s.FirstName and fld.LastName = s.LastName and fld.DOB = s.DOB and s.ManuallyEntered = 1 and s.IsActive = 1 left join
@SaveStudents z on s.ID = z.StudentID 
where z.OldNumber is null and
s.ID not in (select Student2ID from StudentRecordException) ; print 'Student by Last, First, DOB : ' + convert(varchar(10), @@rowcount)


delete g
from GradeLevel g left join 
Student s on g.ID = s.CurrentGradeLevelID left join
IepStandard t on g.ID = t.MinGradeID left join 
ContentAreaRequirement c on g.ID = c.MinGradeID left join
StudentGradeLevelHistory h on g.ID = h.GradeLevelID
where Active = 0
and s.ID is null
and t.ID is null
and c.Id is null
and h.GradeLevelID is null
--and s.ID not in ( select isnull(StudentID, @zg) from @SaveStudents)


-- break the association between the mosratingdef and PrgGoalAreas that will be deleted.  is this okay?
update dbo.MosRatingDef set IepGoalAreaDefID = NULL where IepGoalAreaDefID in (select ID from dbo.PrgGoalAreaDef where DeletedDate is not null ) -- is this okay?
delete dbo.PrgGoalAreaDef where DeletedDate is not null -- 



-- clean out map table records if no dest rec

-- drop all of the data conversion objects in preparation for a fresh import

declare @d varchar(254) 
declare D cursor for 
select 
	'drop '+
	case o.Type when 'U' then 'table ' when 'V' then 'view ' when 'P' then 'proc ' else NULL end+
	s.name+'.'+o.name 
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id
where s.name in ('AURORAX')
-- and (o.type in ('V', 'P') or o.Type = 'U' and o.name like 'MAP_%')
and o.type in ('V', 'P', 'U') 
order by s.name, case o.Type when 'P' then 0 when 'V' then 1 when 'U' then 2 end

open D
fetch D into @d
while @@fetch_status = 0
begin

exec (@d)

fetch D into @d
end 
close D
deallocate D

delete VC3Deployment.Version where Module in ('AURORAX')
delete VC3Deployment.ModuleDependency where Uses in ('AURORAX')
delete VC3Deployment.Module where ID in ('AURORAX')


if exists (select 1 from sys.schemas where name = 'AURORAX')
drop schema AURORAX
go





if exists (select 1 from sys.schemas where name = 'x_WalkIEP')
begin

print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX DELETING x_WalkIEP XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'




if exists (select 1 from sys.objects where name = 'x_WalkIEP.MAP_IepRefID')
begin
delete x -- select *
from x_WalkIEP.MAP_IepRefID x -- map
where DestID not in (select ID from PrgItem) -- destination
print 'x_WalkIEP.MAP_IepRefID : ' +convert(varchar(10), @@rowcount)

if exists (select 1 from sys.objects where name = 'x_WalkIEP.MAP_PrgSectionID_NonVersioned')
begin
delete x -- select *
from x_WalkIEP.MAP_PrgSectionID_NonVersioned x -- map
where DestID not in (select ID from PrgSection) -- destination
print 'x_WalkIEP.MAP_PrgSectionID_NonVersioned : ' +convert(varchar(10), @@rowcount)
end

delete x -- select *
from x_WalkIEP.MAP_OrgUnitID x -- map
where DestID not in (select ID from OrgUnit) -- destination
print 'x_WalkIEP.MAP_OrgUnitID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_StudentRefID s join
dbo.Student x on s.DestID = x.ID 
where x.ManuallyEntered = 1
print 'dbo.Student (manually entered) : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_StudentRefID x -- map
--where DestID not in (select ID from Student) -- destination ------------------------------ we want all of them gone.  what about their manually added student records?
print 'x_WalkIEP.MAP_StudentRefID : ' +convert(varchar(10), @@rowcount)

print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 05 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'


delete x -- select *
from x_WalkIEP.MAP_PrgVersionID x -- map
where DestID not in (select ID from PrgVersion) -- destination
print 'x_WalkIEP.MAP_PrgVersionID : ' +convert(varchar(10), @@rowcount)

-- new
if exists (select 1 from sys.objects where name = 'x_WalkIEP.MAP_PrgGoalAreaDefID' and type = 'U')
begin
delete x -- select *
from x_WalkIEP.MAP_PrgGoalAreaDefID x -- map
where DestID not in (select ID from PrgGoal) -- destination
print 'x_WalkIEP.MAP_PrgGoalAreaDefID : ' +convert(varchar(10), @@rowcount)
end

delete x -- select *
from x_WalkIEP.MAP_PrgGoalID x -- map
where DestID not in (select ID from PrgGoal) -- destination
print 'x_WalkIEP.MAP_PrgGoalID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_IepPlacementID x -- map
where DestID not in (select ID from IepPlacement) -- destination
print 'x_WalkIEP.MAP_IepPlacementID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_ServiceProviderTitleID x -- map
where DestID not in (select ID from ServiceProviderTitle) -- destination
print 'x_WalkIEP.MAP_ServiceProviderTitleID : ' +convert(varchar(10), @@rowcount)

print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 10 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'


delete x -- select *
from x_WalkIEP.MAP_ScheduleID x -- map
where DestID not in (select ID from Schedule) -- destination
print 'x_WalkIEP.MAP_ScheduleID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_ServicePlanID x -- map
where DestID not in (select ID from ServicePlan) -- destination
print 'x_WalkIEP.MAP_ServicePlanID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_IepDisabilityEligibilityID  x -- map
where DestID not in (select ID from IepDisabilityEligibility) -- destination
print 'x_WalkIEP.MAP_IepDisabilityEligibilityID  : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_PrgLocationID x -- map
where DestID not in (select ID from PrgLocation) -- destination
print 'x_WalkIEP.MAP_PrgLocationID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_IepDisabilityID x -- map
where DestID not in (select ID from IepDisability) -- destination
print 'x_WalkIEP.MAP_IepDisabilityID : ' +convert(varchar(10), @@rowcount)

print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 15 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'


delete x -- select *
from x_WalkIEP.MAP_GradeLevelID x -- map
where DestID not in (select ID from GradeLevel) -- destination
print 'x_WalkIEP.MAP_GradeLevelID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_ServiceFrequencyID x -- map
where DestID not in (select ID from ServiceFrequency) -- destination
print 'x_WalkIEP.MAP_ServiceFrequencyID : ' +convert(varchar(10), @@rowcount)

--delete x -- select *
--from x_WalkIEP.MAP_IepServiceCategoryID x -- map
--where DestID not in (select ID from IepServiceCategory) -- destination
--print 'x_WalkIEP.MAP_IepServiceCategoryID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_PrgInvolvementID x -- map
where DestID not in (select ID from PrgInvolvement) -- destination
print 'x_WalkIEP.MAP_PrgInvolvementID : ' +convert(varchar(10), @@rowcount)

--delete x -- select *
--from x_WalkIEP.MAP_PrgGoalArea x -- map
--where DestID not in (select ID from PrgGoalArea) -- destination
--print 'x_WalkIEP.MAP_PrgGoalArea : ' +convert(varchar(10), @@rowcount)

print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 20 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

delete x -- select *
from x_WalkIEP.MAP_SchoolID x -- map
where DestID not in (select ID from School) -- destination
print 'x_WalkIEP.MAP_SchoolID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_PrgGoalObjectiveID x -- map
where DestID not in (select ID from PrgGoal) -- destination
print 'x_WalkIEP.MAP_PrgGoalObjectiveID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_PrgSectionID x -- map
where DestID not in (select ID from PrgSection) -- destination
print 'x_WalkIEP.MAP_PrgSectionID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_ServiceDefID x -- map
where DestID not in (select ID from ServiceDef) -- destination
print 'x_WalkIEP.MAP_ServiceDefID : ' +convert(varchar(10), @@rowcount)

delete x -- select *
from x_WalkIEP.MAP_IepPlacementOptionID x -- map
where DestID not in (select ID from IepPlacementOption) -- destination
print 'x_WalkIEP.MAP_IepPlacementOptionID : ' +convert(varchar(10), @@rowcount)

print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 25 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

delete x -- select *
from x_WalkIEP.MAP_PrgStatusID x -- map
where DestID not in (select ID from PrgStatus) -- destination
print 'x_WalkIEP.MAP_PrgStatusID : ' +convert(varchar(10), @@rowcount)

if exists (select 1 from sys.objects where name = 'x_WalkIEP.Lookups')
begin
drop view x_WalkIEP.Lookups
drop table x_WalkIEP.Lookups_LOCAL
end

end

print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 27 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_WalkIEP' and o.name = 'DataConversionLog')
begin
	drop table x_WalkIEP.DataConversionLog
end

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_WalkIEP' and o.name = 'DataConversionLogTable')
begin
	drop table x_WalkIEP.DataConversionLogTable
end


-- truncate all of the x_WalkIEP tables
declare @d varchar(254) 
declare D cursor for 
select 'print ''truncating : '+s.name+'.'+o.name+'''
truncate table '+s.name+'.'+o.name 
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id
where s.name in ('x_WalkIEP', 'SPEDDOC', 'x_LEGACYDOC', 'x_LEGACY504', 'x_LEGACYGIFT')
and o.type in ('U') 
order by s.name, case o.Type when 'P' then 0 when 'V' then 1 when 'U' then 2 end

open D
fetch D into @d
while @@fetch_status = 0
begin

exec (@d)
--print @d

fetch D into @d
end 
close D
deallocate D


end


-- fail orphaned data import tasks
update t set StatusID = 'F'
-- select * 
from VC3TaskScheduler.ScheduledTask t
where TaskTypeID = 'F03A0C51-7294-4B57-AFB7-AFF136E4025F' 
and (isnull(StatusID,'P') in ('P', 'R'))


delete t
-- select * 
from VC3TaskScheduler.ScheduledTask t
where TaskTypeID = 'F03A0C51-7294-4B57-AFB7-AFF136E4025F' -- order by starttime desc
and StartTime is null


declare @o varchar(100), @ut char(1), @n varchar(5), @q varchar(max); select @n = '
'
declare O cursor for 
select o.name, o.type from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_WalkIEP' and o.type in ('U', 'V') order by o.type desc, o.name

open O
fetch O into @o, @ut

while @@fetch_status = 0
begin

set @q = 'print ''dropping x_WalkIEP.'+@o+'''
if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = ''x_WalkIEP'' and o.name = '''+@o+''')
drop '+case when @ut = 'V' then 'view ' else 'table ' end+ 'x_WalkIEP.'+ @o+@n+@n

exec (@q)
--print @q

fetch O into @o, @ut
end
close O
deallocate O

go
/* */
declare @o varchar(100), @ut char(1), @n varchar(5), @q varchar(max); select @n = '
'

-- speddoc
declare O cursor for 
select o.name, o.type from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'SPEDDOC' and o.type in ('U', 'V') order by o.type desc, o.name

open O
fetch O into @o, @ut

while @@fetch_status = 0
begin

set @q = 'if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = ''SPEDDOC'' and o.name = '''+@o+''')
drop '+case when @ut = 'V' then 'view ' else 'table ' end+ 'SPEDDOC.'+ @o+@n+@n

exec (@q)

fetch O into @o, @ut
end
close O
deallocate O


-- x_LEGACYDOC
declare O cursor for 
select o.name, o.type from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYDOC' and o.type in ('U', 'V') order by o.type desc, o.name

open O
fetch O into @o, @ut

while @@fetch_status = 0
begin

set @q = 'if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = ''x_LEGACYDOC'' and o.name = '''+@o+''')
drop '+case when @ut = 'V' then 'view ' else 'table ' end+ 'x_LEGACYDOC.'+ @o+@n+@n

exec (@q)

fetch O into @o, @ut
end
close O
deallocate O




-- x_LEGACY504
declare O cursor for 
select o.name, o.type from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACY504' and o.type in ('U', 'V') order by o.type desc, o.name

open O
fetch O into @o, @ut

while @@fetch_status = 0
begin

set @q = 'if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = ''x_LEGACY504'' and o.name = '''+@o+''')
drop '+case when @ut = 'V' then 'view ' else 'table ' end+ 'x_LEGACY504.'+ @o+@n+@n

exec (@q)

fetch O into @o, @ut
end
close O
deallocate O



-- x_LEGACYGIFT
declare O cursor for 
select o.name, o.type from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.type in ('U', 'V') order by o.type desc, o.name

open O
fetch O into @o, @ut

while @@fetch_status = 0
begin

set @q = 'if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = ''x_LEGACYGIFT'' and o.name = '''+@o+''')
drop '+case when @ut = 'V' then 'view ' else 'table ' end+ 'x_LEGACYGIFT.'+ @o+@n+@n

exec (@q)

fetch O into @o, @ut
end
close O
deallocate O



delete v
-- select * 
from VC3Deployment.Version v
where Module in ('x_WalkIEP', 'x_WalkDOC', 'x_Walk')
	and scriptnumber > 0

UPDATE SystemSettings SET SecurityRebuiltDate = NULL

commit tran
--rollback tran
-- =============================================================================================================================== COMMIT

go


declare @t varchar(100), @q varchar(max)
declare T cursor for 
select DestTable from VC3ETL.LoadTable where ExtractDatabase = '004B264C-83C2-4BC9-8140-8BEE09B7FD06' and DestTable is not null and DestTable not like 'x_WalkIEP%'
union 
select 'PrgDocument'
union
select 'FormTemplate'
union
select DestTable from VC3ETL.LoadTable where ExtractDatabase = '35612529-9F3D-4971-A3DD-90E795E39080' and DestTable is not null and DestTable not like 'x_WalkDoc%'

open T 
fetch T into @t

while @@fetch_status = 0
begin

set @q = 'DBCC DBREINDEX ('+@t+')'
exec (@q)


fetch T into @t
end
close T
deallocate T


delete VC3Deployment.ModuleDependency where UsedBy = 'x_WalkIEP' and Uses like 'x[_]%'


--rollback tran


--select * from VC3ETL.ExtractDatabase

-- commit
