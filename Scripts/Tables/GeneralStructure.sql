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
CREATE TABLE ServiceInvoice (
  ServInvoiceId DECIMAL(5) NOT NULL,
  CustId DECIMAL(5) NOT NULL,
  TeamId DECIMAL(5) NOT NULL,
  InvoiceDate DATE NOT NULL,
  PRIMARY KEY (ServInvoiceId),
  CONSTRAINT fk_Customer_ServiceInvoice
    FOREIGN KEY (CustId)
    REFERENCES Customer (CustId),
  CONSTRAINT fk_Team_ServiceInvoice
    FOREIGN KEY (TeamId)
    REFERENCES Team (TeamId)
)
;

-- -----------------------------------------------------
-- Table InvoiceService
-- -----------------------------------------------------
CREATE TABLE InvoiceService (
  ServId DECIMAL(5) NOT NULL,
  ServInvoiceId DECIMAL(5) NOT NULL,
  Hours DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (ServId, ServInvoiceId),
  CONSTRAINT fk_ServId_InvoiceService
    FOREIGN KEY (ServId)
    REFERENCES Service (ServId),
  CONSTRAINT fk_ServInvoiceId_InvoiceService
    FOREIGN KEY (ServInvoiceId)
    REFERENCES ServiceInvoice (ServInvoiceId),
  CONSTRAINT ck_Hours_ServiceInvoice
  CHECK (Hours > 0)
)
;

-- -----------------------------------------------------
-- Table InvoiceEquipment
-- -----------------------------------------------------
CREATE TABLE InvoiceEquipment (
  EquipUsedId DECIMAL(5) NOT NULL,
  ServInvoiceId DECIMAL(5) NOT NULL,
  PRIMARY KEY (EquipUsedId, ServInvoiceId),
  CONSTRAINT fk_EquipUsedId_InvoiceEquipment
    FOREIGN KEY (EquipUsedId)
    REFERENCES Equipment (EquipUsedId),
  CONSTRAINT fk_ServInvoiceId_InvoiceEquipment
    FOREIGN KEY (ServInvoiceId)
    REFERENCES ServiceInvoice (ServInvoiceId)
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
CREATE TABLE EmployeeSkill (
  SkillId DECIMAL(5) NOT NULL,
  EmpId DECIMAL(5) NOT NULL,
  PRIMARY KEY (SkillId, EmpId),
  CONSTRAINT fk_Skill_EmployeeSkill
    FOREIGN KEY (SkillId)
    REFERENCES Skill (SkillId),
  CONSTRAINT fk_Employee_EmployeeSkill
    FOREIGN KEY (EmpId)
    REFERENCES Employee (EmpId)
)
;


-- -----------------------------------------------------
-- Table ProductInvoice
-- -----------------------------------------------------
CREATE TABLE ProductInvoice (
  ProdInvoiceId DECIMAL(5) NOT NULL,
  EmpId DECIMAL(5) NOT NULL,
  CustId DECIMAL(5) NOT NULL,
  InvDate DATE NOT NULL,
  PRIMARY KEY (ProdInvoiceId),
  CONSTRAINT fk_Employee_ProductInvoice
    FOREIGN KEY (EmpId)
    REFERENCES Employee (EmpId),
  CONSTRAINT fk_Customer_ProductInvoice
    FOREIGN KEY (CustId)
    REFERENCES Customer (CustId) 
)
;

-- -----------------------------------------------------
-- Table ProductInvoice
-- -----------------------------------------------------
CREATE TABLE InvoiceProduct (
  ProdInvoiceId DECIMAL(5) NOT NULL,
  ProdId DECIMAL(5) NOT NULL,
  Quantity DECIMAL(4) NOT NULL,
  PRIMARY KEY (ProdInvoiceId, ProdId),
  CONSTRAINT fk_ProdInvoiceId_InvoiceProduct
    FOREIGN KEY (ProdInvoiceId)
    REFERENCES ProductInvoice (ProdInvoiceId),
  CONSTRAINT fk_ProdId_InvoiceProduct
    FOREIGN KEY (ProdId)
    REFERENCES Product (ProdId),
  CONSTRAINT ck_Qty_ProductInvoice
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