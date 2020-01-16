d <- read.csv("acath.csv")
d <- d[,-6]
head(d)
tail(d)

summary(d)
nrow(d) # 3504

library(naniar)

vis_miss(d)

missing <- miss_var_summary(d)
View(missing)

# and now as a plot

gg_miss_var(d)

# Look at the missingness in cholesterol and sigdz

library(ggplot2)

p <- ggplot(d,
         aes(x = sigdz,
             y = choleste)) +
     geom_miss_point()

p

# for each sex?

p + facet_wrap(~sex)

# Missing Mechanism

d$R <- ifelse(is.na(d$choleste), 1, 0)

mech <- glm(R ~ sex + age + cad.dur + sigdz,
            family = "binomial", data = d)

summary(mech)

# Listwise Deletion

d2 <- d[,-6]

model_ld <- glm(sigdz ~ sex + age + cad.dur + choleste,
              family = "binomial", data = d2)

summary(model_ld)

# Inverse Probability Weighting

qhat <- mech$fitted

wt <- 1/(1 - qhat)

model_ipw <- glm(sigdz ~ sex + age + cad.dur + choleste,
                 weights = wt, family = "quasibinomial", data = d)

summary(model_ipw)

# Single Imputation: Mean Imputation

d3 <- d2

mean_choleste <- mean(as.data.frame(filter(d3, !is.na(d3$choleste)))$choleste) # 229.9283

for (i in 1:nrow(d3)){
  
  if (is.na(d3$choleste[i])){d3$choleste[i] = mean_choleste}
  
  else {d3$choleste[i] = d3$choleste[i]}
  
}

# Fit model using imputed values

model_mean_imp <- glm(sigdz ~ sex + age + cad.dur + choleste,
                       family = "binomial", data = d3)

summary(model_mean_imp)

# Conditional mean imputation

d4 <- d2

mean_f <- mean(as.data.frame(filter(d4, !is.na(d4$choleste) & d4$sex == 1))$choleste) # 236.7692

mean_m <- mean(as.data.frame(filter(d4, !is.na(d4$choleste) & d4$sex == 0))$choleste) # 226.9242

for (i in 1:nrow(d4)){
  
  if (d4$sex[i] == 1 & is.na(d4$choleste[i])) {d4$choleste[i] = mean_f}
  
  if (d4$sex[i] == 0 & is.na(d4$choleste[i])) {d4$choleste[i] = mean_m}
  
  else {d4$choleste[i] = d4$choleste[i]}
  
}

# Fit model using imputed values

model_cond_imp <- glm(sigdz ~ sex + age + cad.dur + choleste,
                      family = "binomial", data = d4)

summary(model_cond_imp)

# Regression Imputation: Random Forest

install.packages("randomForest")
library(randomForest)

d5 <- d2

fit_rf <- randomForest(choleste ~ sex + age + cad.dur + sigdz,
                       data = d5, na.action = na.omit)

d5$chol.impute <- predict(fit_rf, newdata = d5)

d5$chol.impute[!is.na(d5$choleste)] <- d5$choleste[!is.na(d5$choleste)]

# Fit model

model_rf <- glm(sigdz ~ sex + age + cad.dur + chol.impute,
                family = "binomial", data = d5)

summary(model_rf)

# Multiple Imputation

install.packages("mice")
library(mice)

d6 <- d2

mult_imp <- mice(d6, m = 5, seed = 12345, print = F)

fit_mult_imp <- with(mult_imp, glm(sigdz ~ sex + age + cad.dur + choleste,
                                   family = "binomial"))

round(summary(pool(fit_mult_imp)), 3)

densityplot(mult_imp, scales = list(x = list(relation = "free")))