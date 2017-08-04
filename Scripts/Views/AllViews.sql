-- -----------------------------------------------------
-- View ServiceInvoiceStatement
-- -----------------------------------------------------
CREATE VIEW ServInvSt AS
SELECT si.ServInvoiceId AS "Invoice#",
       si.InvoiceDate AS "Invoice Date",
       t.TeamId AS "Work Team",
       e.EquipDesc AS "Equip. Used",
       c.CustFirstNam || ' ' || c.CustLastNam AS "Customer",
       c.CustStreet || ' ' || c.CustRegion || ' ' || c.CustZip AS "Customer Address",
       s.ServInitials AS "Service Code",
       s.ServDesc AS "Description",
       '$' || s.HourlyCharge AS "Hourly Charge",
       ise.Hours AS "Work Duration (hours)",
       '$' || (s.HourlyCharge * ise.Hours) AS "Total Charge"
FROM ServiceInvoice si, InvoiceService ise, InvoiceEquipment ie, Customer c, Equipment e, Service s, Team t
WHERE si.CustId = c.CustId AND
      si.TeamId = t.TeamId AND
      si.ServInvoiceId = ise.ServInvoiceId AND
      ise.ServId = s.ServId AND
      si.ServInvoiceId = ie.ServInvoiceId AND
      ie.EquipUsedId = e.EquipUsedId;

-- -----------------------------------------------------
-- View ServiceInvoiceStatementFooter
-- -----------------------------------------------------
CREATE VIEW ServInvStF AS
SELECT si.ServInvoiceId AS "Invoice#",
       si.InvoiceDate AS "Invoice Date",
       t.TeamId AS "Work Team",
       c.CustFirstNam || ' ' || c.CustLastNam AS "Customer",
       c.CustStreet || ' ' || c.CustRegion || ' ' || c.CustZip AS "Customer Address",
       '$' || SUM((s.HourlyCharge * Hours)) AS "Subtotal",
       '$' || SUM((s.HourlyCharge * Hours) * 0.07) AS "GST (7%)",
       '$' || SUM((s.HourlyCharge * Hours) * 0.08) AS "PST (8%)",
       '$' || SUM((s.HourlyCharge * Hours + (s.HourlyCharge * Hours) * 0.08) + (s.HourlyCharge * Hours) * 0.07) AS "Total Due"
FROM Service s, ServiceInvoice si, InvoiceService ise, Customer c, Team t
WHERE si.CustId = c.CustId AND
      si.TeamId = t.TeamId AND
      si.ServInvoiceId = ise.ServInvoiceId AND
      ise.ServId = s.ServId
GROUP BY si.ServInvoiceId, si.ServInvoiceId, si.InvoiceDate, t.TeamId, c.CustFirstNam, c.CustLastNam, c.CustStreet, c.CustRegion, c.CustZip;

-- -----------------------------------------------------
-- View ProductReport
-- -----------------------------------------------------
CREATE VIEW ProdRep AS
SELECT c.ClassInitials AS "Product Class",
       c.ClassDesc AS "Classification",
       p.ProdId AS "Product Id",
       p.ProdDesc AS "Description",
       '$' || p.UnitPrice AS "Cost",
       p.Markup || '%' AS "Markup",
       '$' || (p.UnitPrice * p.Markup / 100 + p.UnitPrice) AS "Charge"
FROM Product p, Class c
WHERE p.ClassId = c.ClassId;

-- -----------------------------------------------------
-- View ProductSalesReport
-- -----------------------------------------------------
CREATE VIEW ProdSalRep AS
SELECT c.ClassInitials AS "Prod Class",
       p.ProdId AS "Prod Id",
       p.ProdDesc AS "Product",
       '$' || (p.UnitPrice * p.Markup / 100 + p.UnitPrice) AS "Charge",
       ip.Quantity AS "Qty",
       pi.InvDate AS "Invoice Date",
       e.EmpId || ' - ' || e.EmpFirstNam || ' ' || e.EmpLastNam AS "Sales Assistant",
       pi.CustId AS "Cust No."
FROM Product p, ProductInvoice pi, InvoiceProduct ip, Class c, Employee e, Customer cu
WHERE pi.ProdInvoiceId = ip.ProdInvoiceId AND
      ip.ProdId = p.ProdId AND
      pi.CustId = cu.CustId AND
      pi.EmpId = e.EmpId AND
      p.ClassId = c.ClassId;

-- -----------------------------------------------------
-- View InventoryReport
-- -----------------------------------------------------
CREATE VIEW InvRep AS
SELECT i.ProdId AS "Product Id",
       p.ProdDesc AS "Description",
       i.InvQuantity AS "Inventory",
       i.AisleId AS "Aisle#",
       s.SupDesc AS "Supplier"
FROM Product p, Inventory i, Supplier s
WHERE i.ProdId = p.ProdId AND
      i.SupId = s.SupId;

-- -----------------------------------------------------
-- View TeamEmployeeReport
-- -----------------------------------------------------
CREATE VIEW TeamEmpRep AS
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
      e.EmpId = es.EmpId AND
      es.SkillId = s.SkillId;