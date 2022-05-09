crime = read_csv(here("violence_against_women/Crime raw data.csv"))
L = crime[, -(1:2)]
L = scale(L, center=TRUE, scale=TRUE)

pc1 = prcomp(L, scale=TRUE, rank=18)

summary(pc1)

loadings_summary = pc1$rotation %>%
  as.data.frame()%>%
  rownames_to_column('crime_category')

ggplot(loadings_summary) +geom_col(aes(x=reorder(crime_category, PC1),y=PC1))+xlab("PC1")+ylab("Crime Category")+coord_flip()
ggplot(loadings_summary) +geom_col(aes(x=reorder(crime_category, PC2),y=PC2))+xlab("PC2")+ylab("Crime Category")+coord_flip()

df3 = round(pc1$rotation,2) %>%
  kbl(caption = "Principal Components of crime categories") %>%
  kable_classic(full_width = F, html_font = "Cambria")
df3


