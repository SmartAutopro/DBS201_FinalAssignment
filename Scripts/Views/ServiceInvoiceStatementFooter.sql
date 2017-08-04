CREATE VIEW ServiceInvoiceStatementFooter AS
SELECT '$' || SUM((si.HourlyCharge * Hours)) AS "Subtotal",
	   '$' || SUM((si.HourlyCharge * Hours) * 0.07) AS "GST (7%)",
       '$' || SUM((si.HourlyCharge * Hours) * 0.08) AS "PST (8%)",
       '$' || SUM((si.HourlyCharge * Hours + (si.HourlyCharge * Hours) * 0.08) + (si.HourlyCharge * Hours) * 0.07) AS "Total Due"
FROM ServiceInvoice si, Customer c
WHERE si.CustId = c.CustId;