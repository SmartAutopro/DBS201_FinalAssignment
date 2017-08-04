-- One Script to rule them all, One Script to find them,
-- One Script to bring them all and in the darkness bind them

--------------------------------------------------------
--------------------- TABLES ---------------------------
--------------------------------------------------------

-- -----------------------------------------------------
-- Table Class
-- -----------------------------------------------------
CREATE TABLE Class (
  ClassId DECIMAL(5) NOT NULL,
  ClassDesc VARCHAR(45) NOT NULL,
  ClassInitials VARCHAR(2) NOT NULL,
  PRIMARY KEY (ClassId),
  CONSTRAINT un_ClassInitials_Class
  UNIQUE (ClassInitials)
)
;


-- -----------------------------------------------------
-- Table Product
-- -----------------------------------------------------
CREATE TABLE Product (
  ProdId DECIMAL(5) NOT NULL,
  ClassId DECIMAL(5) NOT NULL,
  ProdDesc VARCHAR(45) NOT NULL,
  Markup DECIMAL(4,2),
  UnitPrice DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (ProdId),
  CONSTRAINT fk_ClassId_Product
    FOREIGN KEY (ClassId)
    REFERENCES Class (ClassId),
  CONSTRAINT ck_UnitPrice_Product
  CHECK (UnitPrice > 0),
  CONSTRAINT ck_Markup_Product
  CHECK (Markup > 0 AND Markup < 100)
)
;


-- -----------------------------------------------------
-- Table Customer
-- -----------------------------------------------------
CREATE TABLE Customer (
  CustId DECIMAL(5) NOT NULL,
  CustFirstNam VARCHAR(45) NOT NULL,
  CustLastNam VARCHAR(45) NOT NULL,
  CustStreet VARCHAR(45),
  CustRegion VARCHAR(45),
  CustZip VARCHAR(10) ,
  PRIMARY KEY (CustId)
)
;


-- -----------------------------------------------------
-- Table Equipment
-- -----------------------------------------------------
CREATE TABLE Equipment (
  EquipUsedId DECIMAL(5) NOT NULL,
  EquipDesc VARCHAR(45) NOT NULL,
  PRIMARY KEY (EquipUsedId)
)
;


-- -----------------------------------------------------
-- Table Service
-- -----------------------------------------------------
CREATE TABLE Service (
  ServId DECIMAL(5) NOT NULL,
  ServDesc VARCHAR(45) NOT NULL,
  ServInitials VARCHAR(2) NOT NULL,
  HourlyCharge DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (ServId),
  CONSTRAINT un_ServInitials_Service
  UNIQUE (ServInitials),
  CONSTRAINT ck_HourlyCharge_Service
  CHECK (HourlyCharge > 0)
)
;


-- -----------------------------------------------------
-- Table Skill
-- -----------------------------------------------------
CREATE TABLE Skill (
  SkillId DECIMAL(5) NOT NULL,
  SkillDesc VARCHAR(45) NOT NULL,
  PRIMARY KEY (SkillId)
)
;


-- -----------------------------------------------------
-- Table Position
-- -----------------------------------------------------
CREATE TABLE Position (
  PositionId DECIMAL(5) NOT NULL,
  PositionDesc VARCHAR(45) NOT NULL,
  PRIMARY KEY (PositionId)
)
;


-- -----------------------------------------------------
-- Table Team
-- -----------------------------------------------------
CREATE TABLE Team (
  TeamId DECIMAL(5) NOT NULL,
  TeamDesc VARCHAR(45) NOT NULL,
  PRIMARY KEY (TeamId)
)
;

-- -----------------------------------------------------
-- Table ServiceInvoice
-- -----------------------------------------------------
CREATE TABLE ServInv (
  ServInvoiceId DECIMAL(5) NOT NULL,
  CustId DECIMAL(5) NOT NULL,
  TeamId DECIMAL(5) NOT NULL,
  InvoiceDate DATE NOT NULL,
  PRIMARY KEY (ServInvoiceId),
  CONSTRAINT fk_Customer_ServInv
    FOREIGN KEY (CustId)
    REFERENCES Customer (CustId),
  CONSTRAINT fk_Team_ServInv
    FOREIGN KEY (TeamId)
    REFERENCES Team (TeamId)
)
;

-- -----------------------------------------------------
-- Table InvoiceService
-- -----------------------------------------------------
CREATE TABLE InvServ (
  ServId DECIMAL(5) NOT NULL,
  ServInvoiceId DECIMAL(5) NOT NULL,
  Hours DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (ServId, ServInvoiceId),
  CONSTRAINT fk_ServId_InvServ
    FOREIGN KEY (ServId)
    REFERENCES Service (ServId),
  CONSTRAINT fk_ServInvoiceId_InvServ
    FOREIGN KEY (ServInvoiceId)
    REFERENCES ServInv (ServInvoiceId),
  CONSTRAINT ck_Hours_ServInv
  CHECK (Hours > 0)
)
;

