CREATE VIEW ProductSalesReport AS
SELECT c.ClassInitials AS "Prod Class",
	 p.ProdId AS "Prod Id",
       p.ProdDesc AS "Product",
       ( '$' || (p.Markup / 100) * p.UnitPrice) AS "Charge",
       pi.Quantity AS "Qty",
       pi.InvceDate AS "Invoice Date",
       e.EmpId || ' - ' || e.EmpFirstNam || ' ' || e.EmpLastNam AS "Sales Assistant",
       pi.CustId AS "Cust No."
FROM Product p, Class c, ProductInvoice pi, Employee e, Customer cu
WHERE pi.ProdId = p.ProdId AND
	pi.CustId = cu.CustId AND
      pi.EmpId = e.EmpId AND
	p.ClassId = c.ClassId;