SELECT
  b.buyer_id,
  b.buyer_name,
  ROUND(SUM((pl.unit_price - pl.standard_cost) * gr.quantity_received), 2) AS total_ppv,
  COUNT(*) AS txn_count
FROM purchase_orders po
JOIN buyers b          ON b.buyer_id = po.buyer_id
JOIN po_lines pl       ON pl.po_number = po.po_number
JOIN goods_receipts gr ON gr.po_line_id = pl.po_line_id
GROUP BY b.buyer_id, b.buyer_name
ORDER BY total_ppv DESC;