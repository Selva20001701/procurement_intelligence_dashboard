SELECT 
    supplier_id,
    supplier_name,
    total_deliveries,
    failed_deliveries,
    ROUND((total_deliveries - failed_deliveries) * 100.0 / total_deliveries, 2) AS otif_percentage
FROM (
    SELECT 
        suppliers.supplier_name,
        purchase_orders.supplier_id,
        COUNT(*) AS total_deliveries,
        COUNT(CASE 
            WHEN goods_receipts.quantity_received < po_lines.quantity_ordered 
              OR goods_receipts.gr_date > po_lines.requested_delivery_date 
            THEN 1 
        END) AS failed_deliveries
    FROM suppliers
    JOIN purchase_orders ON suppliers.supplier_id = purchase_orders.supplier_id
    JOIN po_lines ON purchase_orders.po_number = po_lines.po_number
    JOIN goods_receipts ON po_lines.po_line_id = goods_receipts.po_line_id
    GROUP BY purchase_orders.supplier_id, suppliers.supplier_name
) AS supplier_stats
ORDER BY otif_percentage ASC