/*************************************************************************/
/*                                                                       */
/*                       (c) 2010-2023 Enginatics GmbH                   */
/*                              www.enginatics.com                       */
/*                                                                       */
/*************************************************************************/
-- Report Name: GL Trial Balance - Detail
-- Description: Imported from Concurrent Program
Description: Detail Trial Balance (XML)
Application: General Ledger
Source: Trial Balance - Detail (XML)
Short Name: GLTRBALD
DB package:
-- Excel Examle Output: https://www.enginatics.com/example/gl-trial-balance-detail/
-- Library Link: https://www.enginatics.com/reports/gl-trial-balance-detail/
-- Run Report: https://demo.enginatics.com/

select
tb.*
from
(
select /*+ opt_param('_nlj_batching_enabled', 0) no_nlj_prefetch(b) */ 
 max(lr.target_ledger_name) ledger_name,
 max(glb.currency_code) currency_code,
 &lp_pivot_segment_name pivot_segment,
 max(fnd_flex_xml_publisher_apis.process_kff_combination_1('acct_flex_cost_seg', 'SQLGL', 'GL#', glcc.chart_of_accounts_id, null, glcc.code_combination_id, :p_pagebreak_seg_num, 'Y', 'VALUE')) pivot_segment_value,
 max(fnd_flex_xml_publisher_apis.process_kff_combination_1('acct_flex_cost_seg', 'SQLGL', 'GL#', glcc.chart_of_accounts_id, null, glcc.code_combination_id, :p_pagebreak_seg_num, 'Y', 'DESCRIPTION')) pivot_segment_desc,
 max(fnd_flex_xml_publisher_apis.process_kff_combination_1('acct_flex_cost_seg', 'SQLGL', 'GL#', glcc.chart_of_accounts_id, null, glcc.code_combination_id, 'GL_ACCOUNT', 'Y', 'VALUE')) account_segment,
 max(fnd_flex_xml_publisher_apis.process_kff_combination_1('acct_flex_cost_seg', 'SQLGL', 'GL#', glcc.chart_of_accounts_id, null, glcc.code_combination_id, 'GL_ACCOUNT', 'Y', 'DESCRIPTION')) account_segment_desc,
 max(fnd_flex_xml_publisher_apis.process_kff_combination_1('acct_flex_cost_seg', 'SQLGL', 'GL#', glcc.chart_of_accounts_id, null, glcc.code_combination_id, 'ALL', 'Y', 'VALUE')) account,
 decode(:p_type,'PTD', sum(decode (:p_currency_type, 'T', nvl (begin_balance_dr, 0), 'S', nvl (begin_balance_dr, 0), 'E',decode (glb.translated_flag,'R', nvl (begin_balance_dr, 0), nvl (begin_balance_dr_beq, 0)), 'C', nvl (begin_balance_dr_beq, 0))), 'PJTD', decode (:p_currency_type, 'T', 0, 'S', 0, 'E', 0, 'C', 0), 'YTD', decode (:p_currency_type,'T', sum (decode(glb.period_name,:p_first_period_name,(nvl(begin_balance_dr,0)),0)), 'S', sum (decode(glb.period_name,:p_first_period_name,(nvl(begin_balance_dr,0)),0)), 'E', sum(decode (glb.translated_flag,'R', decode(glb.period_name,:p_first_period_name, nvl(begin_balance_dr,0),0), decode(glb.period_name,:p_first_period_name, nvl(begin_balance_dr_beq,0),0))), 'C', sum (decode (glb.period_name,:p_first_period_name, (nvl(begin_balance_dr_beq,0)),0)))) begin_balance_dr,
 decode(:p_type,'PTD', sum(decode (:p_currency_type, 'T', nvl (begin_balance_cr, 0), 'S', nvl (begin_balance_cr, 0), 'E',decode (glb.translated_flag,'R', nvl (begin_balance_cr, 0), nvl (begin_balance_cr_beq, 0)), 'C', nvl (begin_balance_cr_beq, 0))), 'PJTD', decode (:p_currency_type, 'T', 0, 'S', 0, 'E', 0, 'C', 0), 'YTD', decode (:p_currency_type,'T', sum (decode(glb.period_name,:p_first_period_name,(nvl(begin_balance_cr,0)),0)), 'S', sum (decode(glb.period_name,:p_first_period_name,(nvl(begin_balance_cr,0)),0)), 'E', sum(decode (glb.translated_flag,'R', decode(glb.period_name,:p_first_period_name, nvl(begin_balance_cr,0),0), decode(glb.period_name,:p_first_period_name, nvl(begin_balance_cr_beq,0),0))), 'C', sum (decode (glb.period_name,:p_first_period_name, (nvl(begin_balance_cr_beq,0)),0))))begin_balance_cr,
 decode(:p_type,'PTD', sum(decode (:p_currency_type, 'T', nvl (begin_balance_dr, 0)- nvl(begin_balance_cr,0), 'S', nvl (begin_balance_dr, 0)- nvl (begin_balance_cr, 0), 'E',decode (glb.translated_flag,'R', nvl (begin_balance_dr, 0)- nvl (begin_balance_cr, 0), nvl (begin_balance_dr_beq, 0)- nvl (begin_balance_cr_beq, 0)), 'C', nvl (begin_balance_dr_beq, 0)- nvl(begin_balance_cr_beq,0))), 'PJTD', decode (:p_currency_type, 'T', 0, 'S', 0, 'E', 0, 'C', 0), 'YTD', decode(:p_currency_type, 'T',sum(decode(glb.period_name, :p_first_period_name, (nvl(begin_balance_dr,0) - nvl(begin_balance_cr,0)),0)), 'S', sum(decode(glb.period_name, :p_first_period_name, (nvl(begin_balance_dr,0) - nvl(begin_balance_cr,0)),0)), 'E', sum(decode(glb.translated_flag, 'R', decode(glb.period_name, :p_first_period_name, nvl(begin_balance_dr,0) - nvl(begin_balance_cr,0),0), decode(glb.period_name, :p_first_period_name, nvl(begin_balance_dr_beq,0)- nvl(begin_balance_cr_beq,0),0))), 'C', sum (decode (glb.period_name,:p_first_period_name, (nvl(begin_balance_dr_beq,0)- nvl(begin_balance_cr_beq,0)),0)))) begin_balance,
 decode(:p_type, 'PTD', sum(decode(:p_currency_type, 'T', nvl(period_net_dr,0), 'S', nvl(period_net_dr,0), 'E', decode(glb.translated_flag, 'R', nvl(period_net_dr,0),nvl(period_net_dr_beq,0)), 'C', nvl(period_net_dr_beq,0))), 'PJTD', sum(decode(:p_currency_type, 'T', nvl(project_to_date_dr,0) + nvl(period_net_dr,0), 'S', nvl(project_to_date_dr,0) + nvl(period_net_dr,0), 'E', decode(glb.translated_flag, 'R', nvl(project_to_date_dr,0) + nvl(period_net_dr,0), nvl(project_to_date_dr_beq,0) + nvl(period_net_dr_beq,0)), 'C', nvl(project_to_date_dr_beq,0) + nvl(period_net_dr_beq,0))), 'YTD', decode(:p_currency_type, 'T',sum(decode(glb.period_name, :p_period_name, nvl(period_net_dr,0) + nvl(begin_balance_dr,0),0) - decode(glb.period_name, :p_first_period_name, nvl(begin_balance_dr,0),0)), 'S', sum(decode(glb.period_name, :p_period_name, nvl(period_net_dr,0) + nvl(begin_balance_dr,0),0) -decode(glb.period_name, :p_first_period_name, nvl(begin_balance_dr,0),0)), 'E', sum(decode(glb.translated_flag, 'R', decode(glb.period_name, :p_period_name, nvl(period_net_dr,0)+ nvl(begin_balance_dr,0),0) -decode(glb.period_name, :p_first_period_name, nvl(begin_balance_dr,0),0), decode(glb.period_name, :p_period_name, nvl(period_net_dr_beq,0)+nvl(begin_balance_dr_beq,0),0) -decode(glb.period_name, :p_first_period_name,nvl(begin_balance_dr_beq,0),0))), 'C', sum(decode(glb.period_name, :p_period_name, nvl(period_net_dr_beq,0) + nvl(begin_balance_dr_beq,0),0) - decode(glb.period_name, :p_first_period_name, nvl(begin_balance_dr_beq,0),0)))) period_dr,
 decode(:p_type, 'PTD', sum(decode(:p_currency_type, 'T', nvl(period_net_cr,0), 'S', nvl(period_net_cr,0), 'E', decode(glb.translated_flag, 'R', nvl(period_net_cr,0),nvl(period_net_cr_beq,0)), 'C', nvl(period_net_cr_beq,0))), 'PJTD', sum(decode(:p_currency_type, 'T', nvl(project_to_date_cr,0) + nvl(period_net_cr,0), 'S', nvl(project_to_date_cr,0) + nvl(period_net_cr,0), 'E', decode(glb.translated_flag, 'R', nvl(project_to_date_cr,0) + nvl(period_net_cr,0), nvl(project_to_date_cr_beq,0) + nvl(period_net_cr_beq,0)), 'C', nvl(project_to_date_cr_beq,0) + nvl(period_net_cr_beq,0))), 'YTD', decode(:p_currency_type, 'T',sum(decode(glb.period_name, :p_period_name, nvl(period_net_cr,0) + nvl(begin_balance_cr,0),0) - decode(glb.period_name, :p_first_period_name, nvl(begin_balance_cr,0),0)), 'S', sum(decode(glb.period_name, :p_period_name, nvl(period_net_cr,0) + nvl(begin_balance_cr,0),0) -decode(glb.period_name, :p_first_period_name, nvl(begin_balance_cr,0),0)), 'E', sum(decode(glb.translated_flag, 'R', decode(glb.period_name, :p_period_name, nvl(period_net_cr,0)+ nvl(begin_balance_cr,0),0) -decode(glb.period_name, :p_first_period_name, nvl(begin_balance_cr,0),0), decode(glb.period_name, :p_period_name, nvl(period_net_cr_beq,0)+nvl(begin_balance_cr_beq,0),0) -decode(glb.period_name, :p_first_period_name,nvl(begin_balance_cr_beq,0),0))), 'C', sum(decode(glb.period_name, :p_period_name, nvl(period_net_cr_beq,0) + nvl(begin_balance_cr_beq,0),0) - decode(glb.period_name, :p_first_period_name, nvl(begin_balance_cr_beq,0),0)))) period_cr,
 decode(:p_type,'PTD', sum (decode (:p_currency_type,'T', nvl (period_net_dr, 0)- nvl (period_net_cr, 0), 'S', nvl (period_net_dr, 0)- nvl (period_net_cr, 0), 'E', decode (glb.translated_flag,'R', nvl (period_net_dr, 0)- nvl (period_net_cr, 0), nvl (period_net_dr_beq, 0)- nvl (period_net_cr_beq, 0)), 'C', nvl (period_net_dr_beq, 0)- nvl (period_net_cr_beq, 0))), 'PJTD', sum (decode (:p_currency_type,'T', nvl (project_to_date_dr, 0)+ nvl (period_net_dr, 0) - nvl (project_to_date_cr, 0)- nvl (period_net_cr, 0), 'S', nvl (project_to_date_dr, 0)+ nvl (period_net_dr, 0) - nvl (project_to_date_cr, 0)- nvl (period_net_cr, 0), 'E', decode (glb.translated_flag,'R', nvl (project_to_date_dr, 0)+ nvl (period_net_dr, 0) - nvl (project_to_date_cr, 0)- nvl (period_net_cr, 0), nvl (project_to_date_dr_beq, 0)+ nvl (period_net_dr_beq, 0) - nvl (project_to_date_cr_beq, 0)- nvl (period_net_cr_beq, 0)), 'C', nvl (project_to_date_dr_beq, 0)+ nvl (period_net_dr_beq, 0)- nvl (project_to_date_cr_beq, 0) - nvl (period_net_cr_beq, 0))), 'YTD', decode (:p_currency_type,'T', sum ( decode (glb.period_name,:p_period_name, nvl(period_net_dr,0)- nvl (period_net_cr, 0)+ nvl (begin_balance_dr, 0)- nvl (begin_balance_cr, 0),0) - decode (glb.period_name,:p_first_period_name, nvl(begin_balance_dr,0)- nvl (begin_balance_cr, 0),0)), 'S', sum ( decode (glb.period_name,:p_period_name, nvl(period_net_dr,0) - nvl (period_net_cr, 0) + nvl (begin_balance_dr, 0)- nvl (begin_balance_cr, 0),0) - decode (glb.period_name,:p_first_period_name, nvl(begin_balance_dr,0)- nvl (begin_balance_cr, 0),0)), 'E', sum(decode (glb.translated_flag,'R', decode (glb.period_name,:p_period_name, nvl(period_net_dr,0) - nvl (period_net_cr,0)+ nvl(begin_balance_dr,0)- nvl(begin_balance_cr,0),0) - decode (glb.period_name,:p_first_period_name, nvl(begin_balance_dr,0)- nvl (begin_balance_cr,0),0), decode(glb.period_name,:p_period_name, nvl(period_net_dr_beq,0)- nvl (period_net_cr_beq,0) + nvl(begin_balance_dr_beq,0) - nvl(begin_balance_cr_beq, 0),0) - decode (glb.period_name,:p_first_period_name, nvl(begin_balance_dr_beq,0)- nvl(begin_balance_cr_beq,0 ), 0))), 'C', sum ( decode (glb.period_name,:p_period_name, nvl(period_net_dr_beq,0)- nvl (period_net_cr_beq, 0)+ nvl (begin_balance_dr_beq, 0) - nvl (begin_balance_cr_beq, 0),0)- decode (glb.period_name, :p_first_period_name, nvl(begin_balance_dr_beq, 0)- nvl (begin_balance_cr_beq, 0),0)))) period_net,
 decode(:p_type, 'PTD', sum(decode(:p_currency_type, 'T', nvl(begin_balance_dr,0)+ nvl(period_net_dr,0), 'S', nvl(begin_balance_dr,0) + nvl(period_net_dr,0), 'E',decode(glb.translated_flag, 'R', nvl(begin_balance_dr,0)+ nvl(period_net_dr, 0),nvl(begin_balance_dr_beq,0) + nvl(period_net_dr_beq,0)), 'C', nvl(begin_balance_dr_beq,0) + nvl(period_net_dr_beq,0))), 'PJTD', sum(decode(:p_currency_type,'T', nvl(project_to_date_dr,0) + nvl(period_net_dr,0), 'S', nvl(project_to_date_dr,0) + nvl(period_net_dr,0), 'E', decode(glb.translated_flag, 'R', nvl(project_to_date_dr,0)+ nvl(period_net_dr,0) ,nvl(project_to_date_dr_beq,0) + nvl(period_net_dr_beq,0)), 'C', nvl(project_to_date_dr_beq,0) + nvl(period_net_dr_beq,0))), 'YTD', decode(:p_currency_type, 'T',sum(decode(glb.period_name, :p_period_name, nvl(period_net_dr,0)+nvl(begin_balance_dr,0),0)), 'S', sum(decode(glb.period_name, :p_period_name, nvl(period_net_dr,0)+ nvl(begin_balance_dr,0),0)), 'E', sum(decode(glb.translated_flag, 'R', decode(glb.period_name, :p_period_name, nvl(period_net_dr,0)+ nvl(begin_balance_dr,0),0),decode(glb.period_name, :p_period_name, nvl(period_net_dr_beq,0)+ nvl(begin_balance_dr_beq,0),0))), 'C', sum(decode(glb.period_name, :p_period_name, nvl(period_net_dr_beq,0) + nvl(begin_balance_dr_beq,0),0)))) end_balance_dr,
 decode(:p_type, 'PTD', sum(decode(:p_currency_type, 'T', nvl(begin_balance_cr,0)+ nvl(period_net_cr,0), 'S', nvl(begin_balance_cr,0) + nvl(period_net_cr,0), 'E',decode(glb.translated_flag, 'R', nvl(begin_balance_cr,0)+ nvl(period_net_cr, 0),nvl(begin_balance_cr_beq,0) + nvl(period_net_cr_beq,0)), 'C', nvl(begin_balance_cr_beq,0) + nvl(period_net_cr_beq,0))), 'PJTD', sum(decode(:p_currency_type,'T', nvl(project_to_date_cr,0) + nvl(period_net_cr,0), 'S', nvl(project_to_date_cr,0) + nvl(period_net_cr,0), 'E', decode(glb.translated_flag, 'R', nvl(project_to_date_cr,0)+ nvl(period_net_cr,0) ,nvl(project_to_date_cr_beq,0) + nvl(period_net_cr_beq,0)), 'C', nvl(project_to_date_cr_beq,0) + nvl(period_net_cr_beq,0))), 'YTD', decode(:p_currency_type, 'T',sum(decode(glb.period_name, :p_period_name, nvl(period_net_cr,0)+nvl(begin_balance_cr,0),0)), 'S', sum(decode(glb.period_name, :p_period_name, nvl(period_net_cr,0)+ nvl(begin_balance_cr,0),0)), 'E', sum(decode(glb.translated_flag, 'R', decode(glb.period_name, :p_period_name, nvl(period_net_cr,0)+ nvl(begin_balance_cr,0),0),decode(glb.period_name, :p_period_name, nvl(period_net_cr_beq,0)+ nvl(begin_balance_cr_beq,0),0))), 'C', sum(decode(glb.period_name, :p_period_name, nvl(period_net_cr_beq,0) + nvl(begin_balance_cr_beq,0),0)))) end_balance_cr,
 decode(:p_type,'PTD', sum (decode (:p_currency_type,'T', nvl (begin_balance_dr, 0)+ nvl (period_net_dr, 0)- nvl (begin_balance_cr, 0) - nvl (period_net_cr, 0), 'S', nvl (begin_balance_dr, 0)+ nvl (period_net_dr, 0) - nvl (begin_balance_cr, 0) - nvl (period_net_cr, 0),'E', decode (glb.translated_flag, 'R', nvl (begin_balance_dr, 0) + nvl (period_net_dr, 0)- nvl (begin_balance_cr, 0) - nvl (period_net_cr, 0),nvl (begin_balance_dr_beq, 0) + nvl (period_net_dr_beq, 0)- nvl (begin_balance_cr_beq, 0) - nvl (period_net_cr_beq, 0) ), 'C', nvl (begin_balance_dr_beq, 0)+ nvl (period_net_dr_beq, 0)- nvl (begin_balance_cr_beq, 0) - nvl (period_net_cr_beq, 0))),'PJTD', sum (decode (:p_currency_type, 'T', nvl (project_to_date_dr, 0)+ nvl (period_net_dr, 0) - nvl (project_to_date_cr, 0) - nvl (period_net_cr, 0), 'S', nvl (project_to_date_dr, 0) + nvl (period_net_dr, 0) - nvl (project_to_date_cr, 0) - nvl (period_net_cr, 0), 'E', decode (glb.translated_flag,'R', nvl (project_to_date_dr, 0) + nvl (period_net_dr, 0)- nvl (project_to_date_cr, 0) - nvl (period_net_cr, 0), nvl (project_to_date_dr_beq, 0) + nvl (period_net_dr_beq, 0) - nvl (project_to_date_cr_beq, 0) - nvl (period_net_cr_beq, 0) ), 'C', nvl (project_to_date_dr_beq, 0) + nvl (period_net_dr_beq, 0) - nvl (project_to_date_cr_beq, 0) - nvl (period_net_cr_beq, 0)) ), 'YTD', decode (:p_currency_type,'T', sum (decode (glb.period_name, :p_period_name, nvl(period_net_dr,0 ) - nvl (period_net_cr, 0) + nvl (begin_balance_dr, 0) - nvl (begin_balance_cr, 0), 0)), 'S', sum (decode (glb.period_name, :p_period_name, nvl (period_net_dr,0)- nvl (period_net_cr, 0) + nvl (begin_balance_dr, 0)- nvl (begin_balance_cr, 0),0)), 'E', sum (decode (glb.translated_flag, 'R', decode(glb.period_name, :p_period_name, nvl(period_net_dr,0)- nvl (period_net_cr, 0)+ nvl (begin_balance_dr, 0) - nvl(begin_balance_cr, 0 ), 0 ), decode (glb.period_name, :p_period_name, nvl(period_net_dr_beq, 0 ) - nvl (period_net_cr_beq, 0)+ nvl(begin_balance_dr_beq, 0)- nvl (begin_balance_cr_beq,0), 0) ) ),'C', sum (decode (glb.period_name,:p_period_name, nvl(period_net_dr_beq, 0) - nvl (period_net_cr_beq, 0) + nvl (begin_balance_dr_beq, 0) - nvl (begin_balance_cr_beq, 0),0)))) end_balance
from 
 gl_balances glb,
 gl_code_combinations glcc,
 gl_ledgers gll,
 gl_ledger_set_assignments asg,
 gl_ledger_relationships lr
where
     1=1
 and :p_access_set_id = :p_access_set_id
 and :p_chart_of_accounts_id = :p_chart_of_accounts_id
 and :p_ledger_name = :p_ledger_name
 and nvl(:p_entered_currency,'?') = nvl(:p_entered_currency,'?')
 and glb.actual_flag = 'A'
 and glb.period_name in (:p_period_name, decode(:p_type, 'PTD', :p_period_name, 'PJTD', :p_period_name, 'YTD', :p_first_period_name))
 and glb.code_combination_id = glcc.code_combination_id
 and glcc.chart_of_accounts_id = :p_chart_of_accounts_id
 and glcc.summary_flag = 'N'
 and glcc.template_id is null
 and gll.ledger_id = :p_ledger_id
 and asg.ledger_set_id(+) = gll.ledger_id
 and lr.target_ledger_id = nvl(asg.ledger_id, gll.ledger_id)
 and lr.source_ledger_id = nvl(asg.ledger_id, gll.ledger_id)
 and lr.target_currency_code = :p_ledger_currency
 and lr.source_ledger_id = glb.ledger_id
 and lr.target_ledger_id = glb.ledger_id
group by
 fnd_flex_xml_publisher_apis.process_kff_combination_1('acct_flex_cost_seg', 'SQLGL', 'GL#', glcc.chart_of_accounts_id, null, glcc.code_combination_id, 'ALL', 'Y', 'VALUE'),
 glb.ledger_id,
 glb.currency_code
) tb
where
 (nvl(tb.begin_balance,0) != 0 or nvl(tb.period_net,0) != 0 or nvl(tb.end_balance,0) != 0)
order by
 tb.ledger_name,
 tb.currency_code,
 tb.pivot_segment,
 tb.currency_code,
 tb.account_segment,
 tb.account