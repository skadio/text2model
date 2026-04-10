% Semicond production/financial planning for December 2002
% Maximize contribution to profit subject to cash and current-ratio constraints on Jan 1, 2003.

include "globals.mzn";

%--------------------------
% Embedded data (from text)
%--------------------------
int: labor_t = 50;
int: labor_r = 35;
int: raw_t   = 30;
int: raw_r   = 40;

int: price_t = 100;
int: price_r = 90;

int: max_raw_t = 100;   % enough raw material to manufacture
int: max_raw_r = 100;

int: cash0 = 10000;
int: ar0   = 3000;
int: inv0  = 7000;
int: loan0 = 10000;

int: ar_collected_dec = 2000;

int: loan_payment_dec = 1000;
int: rent_dec         = 1000;

int: raw_received_jan1_value = 2000;  % received Jan 1, payable Feb 1 (accounts payable increase)

int: min_cash_jan1 = 4000;
int: min_current_ratio_times100 = 200; % enforce 100*assets >= 200*liabilities (ratio >= 2)

%--------------------------
% Decision variables
%--------------------------
var 0..max_raw_t: xT;  % tape recorders produced in December
var 0..max_raw_r: xR;  % radios produced in December

%--------------------------
% Derived financials
%--------------------------
% Contribution margin (sales - variable manufacturing costs) for December production:
int: cm_t = price_t - labor_t - raw_t;  % 100 - 50 - 30 = 20
int: cm_r = price_r - labor_r - raw_r;  %  90 - 35 - 40 = 15
var int: profit = cm_t * xT + cm_r * xR;

% Cash on Jan 1, 2003:
% Starting cash + AR collected in Dec - Dec cash expenses (labor + rent + loan repayment)
% Note: all Dec sales are on credit; raw materials used are assumed paid for later (AP), consistent with statement.
var int: cash1 = cash0
              + ar_collected_dec
              - (labor_t * xT + labor_r * xR)
              - rent_dec
              - loan_payment_dec;

% Accounts receivable on Jan 1:
% Start AR - collected + new credit sales from Dec production
var int: ar1 = ar0 - ar_collected_dec + (price_t * xT + price_r * xR);

% Inventory on Jan 1:
% Start inventory + raw materials received on Jan 1 (value)
% (We assume all December production is sold, so no finished goods inventory is created.)
var int: inv1 = inv0 + raw_received_jan1_value;

% Liabilities on Jan 1:
% Loan reduced by payment; new AP for raw materials received Jan 1
var int: loan1 = loan0 - loan_payment_dec;
var int: ap1   = raw_received_jan1_value;
var int: liab1 = loan1 + ap1;

var int: assets1 = cash1 + ar1 + inv1;

%--------------------------
% Constraints
%--------------------------
% Production limited by available raw materials on Dec 1
constraint xT <= max_raw_t;
constraint xR <= max_raw_r;

% Minimum cash balance on Jan 1
constraint cash1 >= min_cash_jan1;

% Current ratio on Jan 1 at least 2: assets/liabilities >= 2
constraint 100 * assets1 >= min_current_ratio_times100 * liab1;

%--------------------------
% Objective
%--------------------------
solve maximize profit;

%--------------------------
% Output
%--------------------------
output [
  "Tape recorders (Dec) = ", show(xT), "\n",
  "Radios (Dec)         = ", show(xR), "\n",
  "Max contribution ($) = ", show(profit), "\n",
  "---- Jan 1, 2003 ----\n",
  "Cash     = ", show(cash1), "\n",
  "A/R      = ", show(ar1), "\n",
  "Inventory= ", show(inv1), "\n",
  "Assets   = ", show(assets1), "\n",
  "Liabilities (Loan+AP)= ", show(liab1), "\n",
  "Current ratio = ", show(assets1), " / ", show(liab1), "\n"
];