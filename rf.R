crime_against_women = crime = read_csv(here("violence_against_women/crime against women raw data.csv"))

crime_combined = data.frame(crime_against_women,
                            pc1$x)
train_frac = 0.8
N = nrow(crime_combined)
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
crime_train = crime_combined[train_ind,]
crime_test = crime_combined[-train_ind,]

crime_forest = randomForest(tot_crime ~ .,
                            data = crime_train, ntree=500, importance = TRUE)

yhat_crime_forest = predict(crime_forest, crime_test)

df4 = crime_test %>%
  mutate(yhat_crime_forest = predict(crime_forest, crime_test)) %>%
  select(State, yhat_crime_forest)
df5 = df4 %>%
  group_by(State) %>%
  mutate(tot_pred_crime = round(sum(yhat_crime_forest),2))%>%
  select(State, tot_pred_crime)
df6 = df5[!duplicated(df5), ]

  
osc = read_csv(here("violence_against_women/OSC.csv"))
dfn = merge(df6, osc, by = "State")
dfn = dfn %>%
  mutate(cases_per_esc = round(tot_pred_crime/OSCs)) %>%
  kbl(caption = "Number of cases to be handled by each OSC as per predictions") %>%
  kable_classic(full_width = F, html_font = "Cambria")
dfn

rf = modelr::rmse(crime_forest, crime_test)

vi = varImpPlot(crime_forest, type=1)

partialPlot(crime_forest, as.data.frame(crime_test), 'PC1', las=1)
partialPlot(crime_forest, as.data.frame(crime_test), 'PC2', las=1)
partialPlot(crime_forest, as.data.frame(crime_test), 'emp', las=1)
partialPlot(crime_forest, as.data.frame(crime_test), 'head', las=1)
