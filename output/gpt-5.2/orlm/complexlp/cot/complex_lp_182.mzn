% Parameters (with values embedded)
int: profitA = 10;
int: profitB = 20;

int: stock_mango = 25;
int: stock_pineapple = 10;
int: stock_strawberry = 120;

% To avoid fractions: scale mango & pineapple constraints by 8
% A uses: mango 1/4 -> 2/8, pineapple 1/8 -> 1/8
% B uses: mango 1/2 -> 4/8, pineapple 1/4 -> 2/8
int: mango_scale = 8;
int: pineapple_scale = 8;

int: mangoA = 2;        % in 1/8 mango units
int: mangoB = 4;
int: pineA  = 1;        % in 1/8 pineapple units
int: pineB  = 2;

int: strawA = 3;
int: strawB = 1;

int: tol = 5; % at most 5 units left or 5 additional units used

% Variables
var 0..1000: x1; % units of fruit salad A (integer)
var 0..1000: x2; % units of fruit salad B (integer)

% Constraints
% Mango balance with tolerance: usage within [stock-5, stock+5]
constraint
  mango_scale * (stock_mango - tol) <= mangoA*x1 + mangoB*x2 /\
  mangoA*x1 + mangoB*x2 <= mango_scale * (stock_mango + tol);

% Pineapple balance with tolerance
constraint
  pineapple_scale * (stock_pineapple - tol) <= pineA*x1 + pineB*x2 /\
  pineA*x1 + pineB*x2 <= pineapple_scale * (stock_pineapple + tol);

% Strawberry balance with tolerance (no scaling needed)
constraint
  stock_strawberry - tol <= strawA*x1 + strawB*x2 /\
  strawA*x1 + strawB*x2 <= stock_strawberry + tol;

% Objective
solve maximize profitA*x1 + profitB*x2;