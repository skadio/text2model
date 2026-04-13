% Investment allocation problem (all data embedded)

int: total_fund = 10000;
int: minX = 2000;
int: minY = 3000;

% Use cents to keep everything integer:
int: rX = 5;   % 0.05 dollars per dollar = 5 cents per dollar
int: rY = 8;   % 0.08 dollars per dollar = 8 cents per dollar

var minX..total_fund: x;   % dollars invested in X
var minY..total_fund: y;   % dollars invested in Y

constraint x + y = total_fund;

var 0..(rX*total_fund + rY*total_fund): total_return_cents;
constraint total_return_cents = rX * x + rY * y;

solve minimize total_return_cents;

output [
  "Invest X = $", show(x), "\n",
  "Invest Y = $", show(y), "\n",
  "Minimum total return = $", show(total_return_cents div 100),
  ".", if (total_return_cents mod 100) < 10 then "0" else "" endif,
  show(total_return_cents mod 100), "\n"
];