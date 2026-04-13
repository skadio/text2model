% Farmer crop allocation - minimize total profit under constraints
% Data embedded directly per problem statement.

var 0..200000: corn;     % acres of Corn
var 0..200000: wheat;    % acres of Wheat
var 0..200000: soybean;  % acres of Soybean

constraint 2 * corn + 3 * wheat <= 15000;
constraint corn + wheat + soybean >= 8000;
constraint abs(wheat - soybean) <= 2000;

var int: total_profit = 3 * corn + 4 * wheat + 5 * soybean;

solve minimize total_profit;

output [
  "corn=", show(corn), "\n",
  "wheat=", show(wheat), "\n",
  "soybean=", show(soybean), "\n",
  "total_profit=", show(total_profit), "\n"
];