% Parameters (with values embedded)
int: nProd = 2;
set of int: P = 1..nProd;

int: TAPE = 1;
int: RADIO = 2;

array[P] of int: laborCost = [50, 35];
array[P] of int: materialCost = [30, 40];
array[P] of int: price = [100, 90];

array[P] of int: maxUnitsFromMaterial = [100, 100];

% Dec 1 balance sheet (current items only)
int: cash0 = 10000;
int: ar0   = 3000;
int: inv0  = 7000;
int: loan0 = 10000;

% December cash flows (known)
int: arCollectedDec = 2000;
int: loanPaymentDec = 1000;
int: rentDec        = 1000;

% Jan 1 events affecting current ratio
int: materialsReceivedJan1 = 2000; % added to inventory on Jan 1
int: minCashJan1 = 4000;
int: minCurrentRatioTimesLiab = 2; % current assets >= 2 * current liabilities

% Variables
array[P] of var 0..100: x; % units produced in December for each product

var 0..1000000: totalContribution;
var 0..1000000: cashJan1;
var 0..1000000: arJan1;
var 0..1000000: invJan1;
var 0..1000000: loanJan1;

% Constraints
constraint forall(p in P)(x[p] <= maxUnitsFromMaterial[p]);

% Contribution to profit from December's production (selling on credit doesn't change contribution)
constraint totalContribution =
  sum(p in P)( (price[p] - laborCost[p] - materialCost[p]) * x[p] );

% Cash on Jan 1: start cash + AR collected - labor paid - rent - loan payment
constraint cashJan1 =
  cash0
  + arCollectedDec
  - sum(p in P)(laborCost[p] * x[p])
  - rentDec
  - loanPaymentDec;

constraint cashJan1 >= minCashJan1;

% Accounts receivable on Jan 1: start AR - collected + all December sales (on credit)
constraint arJan1 =
  ar0
  - arCollectedDec
  + sum(p in P)(price[p] * x[p]);

% Inventory on Jan 1: start inventory - materials used + materials received on Jan 1
constraint invJan1 =
  inv0
  - sum(p in P)(materialCost[p] * x[p])
  + materialsReceivedJan1;

% Loan on Jan 1 after December payment
constraint loanJan1 = loan0 - loanPaymentDec;

% Bank current ratio requirement on Jan 1: (cash + AR + inventory) / loan >= 2
constraint cashJan1 + arJan1 + invJan1 >= minCurrentRatioTimesLiab * loanJan1;

% Objective
solve maximize totalContribution;