crime_state = read_csv(here("violence_against_women/year wise crime.csv"))

ggplot(crime_state) +
  geom_line(aes(x=Year, y=Crime_rate))+
  labs(title = "Trend of crime cases against women over last 10 years",
       x = "Year",
       y = "Total cases of violence against women")

