# Wotels - Multi-Property Reporting Platform

> Case study in progress. A Power BI platform unifying occupancy, financial actuals, and budgets across 18 properties and head office.

![Status](https://img.shields.io/badge/status-in%20progress-blue) ![Data](https://img.shields.io/badge/data-synthetic-lightgrey)

## Overview

Wotels runs 18 properties plus a head office overhead structure. This project unifies three previously disconnected systems into a single governed Power BI environment:

- Live occupancy from the **Mews API**
- Financial actuals from **Primavera ERP**, connected via SQL Server
- Budgets maintained in **Excel**

All data shown in this repository and the linked report is synthetic. No real guest, revenue, or financial data is included.

## The Challenge

- Occupancy lived only in Mews, disconnected from financial performance.
- Financial actuals lived only in Primavera, reachable only through a direct SQL connection not built for cross property analysis.
- Budgets lived only in Excel, with no shared structure across systems.

Every month end close meant reconciling exports from three systems by hand, with no automated variance or drill down.

## What This Project Delivers

- A star schema Power BI model joining occupancy, financial actuals, and budget data
- Custom Power Query (M) functions calling the Mews API directly
- A SQL Server connection pulling P&L actuals from Primavera
- DAX measures for Actual vs. Budget vs. Last Year, with YTD roll ups
- Row level security by property and department
- Five linked reports: a portfolio KPI dashboard, Units and Overhead P&L statements, variance drill downs, and executive summaries

## Data Model

Star schema with four fact tables and three dimension tables, joined through a standard date table.

```
                        DateTable
                            |
   +------------+-----------+-----------+------------+
   |            |                       |            |
Movimentos  OccupancyByPeriod         Budget      Statistics
   |            |                       |            |
   +-----+------+          +------------+------+
         |                 |                   |
       Units          Cost Centers            Beds
```

**Fact tables:** Movimentos (P&L ledger), OccupancyByPeriod, Budget, Statistics
**Dimension tables:** Units, Cost Centers, Beds, DateTable

## Tech Stack

| Layer | Tool |
|---|---|
| Reporting | Power BI |
| Ingestion | Power Query (M) |
| Business logic | DAX |
| Occupancy source | Mews API |
| Financial source | Primavera ERP (SQL Server) |
| Budget source | Excel |
| Access control | Row level security |

A single semantic model sits underneath all five reports. Power Query handles ingestion from the three source systems, DAX handles the variance and YTD logic, and row level security controls what each property manager or department head can see. The model is designed to extend as new reporting layers are added on top.

## KPI Coverage

The KPI slicer on the portfolio dashboard covers more than 30 metrics, including:

- **Headline figures:** GOP, GOP (2), EBITDA, EBT, Unit Margin
- **Occupancy metrics:** Occupancy Rate, Available Beds, Occupied Beds, Average Bed Rate
- **Department profit:** Rooms Profit, F&B Profit, OPC Profit
- **Per occupied bed cost ratios:** Cleaning/POB, Electricity/POB, Water/POB, Gas/POB, Laundry/POB, Food Cost, BEV Cost, CAC/POB, Amenities/POB

## Screenshots

| Report | Preview |
|---|---|
| KPI Dashboard | `assets/Wotels - portfolio file-1.png` |
| Units Summary | `assets/Wotels - portfolio file-6.png` |
| Overhead Summary | `assets/Wotels - portfolio file-7.png` |

Live version of these screenshots is embedded on the [case study page](https://ortensa-adhamidhi.github.io/portfolio/wotels.html) and in the accompanying [presentation deck](./Wotels_Case_Study.pptx).

## Repository Structure

```
wotels-case-study/
├── assets/
│   └── wotels/
│       ├── Wotels - portfolio file-1.png
│       ├── Wotels - portfolio file-2.png
│       ├── Wotels - portfolio file-3.png
│       ├── Wotels - portfolio file-4.png
│       ├── Wotels - portfolio file-5.png
│       ├── Wotels - portfolio file-6.png
│       └── Wotels - portfolio file-7.png
├── queries/
│       ├── Credentials.pq
│       ├── DateRanges.pq
│       ├── fnGetOccupancy.pq
│       ├── OccupancybyPeriod.pq
│       └── Properties.pq
├── Wotels_Case_Study.pptx
└── README.md
```

## Status

This case study is actively being built.

| Item | Status |
|---|---|
| Finance and budget reporting (this repo) | Live |
| Day to day operations report (stay, connect, and property benchmarking) | In development |
| Full write up | In development |

A second Power BI report is being added on top of the same semantic model, covering day to day stay and connect performance, property benchmarking, guest satisfaction, and pick up tracking.

## Privacy and Anonymization

This is a portfolio case study built from a real freelance engagement. To protect client confidentiality:

- All property names, brand names, and area manager names have been replaced with fictional equivalents.
- All financial figures, occupancy numbers, and guest data shown are synthetic.
- The Power BI file (`.pbix`) is not published publicly, but you can download it on this repository.

## Contact

**Ortensa Adhamidhi**
Senior Data Analyst & Analytics Engineer

- Email: oadhamidhi@gmail.com
- LinkedIn: [linkedin.com/in/ortensa-adhamidhi](https://linkedin.com/in/ortensa-adhamidhi)