-- -----------------------------------------------------
-- Table InvoiceEquipment
-- -----------------------------------------------------
CREATE TABLE InvEquip (
  EquipUsedId DECIMAL(5) NOT NULL,
  ServInvoiceId DECIMAL(5) NOT NULL,
  PRIMARY KEY (EquipUsedId, ServInvoiceId),
  CONSTRAINT fk_EquipUsedId_InvEquip
    FOREIGN KEY (EquipUsedId)
    REFERENCES Equipment (EquipUsedId),
  CONSTRAINT fk_ServInvoiceId_InvEquip
    FOREIGN KEY (ServInvoiceId)
    REFERENCES ServInv (ServInvoiceId)
)
;

-- -----------------------------------------------------
-- Table Employee
-- -----------------------------------------------------
CREATE TABLE Employee (
  EmpId DECIMAL(5) NOT NULL,
  PositionId DECIMAL(5) NOT NULL,
  TeamId DECIMAL(5) ,
  EmpFirstNam VARCHAR(45) NOT NULL,
  EmpLastNam VARCHAR(45) NOT NULL,
  OHIPNum DECIMAL(10) ,
  HomePhone VARCHAR(15) ,
  StartDate DATE NOT NULL,
  PRIMARY KEY (EmpId),
  CONSTRAINT fk_PositionId_Employee
    FOREIGN KEY (PositionId)
    REFERENCES Position (PositionId),
  CONSTRAINT fk_Employee_Employee
    FOREIGN KEY (TeamId)
    REFERENCES Team (TeamId),
  CONSTRAINT ck_OHIPNum_Employee
  CHECK (OHIPNum > 0)
)
;


-- -----------------------------------------------------
-- Table Supplier
-- -----------------------------------------------------
CREATE TABLE Supplier (
  SupId DECIMAL(4) NOT NULL,
  SupDesc VARCHAR(45) NOT NULL,
  PRIMARY KEY (SupId)
)
;


-- -----------------------------------------------------
-- Table EmployeeSkill
-- -----------------------------------------------------
CREATE TABLE EmpSkill (
  SkillId DECIMAL(5) NOT NULL,
  EmpId DECIMAL(5) NOT NULL,
  PRIMARY KEY (SkillId, EmpId),
  CONSTRAINT fk_Skill_EmpSkill
    FOREIGN KEY (SkillId)
    REFERENCES Skill (SkillId),
  CONSTRAINT fk_Employee_EmpSkill
    FOREIGN KEY (EmpId)
    REFERENCES Employee (EmpId)
)
;


-- -----------------------------------------------------
-- Table ProductInvoice
-- -----------------------------------------------------
CREATE TABLE ProdInv (
  ProdInvoiceId DECIMAL(5) NOT NULL,
  EmpId DECIMAL(5) NOT NULL,
  CustId DECIMAL(5) NOT NULL,
  InvDate DATE NOT NULL,
  PRIMARY KEY (ProdInvoiceId),
  CONSTRAINT fk_Employee_ProdInv
    FOREIGN KEY (EmpId)
    REFERENCES Employee (EmpId),
  CONSTRAINT fk_Customer_ProdInv
    FOREIGN KEY (CustId)
    REFERENCES Customer (CustId) 
)
;

-- -----------------------------------------------------
-- Table InvoiceProduct
-- -----------------------------------------------------
CREATE TABLE InvProd (
  ProdInvoiceId DECIMAL(5) NOT NULL,
  ProdId DECIMAL(5) NOT NULL,
  Quantity DECIMAL(4) NOT NULL,
  PRIMARY KEY (ProdInvoiceId, ProdId),
  CONSTRAINT fk_ProdInvoiceId_InvoiceProduct
    FOREIGN KEY (ProdInvoiceId)
    REFERENCES ProdInv (ProdInvoiceId),
  CONSTRAINT fk_ProdId_InvoiceProduct
    FOREIGN KEY (ProdId)
    REFERENCES Product (ProdId),
  CONSTRAINT ck_Qty_ProdInv
  CHECK (Quantity > 0)
)
;


