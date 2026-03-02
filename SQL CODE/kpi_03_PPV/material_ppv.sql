SELECT
  m.material_id,
  m.part_number,
  m.description,
  ROUND(SUM((pl.unit_price - pl.standard_cost) * gr.quantity_received), 2) AS total_ppv,
  COUNT(*) AS txn_count
FROM purchase_orders po
JOIN po_lines pl       ON pl.po_number = po.po_number
JOIN goods_receipts gr ON gr.po_line_id = pl.po_line_id
JOIN materials m       ON m.material_id = pl.material_id
GROUP BY m.material_id, m.part_number, m.description
ORDER BY total_ppv DESC;