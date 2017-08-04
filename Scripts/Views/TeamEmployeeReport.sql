CREATE VIEW TeamEmployeeReport AS
SELECT e.TeamId AS "Team",
	 t.TeamDesc AS "Description",
       p.PositionDesc AS "Position",
       e.EmpFirstNam || ' ' || e.EmpLastNam AS "Name",
       e.EmpId AS "Emp. Id",
       e.OHIPNum AS "OHIP",
       e.HomePhone AS "Phone",
       e.StartDate AS "Start Date",
       s.SkillDesc AS "Skills"
FROM Employee e, Team t, Skill s, Position p, EmployeeSkill es
WHERE e.TeamId = t.TeamId AND
	e.PositionId = p.PositionId AND
	e.SkillId = es.SkillId AND
      es.SkillId = s.SkillId;