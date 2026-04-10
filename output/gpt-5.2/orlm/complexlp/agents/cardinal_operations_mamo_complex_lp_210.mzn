% Parameters
% ----------------------------
% Product set
% ----------------------------
set of int: PRODUCTS = 1..2;              % 1=tape recorder, 2=radio

% ----------------------------
% Per-unit economics (USD)
% ----------------------------
array[PRODUCTS] of int: labor_cost    = [50, 35];
array[PRODUCTS] of int: material_cost = [30, 40];
array[PRODUCTS] of int: selling_price = [100, 90];

% ----------------------------
% Raw material availability on Dec 1, expressed as max producible units per product
% ----------------------------
array[PRODUCTS] of int: max_units_from_raw_material_dec1 = [100, 100];

% ----------------------------
% Dec 1 balance sheet (USD)
% ----------------------------
int: cash_dec1 = 10000;
int: accounts_receivable_dec1 = 3000;
int: inventory_dec1 = 7000;
int: loan_dec1 = 10000;

% ----------------------------
% December cash-flow / obligations (USD)
% ----------------------------
int: ar_collected_in_dec = 2000;          % cash collected in December from A/R
int: loan_principal_payment_dec = 1000;   % cash outflow to pay down loan in December
int: rent_payment_dec = 1000;             % cash outflow in December

% ----------------------------
% Jan 1 events and requirements (USD)
% ----------------------------
int: raw_material_received_jan1 = 2000;   % received on Jan 1, payable Feb 1 (A/P)
int: min_cash_jan1 = 4000;                % minimum required cash balance on Jan 1
float: min_current_ratio_jan1 = 2.0;      % minimum current ratio on Jan 1 (not used directly)


% Variables
% ----------------------------
% Production decision for December (units)
% ----------------------------
array[PRODUCTS] of var 0..100: produce_dec;   % bounded by raw material limits given

% ----------------------------
% Accounting state variables on Jan 1 (USD)
% ----------------------------
var 0..20000: cash_jan1;                      % cash after December flows
var 0..40000: accounts_receivable_jan1;       % includes Dec credit sales
var 0..40000: inventory_jan1;                 % remaining/ending inventory value
var 0..20000: loan_jan1;                      % loan balance after payment
var 0..20000: accounts_payable_jan1;          % from raw material received Jan 1

% ----------------------------
% Performance measure (USD)
% ----------------------------
var -100000..100000: contribution_profit_dec; % maximize contribution from Dec production


% Constraints
% ----------------------------
% Production feasibility (Dec 1 raw material limits)
% ----------------------------
constraint
  forall(p in PRODUCTS) (
    produce_dec[p] <= max_units_from_raw_material_dec1[p]
  );

% ----------------------------
% Contribution profit definition (December production contribution margin)
% ----------------------------
constraint
  contribution_profit_dec =
    sum(p in PRODUCTS) (
      produce_dec[p] * (selling_price[p] - labor_cost[p] - material_cost[p])
    );

% ----------------------------
% Accounts receivable on Jan 1: beginning A/R minus collections in Dec + Dec credit sales
% ----------------------------
constraint
  accounts_receivable_jan1 =
    accounts_receivable_dec1
    - ar_collected_in_dec
    + sum(p in PRODUCTS) (produce_dec[p] * selling_price[p]);

% ----------------------------
% Loan balance on Jan 1: beginning loan minus principal paid in Dec
% ----------------------------
constraint
  loan_jan1 = loan_dec1 - loan_principal_payment_dec;

% ----------------------------
% Accounts payable on Jan 1: raw material received Jan 1 to be paid Feb 1
% ----------------------------
constraint
  accounts_payable_jan1 = raw_material_received_jan1;

% ----------------------------
% Inventory on Jan 1: assume all units produced in Dec are sold (demand high),
% so ending inventory equals beginning inventory
% ----------------------------
constraint
  inventory_jan1 = inventory_dec1;

% ----------------------------
% Cash balance on Jan 1: beginning cash + A/R collections - cash expenses paid in Dec
% (All Dec sales are on credit; raw materials for Dec assumed already on hand.)
% ----------------------------
constraint
  cash_jan1 =
    cash_dec1
    + ar_collected_in_dec
    - sum(p in PRODUCTS) (produce_dec[p] * labor_cost[p])
    - loan_principal_payment_dec
    - rent_payment_dec;

% ----------------------------
% Minimum cash requirement on Jan 1
% ----------------------------
constraint
  cash_jan1 >= min_cash_jan1;

% ----------------------------
% Current ratio requirement on Jan 1:
% Current assets / current liabilities >= 2
% Current assets: cash + A/R + inventory
% Current liabilities: loan + A/P
% Implemented without floats by cross-multiplying with factor 2.
% ----------------------------
constraint
  cash_jan1 + accounts_receivable_jan1 + inventory_jan1 >=
  2 * (loan_jan1 + accounts_payable_jan1);


% Objective
solve maximize contribution_profit_dec;