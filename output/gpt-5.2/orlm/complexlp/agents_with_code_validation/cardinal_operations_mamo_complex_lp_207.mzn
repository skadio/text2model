% Parameters
% Purchase and capacity limits
int: max_raw_lb = 4000;                 % maximum raw material purchasable (lb/year)
int: max_lab_hours = 6000;              % laboratory time available (hours/year)

% Raw material purchase and base processing
int: raw_cost_per_lb = 3;               % $/lb raw material cost
int: base_lab_hours_per_lb = 1;         % lab hours needed to process 1 lb raw into regular products

% Yields from 1 lb processed raw material (oz)
int: brute_reg_yield_oz_per_lb = 3;     % oz Regular Brute per lb raw processed
int: chanelle_reg_yield_oz_per_lb = 4;  % oz Regular Chanelle per lb raw processed

% Selling prices ($/oz)
int: price_brute_reg = 7;               % Regular Brute price
int: price_chanelle_reg = 6;            % Regular Chanelle price
int: price_brute_lux = 18;              % Luxury Brute price
int: price_chanelle_lux = 14;           % Luxury Chanelle price

% Further processing requirements and costs (per oz regular converted to luxury)
int: extra_lab_hours_per_oz_brute = 3;  % additional lab hours per oz Regular Brute to make Luxury Brute
int: extra_lab_hours_per_oz_chan = 2;   % additional lab hours per oz Regular Chanelle to make Luxury Chanelle
int: extra_proc_cost_per_oz = 4;        % $ processing cost per oz further processed (both types)


% Variables
var 0..max_raw_lb: raw_lb;              % lb of raw material purchased and processed into regular products

% Amounts further processed into luxury (oz)
var 0..(brute_reg_yield_oz_per_lb * max_raw_lb): brute_to_lux_oz;        % oz Regular Brute converted to Luxury Brute
var 0..(chanelle_reg_yield_oz_per_lb * max_raw_lb): chanelle_to_lux_oz;  % oz Regular Chanelle converted to Luxury Chanelle

% Amounts sold as regular (oz)
var 0..(brute_reg_yield_oz_per_lb * max_raw_lb): brute_reg_sold_oz;        % oz Regular Brute sold
var 0..(chanelle_reg_yield_oz_per_lb * max_raw_lb): chanelle_reg_sold_oz;  % oz Regular Chanelle sold

% Total lab hours used (hours) - bounded by capacity
var 0..max_lab_hours: lab_hours_used;

% Profit ($) - bound conservatively
var -100000000..100000000: profit;


% Constraints
% --- Material balance: regular production from raw material is split into regular sales and luxury conversion ---
constraint
  brute_reg_sold_oz + brute_to_lux_oz
  = brute_reg_yield_oz_per_lb * raw_lb;

constraint
  chanelle_reg_sold_oz + chanelle_to_lux_oz
  = chanelle_reg_yield_oz_per_lb * raw_lb;

% --- Laboratory time accounting and capacity ---
% Total lab hours = base processing hours per lb + extra hours for further processing
constraint
  lab_hours_used
  = base_lab_hours_per_lb * raw_lb
    + extra_lab_hours_per_oz_brute * brute_to_lux_oz
    + extra_lab_hours_per_oz_chan * chanelle_to_lux_oz;

constraint
  lab_hours_used <= max_lab_hours;

% --- Raw material purchase/processing capacity (already bounded by variable domain, but stated explicitly) ---
constraint
  raw_lb <= max_raw_lb;

% --- Profit definition (revenue - raw material cost - further processing cost; lab time cost is fixed so omitted) ---
constraint
  profit
  = price_brute_reg * brute_reg_sold_oz
    + price_chanelle_reg * chanelle_reg_sold_oz
    + price_brute_lux * brute_to_lux_oz
    + price_chanelle_lux * chanelle_to_lux_oz
    - raw_cost_per_lb * raw_lb
    - extra_proc_cost_per_oz * (brute_to_lux_oz + chanelle_to_lux_oz);


% Objective
solve maximize profit;