SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE view SpecialEdStudentsAndIEPs
as
select s.GStudentID, ic.iepseqnum, 
	p.SchPrimInstrCode, 
	s.SpedStat, s.SpedExitDate, s.SpedExitCode, 
	ic.Meetdate, 
	ESY = ic.ESYElig 
from Student s 
join ReportIEPCompleteTbl ic on s.gstudentid = ic.gstudentid 
join ICIEPLRETbl p on ic.IEPSeqNum = p.IEPComplSeqNum and isnull(p.del_flag,0)=0 -- 6317
join StudDisability d on s.GStudentID = d.GStudentID and d.PrimaryDiasb = 1 and isnull(d.del_flag,0)=0
where ic.RecNum = (
	select max(icRec.RecNum)
	from IEPCompleteTbl icRec
	where isnull(icRec.del_flag,0)=0
	and ic.GStudentID = icRec.GStudentID 
	and icRec.MeetDate = (
		select max(icDt.MeetDate) 
		from IEPCompleteTbl icDt
		where icRec.GStudentID = icDt.GStudentID
		and isnull(icDt.del_flag,0)=0 
		and icDt.MeetDate = icRec.MeetDate
		)
	)
and 	(s.SpedStat = 1 or (s.SpedStat = 2 and s.SpedExitDate > convert(char(4), datepart(yy, getdate() ) - case when datepart(mm, getdate()) < 7 then 1 else 0 end)))  
and ic.MeetDate > dateadd(mm, -18, getdate())
and s.gstudentid in (select gstudentid from reportstudentschools)
and s.GStudentID in (select sd.GStudentID from StudDisability sd join DisabilityLook d on sd.DisabilityID = d.DisabilityID where isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1) -- 2641
and isnull(s.del_flag,0)=0
and s.enrollstat = 1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

