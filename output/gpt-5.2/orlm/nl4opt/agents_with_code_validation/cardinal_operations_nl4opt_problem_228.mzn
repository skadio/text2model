% Investment optimization (linear, continuous)
float: total_budget = 3000.0;
float: min_clothing_to_tech_ratio = 4.0;
float: tech_investment_max = 500.0;
float: clothing_return_rate = 0.07;
float: tech_return_rate = 0.10;

var 0.0..total_budget: invest_clothing;
var 0.0..tech_investment_max: invest_tech;

% Budget: invest all money (otherwise objective would still push to invest more,
% but making it equality helps avoid solver issues and matches "has $3000 to invest")
constraint invest_clothing + invest_tech = total_budget;

% Ratio constraint
constraint invest_clothing >= min_clothing_to_tech_ratio * invest_tech;

% Objective: maximize profit directly (avoid an extra profit variable)
solve maximize clothing_return_rate * invest_clothing
             + tech_return_rate * invest_tech;

output [
  "invest_clothing = ", show(invest_clothing), "\n",
  "invest_tech = ", show(invest_tech), "\n",
  "profit = ", show(clothing_return_rate * invest_clothing + tech_return_rate * invest_tech), "\n"
];