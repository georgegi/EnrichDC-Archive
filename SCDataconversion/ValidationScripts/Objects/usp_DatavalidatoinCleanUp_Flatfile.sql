IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Cleanup_Flatfile')
DROP PROC x_DATAVALIDATION.Cleanup_Flatfile
GO

CREATE PROC x_DATAVALIDATION.Cleanup_Flatfile 
AS
BEGIN

IF Object_id('x_DATAVALIDATION.SelectLists_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.SelectLists_LOCAL

IF Object_id('x_DATAVALIDATION.District_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.District_LOCAL

IF Object_id('x_DATAVALIDATION.School_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.School_LOCAL

IF Object_id('x_DATAVALIDATION.Student_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.Student_LOCAL

IF Object_id('x_DATAVALIDATION.IEP_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.IEP_LOCAL

IF Object_id('x_DATAVALIDATION.SpedStaffMember_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.SpedStaffMember_LOCAL

IF Object_id('x_DATAVALIDATION.Service_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.Service_LOCAL

IF Object_id('x_DATAVALIDATION.Goal_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.Goal_LOCAL

IF Object_id('x_DATAVALIDATION.Objective_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.Objective_LOCAL

IF Object_id('x_DATAVALIDATION.TeamMember_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.TeamMember_LOCAL

IF Object_id('x_DATAVALIDATION.StaffSchool_LOCAL') IS NOT NULL
DROP TABLE x_DATAVALIDATION.StaffSchool_LOCAL

DECLARE @sql nVARCHAR(MAX)

SET @sql  = 'DELETE x_DATAVALIDATION.ValidationReport'
EXEC sp_executesql @stmt=@sql

SET @sql  = 'DELETE vh FROM x_DATAVALIDATION.ValidationReportHistory vh WHERE ValidatedDate < (DATEADD(DD,-60,ValidatedDate))'
EXEC sp_executesql @stmt=@sql

SET @sql = 'DELETE x_DATAVALIDATION.ValidationSummaryReport'
EXEC sp_executesql @stmt = @sql

DELETE  x_DATAVALIDATION.SelectLists
DELETE  x_DATAVALIDATION.District
DELETE  x_DATAVALIDATION.School
DELETE  x_DATAVALIDATION.Student
DELETE  x_DATAVALIDATION.IEP
DELETE  x_DATAVALIDATION.SpedStaffMember
DELETE  x_DATAVALIDATION.Service
DELETE  x_DATAVALIDATION.Goal
DELETE  x_DATAVALIDATION.Objective
DELETE  x_DATAVALIDATION.TeamMember
DELETE  x_DATAVALIDATION.StaffSchool


END