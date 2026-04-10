% Parameters
int: labor_tape = 50;
int: labor_radio = 35;
int: material_tape = 30;
int: material_radio = 40;

int: price_tape = 100;
int: price_radio = 90;

int: rm_capacity_tape = 100;
int: rm_capacity_radio = 100;

int: cash_dec1 = 10000;
int: ar_dec1 = 3000;
int: inv_dec1 = 7000;
int: loan_dec1 = 10000;

int: ar_collected_dec = 2000;
int: loan_payment_dec = 1000;
int: rent_dec = 1000;

int: rm_received_jan1 = 2000; % value of raw materials received on Jan 1, payable Feb 1 (accounts payable)

int: min_cash_jan1 = 4000;
int: min_current_ratio_num = 2; % current ratio >= 2

% Variables
var 0..rm_capacity_tape: x_tape;   % units produced in December
var 0..rm_capacity_radio: x_radio; % units produced in December

var 0..cash_dec1: cash_jan1; % cash balance on Jan 1 (bounded above by initial cash given only outflows net inflows)
var 0..(ar_dec1 + price_tape*rm_capacity_tape + price_radio*rm_capacity_radio): ar_jan1;
var 0..(inv_dec1 + rm_received_jan1): inv_jan1;
var 0..(loan_dec1 + rm_received_jan1): liab_jan1;

var 0..( (price_tape-labor_tape-material_tape)*rm_capacity_tape
       + (price_radio-labor_radio-material_radio)*rm_capacity_radio ): contrib_profit;

% Constraints
constraint x_tape >= 0;
constraint x_radio >= 0;

% Raw material limits (given enough to make up to 100 of each)
constraint x_tape <= rm_capacity_tape;
constraint x_radio <= rm_capacity_radio;

% Cash flow in December:
% Begin with cash_dec1, collect ar_collected_dec, pay labor for production, pay loan_payment_dec and rent_dec.
constraint cash_jan1 = cash_dec1
                     + ar_collected_dec
                     - labor_tape * x_tape
                     - labor_radio * x_radio
                     - loan_payment_dec
                     - rent_dec;

constraint cash_jan1 >= min_cash_jan1;

% Accounts receivable on Jan 1:
% Start with ar_dec1, collect ar_collected_dec, add December credit sales.
constraint ar_jan1 = ar_dec1
                   - ar_collected_dec
                   + price_tape * x_tape
                   + price_radio * x_radio;

% Inventory on Jan 1:
% Start with inv_dec1, consume materials used in December production, receive additional raw materials worth rm_received_jan1 on Jan 1.
constraint inv_jan1 = inv_dec1
                    - material_tape * x_tape
                    - material_radio * x_radio
                    + rm_received_jan1;

% Liabilities on Jan 1:
% Loan reduced by loan_payment_dec; accounts payable for Jan 1 raw material receipt equals rm_received_jan1.
constraint liab_jan1 = (loan_dec1 - loan_payment_dec) + rm_received_jan1;

% Current ratio on Jan 1: (cash + AR + inventory) / liabilities >= 2
% Linearized: cash + AR + inv >= 2 * liabilities
constraint cash_jan1 + ar_jan1 + inv_jan1 >= min_current_ratio_num * liab_jan1;

% Objective contribution to profit from December production:
% contribution = revenue - labor - materials
constraint contrib_profit =
    (price_tape - labor_tape - material_tape) * x_tape
  + (price_radio - labor_radio - material_radio) * x_radio;

% Objective
solve maximize contrib_profit;