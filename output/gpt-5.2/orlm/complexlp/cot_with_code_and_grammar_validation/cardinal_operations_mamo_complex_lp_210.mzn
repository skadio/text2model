% Parameters
int: labor_tape = 50;
int: labor_radio = 35;
int: material_tape = 30;
int: material_radio = 40;

int: price_tape = 100;
int: price_radio = 90;

int: rm_cap_tape = 100;
int: rm_cap_radio = 100;

int: cash0 = 10000;
int: ar0 = 3000;
int: inv0 = 7000;
int: loan0 = 10000;

int: ar_collect_dec = 2000;

int: loan_pay_dec = 1000;
int: rent_dec = 1000;

int: rm_in_jan_value = 2000;        % received Jan 1, payable Feb 1
int: min_cash_jan1 = 4000;
int: min_current_ratio_num = 2;     % current ratio >= 2

% Variables
var 0..rm_cap_tape: x_tape;
var 0..rm_cap_radio: x_radio;

var int: profit;

% Constraints
constraint profit =
  (price_tape - labor_tape - material_tape) * x_tape
+ (price_radio - labor_radio - material_radio) * x_radio;

% Cash on Jan 1 (after December flows; no collection of December sales yet)
% cash1 = cash0 + ar_collect_dec - labor_costs - rent - loan_payment
constraint cash0 + ar_collect_dec
        - (labor_tape * x_tape + labor_radio * x_radio)
        - rent_dec - loan_pay_dec
        >= min_cash_jan1;

% Current ratio on Jan 1:
% Current assets = cash1 + AR1 + INV1
% AR1 = ar0 - ar_collect_dec + (price_tape*x_tape + price_radio*x_radio)
% INV1 = inv0 + rm_in_jan_value  (treat received materials as inventory at value)
% Current liabilities = loan0 - loan_pay_dec  (raw materials received Jan 1 are payable Feb 1, not a Jan 1 liability)
%
% Inequality: (cash1 + AR1 + INV1) / (loan1) >= 2  <=> assets >= 2*loan1
constraint
  let {
    var int: cash1 = cash0 + ar_collect_dec
                     - (labor_tape * x_tape + labor_radio * x_radio)
                     - rent_dec - loan_pay_dec,
    var int: ar1 = ar0 - ar_collect_dec + (price_tape * x_tape + price_radio * x_radio),
    var int: inv1 = inv0 + rm_in_jan_value,
    int: loan1 = loan0 - loan_pay_dec
  } in
    cash1 + ar1 + inv1 >= min_current_ratio_num * loan1;

% Objective
solve maximize profit;