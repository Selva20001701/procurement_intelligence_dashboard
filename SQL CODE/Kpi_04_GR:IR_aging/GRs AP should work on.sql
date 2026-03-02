SELECT
    gr.gr_id,
    gr.po_line_id,
    gr.gr_date,
    ((SELECT MAX(gr_date) FROM goods_receipts) - gr.gr_date) AS days_open,
    gr.quantity_received,
    COALESCE(il.quantity_invoiced, 0) AS quantity_invoiced,
    il.match_status,
    il.variance_reason,
    CASE
        WHEN il.gr_id IS NULL THEN 'No invoice'
        WHEN il.match_status = 'Partial' AND il.variance_reason IS NOT NULL
            THEN 'Partial - ' || il.variance_reason
        WHEN il.match_status = 'Partial' THEN 'Partial - Unspecified'
        ELSE 'Other'
    END AS exception_type,
    pl.unit_price,
    ROUND(
        CASE
            WHEN il.gr_id IS NULL THEN gr.quantity_received * pl.unit_price
            WHEN il.match_status = 'Partial'
                THEN GREATEST(gr.quantity_received - COALESCE(il.quantity_invoiced, 0), 0) * pl.unit_price
            ELSE 0
        END
    , 2) AS open_value
FROM goods_receipts gr
LEFT JOIN invoice_lines il ON gr.gr_id = il.gr_id
JOIN po_lines pl ON gr.po_line_id = pl.po_line_id
WHERE (il.gr_id IS NULL OR il.match_status = 'Partial')
  AND ((SELECT MAX(gr_date) FROM goods_receipts) - gr.gr_date) > 30
ORDER BY open_value DESC, days_open DESC;