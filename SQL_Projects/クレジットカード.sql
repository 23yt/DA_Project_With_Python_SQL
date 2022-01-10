#exploring all the tables and variables in each table and counting

select * from base;
select * from call_record;
select * from change_record;
select * from decision;
select * from letter;
select count(*) from base;
select count(*) from call_record;
select count(*) from decision;
select count(*) from letter;
select count(*) from change_record;

#checking the number of calls for each days

select call_date, count(acct_num) from call_record group by 1;

#checking how many approvals and how many declines

select decision_status, count(*) from decision group by 1;

#how many changes made on each days

select change_date, count(*) from change_record group by 1;

#check how many people called on each days

select count(acct_num) from call_record;
select count(distinct acct_num) from call_record;
select call_date, count(acct_num) as num_of_calls from call_record group by 1 order by 1;

#finding out the approve rate and decline rate by creating segmentation

select 
sum(case when decision_status = 'AP' then 1 else 0 end) / count(acct_decision_id) as approval_rate,
sum(case when decision_status = 'DL' then 1 else 0 end) / count(acct_decision_id) as decline_rate
from decision;

#check whether the credit limit has been changed correctly for those approved account

select * from
(select base.acct_num, base.credit_limit, base.offer_amount, d.decision_status,
c.credit_limit_after, base.credit_limit + base.offer_amount - c.credit_limit_after as match_num
from base left join decision as d on base.acct_num = d.acct_decision_id
left join change_record as c on base.acct_num = c.account_number where d.decision_status = 'AP') as a
where a.match_num <> 0;

#checking whether each letter has been sent out (letter has been senting out if letter_trigger_date >= decision date)

select * from (select base.acct_num, d.decision_status, d.decision_date, l.letter_code, 
l.Letter_trigger_date, datediff(decision_date, Letter_trigger_date) as date_diff
from base left join decision as d on base.acct_num = d.acct_decision_id left join letter as l
on base.acct_num = l.account_number where decision_status is not null) as a
where letter_mis > 0 or letter_trigger_date is null;

#letter monitoring for code
SELECT * FROM
(select base.acct_num as acct_num, base.offer_amount, d.decision_status, d.decision_date,
l.language, l.letter_code,
case when decision_status='DL' and language='French' then 'RE002'
	 WHEN decision_status='AP' and language='French' then 'AE002'
     WHEN decision_status='DL' and language='English' then 'RE001'
     WHEN decision_status='AP' and language='English' then 'AE001'
     END AS letter_code2
from
base
left join
decision d
on base.acct_num=d.acct_decision_id
left join
letter l
on 
base.acct_num=l.account_number
where decision_status is not null) A
WHERE A.letter_code <> A.letter_code2;


#final monitoring
select base.acct_num,
base.credit_limit,
base.offer_amount,
d.decision_status,
d.decision_date,
l.Letter_trigger_date, 
l.letter_code,
l.language,
c.credit_limit_after, 
case when decision_status='AP' and
base.credit_limit+base.offer_amount-credit_limit_after <> 0 then 1
else 0 end as mismatch_flag,
case when datediff(decision_date,Letter_trigger_date) > 0 then 1 else 0 end as missing_letter_flag,
case when decision_status='DL' and language='French' and l.letter_code <> 'RE002' then 1
	 WHEN decision_status='AP' and language='French' and l.letter_code <> 'AE002' then 1 
     WHEN decision_status='DL' and language='English' and l.letter_code <> 'RE001' then 1
     WHEN decision_status='AP' and language='English' and l.letter_code <> 'AE001' then 1
     ELSE 0
     END AS wrong_letter_flag 
from
base
left join
decision d
on base.acct_num=d.acct_decision_id
left join
change_record c
on
base.acct_num=c.account_number
left join
letter l
on 
base.acct_num=l.account_number
where decision_status is not null;

