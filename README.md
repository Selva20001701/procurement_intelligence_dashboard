# NovaTech Electronics - Procurement Intelligence Dashboard

A complete end-to-end procurement analytics solution that transforms raw ERP data into actionable supply chain insights.

![Tableau Dashboard](link-to-your-dashboard-screenshot.png)

## 🎯 Business Problem

NovaTech Electronics, a mid-size U.S. contract electronics manufacturer, was facing three critical procurement challenges:

| Problem | Business Impact |
|---------|-----------------|
| Supplier lead time volatility | $2.3M tied up in excess safety stock |
| Purchase price variance leakage | $150K-200K annual overspend untracked |
| GR/IR reconciliation delays | $800K in unmatched items over 30 days |

Leadership needed data-driven answers: *Which suppliers are unreliable? Where is money leaking? What's stuck in reconciliation?*

## 💡 Solution

Built a procurement intelligence layer with 4 key performance indicators (KPIs):

### KPI 1: OTIF (On-Time In-Full)
Measures supplier delivery reliability by tracking what percentage of orders arrive on time and complete.

**Finding:** MLCC suppliers (Murata, Samsung, TDK) had OTIF below 60% — confirming the team's suspicion.

### KPI 2: Lead Time Variability
Calculates average lead time and standard deviation per supplier to identify inconsistent performers.

**Finding:** High standard deviation suppliers were causing planning uncertainty and safety stock buildup.

### KPI 3: Purchase Price Variance (PPV)
Compares actual price paid vs. standard cost, grouped by supplier, buyer, and material.

**Finding:** Identified specific buyers and materials driving the overspend.

### KPI 4: GR/IR Aging
Tracks unmatched goods receipts by aging buckets (0-15, 16-30, 31-60, 60+ days).

**Finding:** $421K stuck in 60+ day bucket — highest risk for duplicate payments.

## 🛠️ Tech Stack

| Layer | Tool |
|-------|------|
| Database | PostgreSQL |
| Data Modeling | SQL |
| Visualization | Tableau Public |
| Documentation | Notion, GitHub |

## 📁 Project Structure

```
├── /data
│   ├── suppliers.csv
│   ├── materials.csv
│   ├── buyers.csv
│   ├── purchase_orders.csv
│   ├── po_lines.csv
│   ├── goods_receipts.csv
│   ├── invoices.csv
│   └── invoice_lines.csv
├── /sql
│   ├── 01_create_tables.sql
│   ├── kpi_01_otif.sql
│   ├── kpi_02_lead_time.sql
│   ├── kpi_03_ppv_supplier.sql
│   ├── kpi_03_ppv_buyer.sql
│   ├── kpi_03_ppv_material.sql
│   └── kpi_04_grir_aging.sql
├── /results
│   ├── kpi_01_otif_results.csv
│   ├── kpi_02_lead_time_results.csv
│   ├── kpi_03_ppv_results.csv
│   └── kpi_04_grir_aging_results.csv
└── README.md
```

## 📊 Dashboard

**Live Dashboard:** [View on Tableau Public]([your-tableau-public-link-here](https://public.tableau.com/views/ProcurementIntelligenceDashboard/ProcurementExecutiveOverview?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link))

### Dashboard Features:
- Supplier OTIF ranking with performance tiers
- Lead time trend analysis with variance indicators
- PPV breakdown by supplier, buyer, and material
- GR/IR aging buckets with value at risk

## 🗄️ Data Model

```
suppliers → purchase_orders → po_lines → goods_receipts
                 ↓                            ↓
              buyers                    invoice_lines
                                             ↓
                                         invoices
            po_lines → materials
```

**8 interconnected tables** simulating a real ERP procurement module.

## 🔑 Key SQL Concepts Used

- JOINs (INNER, LEFT) across multiple tables
- Aggregate functions (COUNT, SUM, AVG, STDDEV)
- CASE statements for conditional logic
- Subqueries for complex calculations
- GROUP BY with HAVING clauses
- Date arithmetic for aging calculations

## 📈 Business Impact

With this dashboard, procurement leadership can now:

1. **Prioritize supplier conversations** — Focus on low-OTIF suppliers first
2. **Reduce safety stock** — Trust reliable suppliers, free up working capital
3. **Stop price leakage** — Hold buyers accountable for PPV
4. **Accelerate reconciliation** — Clear aging items before they become payment risks

## 🚀 How to Run

### Prerequisites
- PostgreSQL installed
- pgAdmin (or any SQL client)
- Tableau Public (free)

### Steps
1. Clone this repository
2. Run `01_create_tables.sql` in PostgreSQL
3. Import CSV files from `/data` folder into tables
4. Run KPI queries from `/sql` folder
5. Open Tableau and connect to result CSVs
6. Build visualizations

## 👤 Author

**Selvanagendran Rathinam**

- LinkedIn: https://www.linkedin.com/in/selvanagendran/
- Tableau Public: https://public.tableau.com/app/profile/selvanagendran.rathinam/vizzes
- Email: selvanagendran17@gmail.com

## 📝 License

This project is for educational and portfolio purposes.

---

*Built as part of my journey into Supply Chain Technology & Analytics*