-- -----------------------------------------------------
-- Table Inventory
-- -----------------------------------------------------
CREATE TABLE Inventory (
  AisleId DECIMAL(5) NOT NULL,
  SupId DECIMAL(5) NOT NULL,
  ProdId DECIMAL(5) NOT NULL,
  InvQuantity DECIMAL(4) NOT NULL,
  PRIMARY KEY (AisleId, SupId, ProdId),
  CONSTRAINT fk_Supplier_Inventory
    FOREIGN KEY (SupId)
    REFERENCES Supplier (SupId),
  CONSTRAINT fk_Product_Inventory
    FOREIGN KEY (ProdId)
    REFERENCES Product (ProdId),
  CONSTRAINT ck_InvQuantity_Inventory
  CHECK (InvQuantity > 0)
)
;

--------------------------------------------------------
---------------------- VIEWS ---------------------------
--------------------------------------------------------

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
FROM ServInv si, InvServ ise, InvEquip ie, Customer c, Equipment e, Service s, Team t
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
FROM Service s, ServInv si, InvServ ise, Customer c, Team t
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
FROM Product p, ProdInv pi, InvProd ip, Class c, Employee e, Customer cu
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
FROM Employee e, Team t, Skill s, Position p, EmpSkill es
WHERE e.TeamId = t.TeamId AND
      e.PositionId = p.PositionId AND
      e.EmpId = es.EmpId AND
      es.SkillId = s.SkillId;

--------------------------------------------------------
---------------------- INSERTS -------------------------
--------------------------------------------------------

-- -----------------------------------------------------
-- Table Class
-- -----------------------------------------------------
INSERT INTO Class VALUES
(1, 'Garden Tools', 'GT'),
(2, 'Shrubs', 'SB'),
(3, 'Fertilizers', 'FT'),
(4, 'Sprinklers', 'SP')
;

-- -----------------------------------------------------
-- Table Product
-- -----------------------------------------------------
INSERT INTO Product VALUES
(10, 1, '6 foot garden rake', 30, 9.23),
(20, 1, '7 foot leaf rake', 30, 7.69),
(30, 1, 'Round mouth shovel', 30, 7.69),
(40, 1, 'Flat-nosed Shovel', 30, 6.15),
(50, 1, 'Garden pitch-fork', 30, 5.38),
(60, 1, '8 inch hand shears', 30, 11.54),
(70, 1, '12 inch trimming shears', 30, 14.62),
(80, 1, '10 inch tamper', 30, 10.77),
(90, 2, 'Cedar sapling', 50, 20),
(100, 2, 'Golden cedar sapling', 50, 23.33),
(110, 2, 'Mulberry sapling', 50, 10),
(120, 2, 'Juniper sapling', 50, 16.67),
(130, 3, 'Premium lawn fertilizer', 25, 12),
(140, 3, 'General grade lawn fertilizer', 25, 8),
(150, 3, 'Premium garden fertilizer', 25, 14.40),
(160, 3, 'General grade garden fertilizer', 25, 9.60),
(170, 4, '120 foot watering hose', 40, 17.86),
(180, 4, '12 inch aluminum sprinkler', 40, 10.71),
(190, 4, 'Rotating sprinkler jet', 40, 13.57)
;

-- -----------------------------------------------------
-- Table Supplier
-- -----------------------------------------------------
INSERT INTO Supplier VALUES
(1, 'Sheffield-Gander inc.'),
(2, 'Husky Inc.'),
(3, 'Northwood Farms inc.'),
(4, 'Sherwood Nursery'),
(5, 'Diemar Garden Center')
;

-- -----------------------------------------------------
-- Table Inventory
-- -----------------------------------------------------
INSERT INTO Inventory VALUES
(1, 1, 10, 5),
(1, 1, 20, 5),
(1, 2, 30, 4),
(1, 2, 40, 2),
(1, 2, 50, 6),
(2, 1, 60, 9),
(2, 1, 70, 10),
(2, 2, 80, 3),
(5, 3, 90, 34),
(5, 3, 100, 23),
(4, 4, 110, 12),
(4, 3, 120, 15),
(6, 4, 130, 4),
(6, 4, 140, 12),
(6, 4, 150, 14),
(6, 4, 160, 12),
(3, 5, 170, 9),
(3, 5, 180, 5),
(3, 5, 190, 4)
;


-- -----------------------------------------------------
-- Table Equipment
-- -----------------------------------------------------
INSERT INTO Equipment VALUES
(1, '20 hp John Deer tractor/ mower'),
(2, '10" tree pruning shears'),
(3, '2 hp Johnson grass trimmer'),
(4, 'Haggmann garden-tiller')
;

-- -----------------------------------------------------
-- Table Position
-- -----------------------------------------------------
INSERT INTO Position VALUES
(1, 'Supervisor'),
(2, 'Lawn Care'),
(3, 'Sales Assistant')
;

