SELECT
    aging_bucket,
    exception_type,
    COUNT(*) AS receipt_count,
    ROUND(SUM(open_value), 2) AS total_value_stuck,
    ROUND(AVG(open_value), 2) AS avg_value_per_receipt
FROM (
    SELECT
        -- AS-OF date from dataset
        (SELECT MAX(gr_date) FROM goods_receipts) AS as_of_date,

        -- WHY it's unreconciled
        CASE
            WHEN il.gr_id IS NULL THEN 'No invoice'
            WHEN il.match_status = 'Partial' AND il.variance_reason IS NOT NULL
                THEN 'Partial - ' || il.variance_reason
            WHEN il.match_status = 'Partial' THEN 'Partial - Unspecified'
            ELSE 'Other'
        END AS exception_type,

        -- HOW LONG it's open (age) → bucketed
        CASE
            WHEN ((SELECT MAX(gr_date) FROM goods_receipts) - gr.gr_date) <= 15 THEN '0-15 days'
            WHEN ((SELECT MAX(gr_date) FROM goods_receipts) - gr.gr_date) <= 30 THEN '16-30 days'
            WHEN ((SELECT MAX(gr_date) FROM goods_receipts) - gr.gr_date) <= 60 THEN '31-60 days'
            ELSE '60+ days'
        END AS aging_bucket,

        -- Open value (more accurate for partial)
        CASE
            WHEN il.gr_id IS NULL THEN gr.quantity_received * pl.unit_price
            WHEN il.match_status = 'Partial'
                THEN GREATEST(gr.quantity_received - COALESCE(il.quantity_invoiced, 0), 0) * pl.unit_price
            ELSE 0
        END AS open_value

    FROM goods_receipts gr
    LEFT JOIN invoice_lines il ON gr.gr_id = il.gr_id
    JOIN po_lines pl ON gr.po_line_id = pl.po_line_id
    WHERE il.gr_id IS NULL OR il.match_status = 'Partial'
) x
GROUP BY aging_bucket, exception_type
ORDER BY
    CASE aging_bucket
        WHEN '0-15 days' THEN 1
        WHEN '16-30 days' THEN 2
        WHEN '31-60 days' THEN 3
        ELSE 4
    END,
    total_value_stuck DESC;