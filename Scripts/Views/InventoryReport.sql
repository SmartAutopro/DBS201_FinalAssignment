CREATE VIEW InventoryReport AS
SELECT i.ProdId AS "Product Id",
	   p.ProdDesc AS "Description",
       i.InvQuantity AS "Inventory",
       i.AisleId AS "Aisle#",
       s.SupDesc AS "Supplier"
FROM Product p, Inventory i, Supplier s
WHERE i.ProdId = p.ProdId AND
	  i.SupId = s.SupId;