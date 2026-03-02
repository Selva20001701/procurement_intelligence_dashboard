SELECT 
    CASE 
        WHEN DATE '2023-04-30' - goods_receipts.gr_date <= 15 THEN '0-15 days'
        WHEN DATE '2023-04-30' - goods_receipts.gr_date <= 30 THEN '16-30 days'
        WHEN DATE '2023-04-30' - goods_receipts.gr_date <= 60 THEN '31-60 days'
        ELSE '60+ days'
    END AS aging_bucket,
    COUNT(*) AS receipt_count,
    ROUND(SUM(goods_receipts.quantity_received * po_lines.unit_price), 2) AS total_value_stuck
FROM goods_receipts
LEFT JOIN invoice_lines ON goods_receipts.gr_id = invoice_lines.gr_id
JOIN po_lines ON goods_receipts.po_line_id = po_lines.po_line_id
WHERE invoice_lines.gr_id IS NULL 
   OR invoice_lines.match_status = 'Partial'
GROUP BY aging_bucket
ORDER BY aging_bucket