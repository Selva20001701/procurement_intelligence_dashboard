SELECT 
    supplier_id,
    supplier_name,
    material_id,
    part_number,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time,
    ROUND(STDDEV(lead_time_days), 2) AS lead_time_stddev
FROM (
    SELECT 
        suppliers.supplier_id,
        suppliers.supplier_name,
        materials.material_id,
        materials.part_number,
        goods_receipts.gr_date - purchase_orders.po_date AS lead_time_days
    FROM suppliers   
    JOIN purchase_orders ON suppliers.supplier_id = purchase_orders.supplier_id  
    JOIN po_lines ON purchase_orders.po_number = po_lines.po_number 
    JOIN goods_receipts ON po_lines.po_line_id = goods_receipts.po_line_id
    JOIN materials ON po_lines.material_id = materials.material_id
) AS lead_times
GROUP BY supplier_id, supplier_name, material_id, part_number
ORDER BY supplier_name, lead_time_stddev DESC




