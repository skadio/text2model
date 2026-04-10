% Parameters
int: labor_cost_tape = 50;
int: labor_cost_radio = 35;
int: material_cost_tape = 30;
int: material_cost_radio = 40;

int: price_tape = 100;
int: price_radio = 90;

int: raw_cap_tape_dec = 100;
int: raw_cap_radio_dec = 100;

int: cash_dec1 = 10000;
int: ar_dec1 = 3000;
int: inv_dec1 = 7000;
int: loan_dec1 = 10000;

int: ar_collected_dec = 2000;

int: loan_payment_dec = 1000;
int: rent_dec = 1000;

int: raw_material_received_jan1_value = 2000;  % received Jan 1, payable Feb 1 (i.e., current liability on Jan 1)

int: min_cash_jan1 = 4000;
int: min_current_ratio_times10 = 20; % represent ratio >= 2.0 as 10*CR >= 20

% Variables
var 0..raw_cap_tape_dec: x_tape;
var 0..raw_cap_radio_dec: x_radio;

var 0..cash_dec1: cash_jan1; % bounded above by initial cash (only outflows net of AR collection)

var 0..(ar_dec1 + price_tape*raw_cap_tape_dec + price_radio*raw_cap_radio_dec): ar_jan1;

var 0..inv_dec1: inv_jan1;

var 0..(loan_dec1 + raw_material_received_jan1_value): liab_jan1;

var int: profit_contribution;

% Constraints
constraint x_tape >= 0;
constraint x_radio >= 0;

% Cash flow during December to Jan 1:
% All December sales are on credit (no cash from new sales in December)
% Cash Jan 1 = cash Dec 1 + AR collected - loan payment - rent - (labor+materials for production)
constraint
  cash_jan1 =
    cash_dec1
  + ar_collected_dec
  - loan_payment_dec
  - rent_dec
  - (labor_cost_tape + material_cost_tape) * x_tape
  - (labor_cost_radio + material_cost_radio) * x_radio;

% Minimum cash balance on Jan 1
constraint cash_jan1 >= min_cash_jan1;

% Accounts receivable on Jan 1:
% Start with AR, collect some in December, add December credit sales
constraint
  ar_jan1 =
    ar_dec1
  - ar_collected_dec
  + price_tape * x_tape
  + price_radio * x_radio;

% Inventory on Jan 1:
% Assume beginning inventory is sold/used up by Dec 31 for simplicity: inventory outstanding becomes 0.
% (No further data is given to track inventory turnover; enforce nonnegativity with inv_jan1 = 0.)
constraint inv_jan1 = 0;

% Liabilities on Jan 1:
% Loan reduced by payment; add new current liability for raw materials received Jan 1 payable Feb 1.
constraint
  liab_jan1 =
    (loan_dec1 - loan_payment_dec)
  + raw_material_received_jan1_value;

% Current ratio on Jan 1 at least 2:
% Current assets = cash + AR + inventory
% Enforce: (cash + AR + inv) / liabilities >= 2  <=> cash + AR + inv >= 2 * liabilities
constraint cash_jan1 + ar_jan1 + inv_jan1 >= 2 * liab_jan1;

% Profit contribution from December production (revenue - variable costs)
constraint
  profit_contribution =
    (price_tape - labor_cost_tape - material_cost_tape) * x_tape
  + (price_radio - labor_cost_radio - material_cost_radio) * x_radio;

% Objective
solve maximize profit_contribution;