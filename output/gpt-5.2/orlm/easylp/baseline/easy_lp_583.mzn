int: cost_online = 20;
int: cost_offline = 30;
int: cost_social = 10;
int: cost_email = 15;

int: max_budget_online_offline = 5000;
int: max_budget_social_email = 3000;

int: max_online_units = 3000;
int: max_offline_units = 2000;
int: max_social_units = 1500;
int: max_email_units = 1500;

var 0..max_online_units: Online_Ad;
var 0..max_offline_units: Offline_Ad;
var 0..max_social_units: Social_Media_Ad;
var 0..max_email_units: Email_Marketing;

constraint Online_Ad + Offline_Ad <= max_budget_online_offline;
constraint Social_Media_Ad + Email_Marketing <= max_budget_social_email;

constraint Online_Ad >= Offline_Ad + 1000;
constraint Social_Media_Ad >= Email_Marketing + 500;

var int: Total_Cost =
    cost_online * Online_Ad +
    cost_offline * Offline_Ad +
    cost_social * Social_Media_Ad +
    cost_email * Email_Marketing;

solve minimize Total_Cost;

output [
  "Online_Ad = ", show(Online_Ad), "\n",
  "Offline_Ad = ", show(Offline_Ad), "\n",
  "Social_Media_Ad = ", show(Social_Media_Ad), "\n",
  "Email_Marketing = ", show(Email_Marketing), "\n",
  "Total_Cost = $", show(Total_Cost), "\n"
];