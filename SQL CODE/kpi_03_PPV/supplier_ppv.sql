SELECT
  s.supplier_id,
  s.supplier_name,
  ROUND(SUM((pl.unit_price - pl.standard_cost) * gr.quantity_received), 2) AS total_ppv,
  COUNT(*) AS txn_count
FROM suppliers s
JOIN purchase_orders po ON po.supplier_id = s.supplier_id
JOIN buyers b          ON b.buyer_id = po.buyer_id
JOIN po_lines pl       ON pl.po_number = po.po_number
JOIN goods_receipts gr ON gr.po_line_id = pl.po_line_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_ppv DESC;