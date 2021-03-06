-- Florida
CREATE view [dbo].[SpecialEdStudentsAndIEPs]
as
select 
	s.GStudentID,
	ic.iepseqnum, 
	AgeGroup = case when dbo.fn_AgeAsOf(ic.MeetDate, s.Birthdate) < 6 then 'PK' else 'K12' end,
	a.Placement, 
	StateCode = 
		case when dbo.fn_AgeAsOf(ic.MeetDate, s.Birthdate) < 6 then 
			-- 'PK' 
			case a.Placement
				when 9 then 'A'
				when 6 then 'B'
				when 5 then 'S'
				when 1 then ''
				when 2 then ''
				when 3 then ''
				when 8 then ''
				when 0 then ''
				else 'ZZZ'
			end
		else 
			-- 'K12' 
			case a.Placement
				when 7 then 'C'
				when 5 then 'D'
				when 6 then 'F'
				when 4 then 'H'
				when 1 then ''
				when 2 then ''
				when 3 then ''
				when 8 then ''
				when 0 then ''
				else 'ZZZ'
			end
		end,
	s.SpedStat, s.SpedExitDate, s.SpedExitCode, ic.Meetdate, ESY = isnull(ic.ESY,0) -- a.age, 
-- Lee County has unresolved duplicate studnets that we are addressing here by excluding them from the student table.  if the other record qualifies, we'll extract it.
-- select s.*
from (select * from Student where GStudentID not in ('0C95AE12-F6D7-4A9C-903C-2B813397DD93', 'A9C3B373-F30A-4F28-861E-0738205907B7', 'E2B62796-6173-42D6-862E-4C62499C6872', '5403B0DE-2D84-431D-8F38-8E3A4D3E395F')) s -- '5403B0DE-2D84-431D-8F38-8E3A4D3E395F' marked inactive and has bad end date
-- cross join rvw_Today t 
-- join ReportIEPCompleteTblMax imax on s.gstudentid = imax.gstudentid -- need to resolve issue where same student has 2 active records in student table.  see ic join
join (select ic.GStudentID, s.StudentID, ic.IEPSeqNum, ic.MeetDate, ic.InitDate, ic.ESY from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0) ic
	on s.gstudentid = ic.gstudentid and
	ic.IEPSeqNum = (
		select max(maxrec.IEPSeqNum)
		from (select s.StudentID, ic.IEPSeqNum, ic.MeetDate from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0) maxrec 
		where ic.StudentID = maxrec.studentID and
		maxrec.MeetDate = (
			select max(maxdate.MeetDate)
			from (select s.StudentID, ic.IEPSeqNum, ic.MeetDate from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0 and ic.InitDate between '7/1/2010' and '4/2/2012') maxdate
			where maxrec.studentid = maxdate.studentid
			)
		)
join ICAssessmentTbl a on ic.IEPSeqNum = a.IEPComplSeqNum -- 25636 
where (SpedStat = 1 or (SpedStat = 2 and SpedExitDate > '7/1/2011')) -- 19630
-- and ic.IEPComplete = 'IEPComplete' -- 18255
and ic.MeetDate is not null -- 18255
and s.enrollstat = 1 -- 13340
and  a.AssessSeqNum = (
	select max(ain.AssessSeqNum) 
	from assessmenttbl ain
	where ain.gstudentid = a.gstudentid
	and isnull(ain.del_flag,0)=0
	) -- 13312
--and dbo.fn_AgeAsOf(ic.MeetDate, s.Birthdate) between 3 and 21 -- 13221
and placement is not null -- 13220
-- and ic.InitDate between '7/1/2010' and '4/2/2012' -- 2009: 11495, 2010: 11095
and isnull(s.del_flag,0)=0
and s.GStudentID in (select sd.GStudentID from StudDisability sd join DisabilityLook d on sd.DisabilityID = d.DisabilityID where isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1) 

--and s.StudentID = '3633020211'

