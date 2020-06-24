select ms.financial_calendar_reporting_year as f_year
        , ms.financial_calendar_reporting_quarter as f_qtr
        , ms.product_merch_classification1 as merch_class1
        , sum(ms.gross_sales) as gross_sales -- do we use gross or merch? what is the difference?
        , sum(ms.total_discounts) as total_discounts_given
        , sum(ms.refunds) as total_refunds_given
        , sum(ms.net_sales) as net_sales
        , sum(ms.product_cost) as COGS
        , sum(ms.product_margin) as gross_margin --Sales - COGS -- Product margin is really Gross Margin but is labeled incorrectly
        , sum(ms.total_freight_and_supplies) as total_freight_cost
        , sum(ms.gross_margin) as net_profit_margin --Sales - COGS - (all other costs) --This is really Net Profit Margin as it takes into account all Costs like shipping cost; not just COGS
        , sum(ms.units_shipped) as total_units
       -- , sum(ms.gross_sales - (abs(ms.total_discounts) + abs(ms.refunds))) as calc_net_sales
        , (sum(ms.net_sales - abs(ms.product_cost)) / sum(ms.net_sales)) * 100 as calc_gross_margin_perc
        , (sum(ms.net_sales - (abs(ms.product_cost) + abs(ms.total_freight_and_supplies))) / sum(ms.net_sales)) * 100 as calc_net_profit_margin_perc
        , avg((sum(ms.net_sales - (abs(ms.product_cost) + abs(ms.total_freight_and_supplies))) / sum(ms.net_sales)) * 100) OVER (Partition BY ms.financial_calendar_reporting_year, ms.financial_calendar_reporting_quarter ORDER BY ms.financial_calendar_reporting_year, ms.financial_calendar_reporting_quarter) as mean_quarter_profit_margin
from merch_performance_snapshot ms
WHERE ms.financial_calendar_reporting_year >= 2018 AND ms.product_merch_classification1 IS NOT NULL
GROUP BY 1,2,3
ORDER BY 1,2,4;