-- -----------------------------------------------------
-- Table Customer
-- -----------------------------------------------------
INSERT INTO Customer VALUES
(56, 'John', 'Adams', '234 King St.', 'Oakville', 'M2S4S3'),
(34, 'Ashley', 'Riley', '156 Avindale Cresc', 'Oakville', 'M4T4R7'),
(7, 'Rick', 'Sanchez', 'Smith St.', 'Earth', 'DIM137'),
(8, 'Morty', 'Smith', 'Smith St.', 'Earth', 'DIMXXX')
;

-- -----------------------------------------------------
-- Table Team
-- -----------------------------------------------------
INSERT INTO Team VALUES
(1, 'General Contracting'),
(2, 'Pruning and Planting'),
(3, 'General Maintenance'),
(4, 'Sales')
;

-- -----------------------------------------------------
-- Table Employee
-- -----------------------------------------------------
INSERT INTO Employee VALUES
(120, 1, 1, 'Wendy', 'Ames', 219032002, '905-338-1234', '1998-01-01'),
(122, 2, 1, 'Terry', 'Wilson', 34111991, '905-338-1234', '1999-06-30'),
(121, 2, 2, 'Marry', 'Wells', 325443001, '416-458-4562', '1998-06-30'),
(123, 1, 2, 'Peter', 'Wong', 54222991, '416-932-4533', '2000-06-30'),
(124, 2, 3, 'Carrie', 'Fisher', 43524532, '905-345-5366', '1998-08-23'),
(126, 1, 3, 'Brad', 'Phillips', 32543555, '416-435-6599', '2001-03-03'),
(155, 3, 4, 'Gordon', 'Brown', 12345678, '647-771-9090', '2009-03-03'),
(158, 3, 4, 'Susan', 'Gill', 987654321, '123-456-7890', '2010-05-10')
;

-- -----------------------------------------------------
-- Table Skill
-- -----------------------------------------------------
INSERT INTO Skill VALUES
(1, 'Electrical'),
(2, 'Plumbing'),
(3, 'General Contractor'),
(4, 'Irrigation'),
(5, 'Lawn Maintenance'),
(6, 'Pruning'),
(7, 'Fertilizing'),
(8, '"A" License'),
(9, 'Sales Persuasion')
;

-- -----------------------------------------------------
-- Table EmployeeSkill
-- -----------------------------------------------------
INSERT INTO EmpSkill VALUES
(1, 120),
(2, 120),
(3, 120),
(4, 122),
(5, 122),
(6, 121),
(4, 121),
(7, 121),
(8, 123),
(1, 123),
(3, 123),
(6, 124),
(5, 124),
(4, 126),
(2, 126),
(1, 126),
(9, 155),
(9, 158)
;

-- -----------------------------------------------------
-- Table Service
-- -----------------------------------------------------
INSERT INTO Service VALUES
(1, 'Lawn Cutting', 'LC', 25),
(2, 'Lawn Weeding', 'LW', 35),
(3, 'Lawn Fertilizing', 'LF', 15),
(4, 'Tree Pruning', 'TG', 45),
(5, 'Garden Weeding', 'GW', 25),
(6, 'Garden Planting', 'GP', 30),
(7, 'Garden Fertilizing', 'GF', 10)
;

-- -----------------------------------------------------
-- Table ProductInvoice
-- -----------------------------------------------------
INSERT INTO ProdInv VALUES
(1356, 155, 56, '2002-07-05'),
(1367, 158, 7, '2002-07-06'),
(1401, 155, 34, '2002-07-06'),
(1405, 158, 56, '2002-07-07')
;

-- -----------------------------------------------------
-- Table InvoiceProduct
-- -----------------------------------------------------
INSERT INTO InvProd VALUES
(1356, 10, 1),
(1356, 40, 1),
(1356, 140,  3),
(1367, 100, 5),
(1367, 110, 2),
(1367, 50, 1),
(1367, 140, 2),
(1401, 170, 3),
(1401, 190, 3),
(1405, 50, 1)
;

-- -----------------------------------------------------
-- Table ServiceInvoice
-- -----------------------------------------------------
INSERT INTO ServInv VALUES
(1355, 56, 2, '2017-06-05'),
(1412, 34, 3, '2017-06-19')
;

-- -----------------------------------------------------
-- Table InvoiceService
-- -----------------------------------------------------
INSERT INTO InvServ VALUES
(1, 1355, 0.75),
(2, 1355, 1.15),
(3, 1355, 0.25),
(4, 1355, 0.50),
(1, 1412, 0.75),
(5, 1412, 1.15),
(6, 1412, 0.25),
(7, 1412, 0.50)
;

-- -----------------------------------------------------
-- Table InvoiceEquipment
-- -----------------------------------------------------
INSERT INTO InvEquip VALUES
(1, 1355),
(2, 1355),
(3, 1355),
(1, 1412),
(3, 1412),
(4, 1412)
;