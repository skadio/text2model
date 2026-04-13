% Factory production planning (maximize profit)
% Data embedded as per problem statement

int: P = 3;   % products: 1=I, 2=II, 3=III
int: MA = 2;  % A machines: 1=A1, 2=A2
int: MB = 3;  % B machines: 1=B1, 2=B2, 3=B3

set of int: Products = 1..P;
set of int: AMachines = 1..MA;
set of int: BMachines = 1..MB;

% Processing time per piece (minutes); 0 => not allowed
array[AMachines, Products] of int: timeA =
  array2d(AMachines, Products,
    [ 5, 10,  0,    % A1: I, II, III
      7,  9, 12     % A2: I, II, III
    ]);

array[BMachines, Products] of int: timeB =
  array2d(BMachines, Products,
    [ 6,  8,  0,    % B1: I, II, III
      4,  0, 11,    % B2: I, II, III
      7,  0,  0     % B3: I, II, III
    ]);

% Effective machine hours available
array[AMachines] of int: hoursA = [6000, 10000];
array[BMachines] of int: hoursB = [4000, 7000, 4000];

% Costs per machine hour (Yuan/hour) scaled by 100
array[AMachines] of int: costA_c = [5, 3];      % 0.05, 0.03
array[BMachines] of int: costB_c = [6, 11, 5];  % 0.06, 0.11, 0.05

% Raw material cost and unit price (Yuan/piece) scaled by 100
array[Products] of int: raw_c   = [25, 35, 50];   % 0.25, 0.35, 0.50
array[Products] of int: price_c = [125, 200, 280];% 1.25, 2.00, 2.80

% Upper bounds: each product quantity cannot exceed total A-capacity (pieces)
function int: ceil_div(int: a, int: b) = (a + b - 1) div b;

array[Products] of int: ub_q =
  [ ceil_div(hoursA[1]*60, timeA[1,1]) + ceil_div(hoursA[2]*60, timeA[2,1]),  % I on A1 or A2
    ceil_div(hoursA[1]*60, timeA[1,2]) + ceil_div(hoursA[2]*60, timeA[2,2]),  % II on A1 or A2
    ceil_div(hoursA[2]*60, timeA[2,3])                                        % III only on A2
  ];

% Decision variables:
% q[p] = total quantity of product p
array[Products] of var 0..ub_q[p]: q;

% Minutes allocated on each machine to each product (var int)
% Link via time * pieces = minutes, avoiding explicit piece vars per machine-product.
array[AMachines, Products] of var 0..max(hoursA)*60: minA;
array[BMachines, Products] of var 0..max(hoursB)*60: minB;

var int: revenue_c;
var int: rawcost_c;
var int: machcost_c;
var int: profit_c;

% Disallow invalid assignments
constraint forall(a in AMachines, p in Products where timeA[a,p] = 0) (minA[a,p] = 0);
constraint forall(b in BMachines, p in Products where timeB[b,p] = 0) (minB[b,p] = 0);

% Capacity constraints (minutes)
constraint forall(a in AMachines) (sum(p in Products)(minA[a,p]) <= hoursA[a] * 60);
constraint forall(b in BMachines) (sum(p in Products)(minB[b,p]) <= hoursB[b] * 60);

% Flow: minutes allocated must correspond to producing exactly q[p] pieces at each stage.
% We enforce: sum_a minA[a,p] = q[p] * timeA_used_per_piece across machines.
% Since each piece is fully processed on exactly one machine type, we model this with
% divisibility and piece-count consistency using integer piece variables per machine-product,
% but with tight per-(machine,product) bounds to keep the model fast.

array[AMachines, Products] of var int: xA;
array[BMachines, Products] of var int: xB;

% Tight bounds for xA/xB derived from capacities
constraint forall(a in AMachines, p in Products) (
  xA[a,p] >= 0 /\
  xA[a,p] <= (if timeA[a,p] > 0 then (hoursA[a]*60) div timeA[a,p] else 0 endif)
);
constraint forall(b in BMachines, p in Products) (
  xB[b,p] >= 0 /\
  xB[b,p] <= (if timeB[b,p] > 0 then (hoursB[b]*60) div timeB[b,p] else 0 endif)
);

% Link minutes and pieces exactly
constraint forall(a in AMachines, p in Products) (minA[a,p] = timeA[a,p] * xA[a,p]);
constraint forall(b in BMachines, p in Products) (minB[b,p] = timeB[b,p] * xB[b,p]);

% Stage balances
constraint forall(p in Products) (q[p] = sum(a in AMachines)(xA[a,p]));
constraint forall(p in Products) (q[p] = sum(b in BMachines)(xB[b,p]));

% Profit computation (all scaled by 100)
constraint revenue_c = sum(p in Products)(price_c[p] * q[p]);
constraint rawcost_c = sum(p in Products)(raw_c[p] * q[p]);

% Machine cost: minutes * (cost_per_hour) / 60  (still scaled by 100)
constraint machcost_c =
  sum(a in AMachines, p in Products)( (minA[a,p] * costA_c[a]) div 60 )
+ sum(b in BMachines, p in Products)( (minB[b,p] * costB_c[b]) div 60 );

constraint profit_c = revenue_c - rawcost_c - machcost_c;

solve maximize profit_c;

output [
  "q(I,II,III) = ", show(q), "\n",
  "profit (scaled by 100) = ", show(profit_c), "\n",
  "profit (Yuan) = ", show(profit_c / 100.0), "\n"
];