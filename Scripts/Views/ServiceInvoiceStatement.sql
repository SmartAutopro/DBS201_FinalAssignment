CREATE VIEW ServiceInvoiceStatement AS
SELECT 	si.ServInvoiceId AS "Invoice#",
		    si.InvoiceDate AS "Invoice Date",
		    t.TeamId AS "Work Team",
        e.EquipDesc AS "Equip. Used",
        c.CustFirstNam || ' ' || c.CustLastNam AS "Customer",
        c.CustStreet || ' ' || c.CustRegion || ' ' || c.CustZip AS "Customer Address",
		    s.ServId AS "Service Code",
        s.ServDesc AS "Description",
        '$' || si.HourlyCharge AS "Hourly Charge",
        si.Hours AS "Work Duration (hours)",
        '$' || (si.HourlyCharge * si.Hours) AS "Total Charge"
FROM ServiceInvoice si, Customer c, Equipment e, Service s, Team t
WHERE si.ServId = s.ServId 	 AND
	    si.CustId = c.CustId 	 AND
      si.EquipUsedId = e.EquipUsedId AND
      si.TeamId = t.TeamId;