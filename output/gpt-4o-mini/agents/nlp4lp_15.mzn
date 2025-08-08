int: P;                          % Number of products
int: Cash;                       % Initial cash available for investment
array[1..P] of int: Hour;       % Hours required to produce one unit of product i
array[1..P] of int: Cost;       % Cost to produce one unit of product i
array[1..P] of int: Price;      % Selling price for one unit of product i
array[1..P] of float: InvestPercentage; % Percentage of income to reinvest for product i
int: UpgradeHours;              % Hours required for upgrading the machinery
int: UpgradeCost;               % Cost associated with upgrading the machinery
int: AvailableHours;            % Total available machine hours

/* Decision variables */
array[1..P] of var 0..Cash div min(Cost): units; % Number of units to produce for each product
var 0..Cash: totalInvestment;   % Total investment made
var 0..Cash: totalRevenue;      % Total revenue generated
var 0..Cash: totalCost;         % Total cost incurred
var 0..Cash: totalNetIncome;    % Total net income

/* Constraints */
constraint totalCost = sum(i in 1..P)(Cost[i] * units[i]);
constraint totalRevenue = sum(i in 1..P)(Price[i] * units[i]);
constraint totalNetIncome = totalRevenue - totalCost - totalInvestment;

constraint totalCost <= Cash;   % Total cost must not exceed available cash
constraint totalNetIncome >= 0;  % Net income must be non-negative

/* Machine hours constraint */
constraint sum(i in 1..P)(Hour[i] * units[i]) <= AvailableHours;

/* Investment constraint */
constraint totalInvestment = sum(i in 1..P)(InvestPercentage[i] * totalNetIncome);

/* Upgrade option */
var 0..1: upgrade;               % 1 if upgrade is chosen, 0 otherwise
constraint (upgrade = 1 -> totalInvestment >= UpgradeCost);
constraint (upgrade = 1 -> sum(i in 1..P)(Hour[i] * units[i]) + UpgradeHours <= AvailableHours);

/* Objective function */
solve maximize totalNetIncome;

/* Output */
output [ "Total Net Income = ", show(totalNetIncome), "\n",
         "Units produced = ", show(units), "\n",
         "Total Revenue = ", show(totalRevenue), "\n",
         "Total Cost = ", show(totalCost), "\n",
         "Total Investment = ", show(totalInvestment), "\n" ];