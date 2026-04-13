% Parameters
% Resource limits
int: lab_hours_available = 6000;          % total laboratory hours available per year
int: raw_lb_max = 4000;                   % maximum pounds of raw material purchasable

% Costs
float: raw_cost_per_lb = 3.0;             % $ per lb raw material
float: further_process_cost_per_oz = 4.0; % $ per oz for further processing (either product)

% Base processing (raw -> regular)
int: lab_hours_per_lb_raw_processed = 1;  % lab hours per lb processed into regular products
int: reg_brute_oz_per_lb = 3;             % oz of Regular Brute per lb processed
int: reg_chanelle_oz_per_lb = 4;          % oz of Regular Chanelle per lb processed

% Further processing (regular -> luxury)
int: lab_hours_per_oz_reg_brute_to_lux = 3;     % lab hours per oz Regular Brute -> Luxury Brute
int: lab_hours_per_oz_reg_chanelle_to_lux = 2;  % lab hours per oz Regular Chanelle -> Luxury Chanelle

% Selling prices
float: price_reg_brute = 7.0;             % $ per oz Regular Brute
float: price_reg_chanelle = 6.0;          % $ per oz Regular Chanelle
float: price_lux_brute = 18.0;            % $ per oz Luxury Brute
float: price_lux_chanelle = 14.0;         % $ per oz Luxury Chanelle


% Variables
var 0.0..raw_lb_max: raw_lb_processed;         % lb of raw material processed into regular products

var 0.0..(reg_brute_oz_per_lb * raw_lb_max): reg_brute_sold;        % oz Regular Brute sold (not further processed)
var 0.0..(reg_chanelle_oz_per_lb * raw_lb_max): reg_chanelle_sold;  % oz Regular Chanelle sold (not further processed)

var 0.0..(reg_brute_oz_per_lb * raw_lb_max): reg_brute_to_lux;      % oz Regular Brute further processed to Luxury Brute
var 0.0..(reg_chanelle_oz_per_lb * raw_lb_max): reg_chanelle_to_lux;% oz Regular Chanelle further processed to Luxury Chanelle

var 0.0..(reg_brute_oz_per_lb * raw_lb_max): lux_brute_sold;        % oz Luxury Brute sold
var 0.0..(reg_chanelle_oz_per_lb * raw_lb_max): lux_chanelle_sold;  % oz Luxury Chanelle sold

var float: profit;  % total profit ($)


% Constraints

%--------------------------
% Raw material availability
%--------------------------
constraint
  raw_lb_processed <= raw_lb_max;

%-----------------------------------------------------------
% Material balance: regular production from processed raw lb
% (split into sold-as-regular and sent to further processing)
%-----------------------------------------------------------
constraint
  reg_brute_sold + reg_brute_to_lux = reg_brute_oz_per_lb * raw_lb_processed;

constraint
  reg_chanelle_sold + reg_chanelle_to_lux = reg_chanelle_oz_per_lb * raw_lb_processed;

%----------------------------------------------------
% Further processing yield: 1 oz regular -> 1 oz lux
% (all luxury produced is sold)
%----------------------------------------------------
constraint
  lux_brute_sold = reg_brute_to_lux;

constraint
  lux_chanelle_sold = reg_chanelle_to_lux;

%-----------------------------------------
% Laboratory hours capacity (fixed cost)
% Includes: base processing + further processing
%-----------------------------------------
constraint
  lab_hours_per_lb_raw_processed * raw_lb_processed
  + lab_hours_per_oz_reg_brute_to_lux * reg_brute_to_lux
  + lab_hours_per_oz_reg_chanelle_to_lux * reg_chanelle_to_lux
  <= lab_hours_available;

%-----------------------
% Profit definition ($)
% Revenue - (raw material cost + further processing cost)
% Note: laboratory hours cost is fixed, so not included.
%-----------------------
constraint
  profit =
    price_reg_brute * reg_brute_sold
  + price_reg_chanelle * reg_chanelle_sold
  + price_lux_brute * lux_brute_sold
  + price_lux_chanelle * lux_chanelle_sold
  - raw_cost_per_lb * raw_lb_processed
  - further_process_cost_per_oz * (reg_brute_to_lux + reg_chanelle_to_lux);


% Objective
solve maximize profit;