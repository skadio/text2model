% Haus Toys: choose which toy types to manufacture (0/1), maximize profit.
% Interpreting "how many types" as selecting toy categories to produce, with
% binary production decisions, while honoring logical/resource constraints.
% We allow any nonnegative integer number produced if a type is chosen.

set of int: T = 1..4;
int: TRUCK = 1;
int: AIRPLANE = 2;
int: BOAT = 3;
int: TRAIN = 4;

array[T] of int: profit = [5, 10, 8, 7];

int: wood_avail = 890;
array[T] of int: wood_req = [12, 20, 15, 10];

int: steel_avail = 500;
array[T] of int: steel_req = [6, 3, 5, 4];

array[T] of var 0..1: make;     % 1 if we manufacture that toy type
array[T] of var 0..10000: qty;  % quantity produced (0 if not manufactured)

% Link qty to make: if not made, qty=0; if made, qty can be positive
constraint forall(t in T) (
  qty[t] <= make[t] * 10000
);

% Resource constraints
constraint sum(t in T)(wood_req[t] * qty[t]) <= wood_avail;
constraint sum(t in T)(steel_req[t] * qty[t]) <= steel_avail;

% Logical constraints
% If trucks, then not trains
constraint make[TRUCK] + make[TRAIN] <= 1;

% If boats, then also airplanes
constraint make[BOAT] <= make[AIRPLANE];

% Boats produced cannot exceed trains produced
constraint qty[BOAT] <= qty[TRAIN];

var int: total_profit = sum(t in T)(profit[t] * qty[t]);
var int: num_types = sum(t in T)(make[t]);

solve maximize total_profit;

output [
  "Total profit = ", show(total_profit), "\n",
  "Number of types manufactured = ", show(num_types), "\n",
  "make(truck, airplane, boat, train) = ", show([make[t] | t in T]), "\n",
  "qty(truck, airplane, boat, train) = ", show([qty[t] | t in T]), "\n"
];