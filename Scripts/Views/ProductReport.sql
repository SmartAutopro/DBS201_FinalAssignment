CREATE VIEW ProductReport AS
SELECT c.ClassInitials AS "Product Class",
	   c.ClassDesc AS "Classification",
       p.ProdId AS "Product Id",
       p.ProdDesc AS "Description",
       '$' || p.UnitPrice AS "Cost",
       p.Markup || '%' AS "Markup",
       '$' || (p.UnitPrice * (p.Markup / 100)) AS "Charge"
FROM Product p, Class c
WHERE p.ClassId = c.ClassId;