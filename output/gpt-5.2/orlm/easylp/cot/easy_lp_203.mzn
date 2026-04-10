% Parameters (with values embedded)
int: total_investment = 1000000;
array[1..3] of string: funds = ["X","Y","Z"];
array[1..3] of int: min_invest = [200000, 150000, 250000];
% returns in percent
array[1..3] of int: return_pct = [2, 3, 4];

% Variables
array[1..3] of var 0..total_investment: invest;

% Constraints
constraint forall(i in 1..3) (invest[i] >= min_invest[i]);
constraint sum(i in 1..3) (invest[i]) = total_investment;

% Objective
% Minimize total return in dollars: sum(invest[i] * return_pct[i] / 100)
% Use integer arithmetic by minimizing scaled return (multiply by 100).
var 0..(total_investment * 100): total_return_cents_scaled;
constraint total_return_cents_scaled = sum(i in 1..3) (invest[i] * return_pct[i]);

solve minimize total_return_cents_scaled;

output [
  "Investment X = ", show(invest[1]), "\n",
  "Investment Y = ", show(invest[2]), "\n",
  "Investment Z = ", show(invest[3]), "\n",
  "Minimum total return (nearest dollar) = ",
  show( (total_return_cents_scaled + 50) div 100 ), "\n"
];