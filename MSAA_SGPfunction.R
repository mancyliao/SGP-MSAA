library(SGP)

#------Create data to use
setwd(data_dir)
#---Combine several years into a long data
data_MSAA_2016_wide <- readRDS("data_MSAA_clean_WIDE_2016.rds")
data_MSAA_2017_wide <- readRDS("data_MSAA_clean_WIDE_2017.rds")
data_MSAA_wide_SGP <- merge(data_MSAA_2016_wide,data_MSAA_2017_wide,by="ID",all=T)

#---Separate by subject
var_grade <- colnames(data_MSAA_wide_SGP)[grep("GRADE",colnames(data_MSAA_wide_SGP))]
#Math
var_subject <- colnames(data_MSAA_wide_SGP)[grep("Mat.SCALE_SCORE",colnames(data_MSAA_wide_SGP))]
data_MSAA_wide_Mat <- data_MSAA_wide_SGP[,c("ID",var_grade,var_subject)]
colnames(data_MSAA_wide_Mat)<- gsub("Mat.SCALE_SCORE","SS",colnames(data_MSAA_wide_Mat))

#ELA
var_subject <- colnames(data_MSAA_wide_SGP)[grep("ELA.SCALE_SCORE",colnames(data_MSAA_wide_SGP))]
data_MSAA_wide_ELA <- data_MSAA_wide_SGP[,c("ID",var_grade,var_subject)]
colnames(data_MSAA_wide_ELA)<- gsub("ELA.SCALE_SCORE","SS",colnames(data_MSAA_wide_ELA))


my.grade.sequences <- list(3:4, 4:5, 5:6, 6:7, 7:8)
#----------------------------------Mat------------------------------------------
#***Calculate SGP
my.sgpData_Mat_without_cut <- list(Panel_Data=data_MSAA_wide_Mat)   ### Put sgpData into Panel_Data slot
for (i in seq_along(my.grade.sequences)) {
  my.sgpData_Mat_without_cut <- studentGrowthPercentiles(
    panel.data=my.sgpData_Mat_without_cut,
    panel.data.vnames = c("ID", "GRADE_2016",
                          "GRADE_2017","SS_2016", "SS_2017"),
    sgp.labels=list(my.year=2017, my.subject="Mat"),
    #percentile.cuts=c(1,35,65,99),
    grade.progression=my.grade.sequences[[i]])
}

out_SGP_Mat <- my.sgpData_Mat_without_cut$SGPercentiles$MAT.2017 #ML: Same number of observations as sgp_all 

#***Save Student Growth Percentiles results to a .csv file:
write.csv(out_SGP_Mat,
          file="2017_Mat_SGPercentiles.csv", row.names=FALSE, quote=FALSE, na="")

#----------------------------------ELA------------------------------------------
#***Calculate SGP
my.sgpData_ELA_without_cut <- list(Panel_Data=data_MSAA_wide_ELA)   ### Put sgpData into Panel_Data slot
for (i in seq_along(my.grade.sequences)) {
  my.sgpData_ELA_without_cut <- studentGrowthPercentiles(
    panel.data=my.sgpData_ELA_without_cut,
    panel.data.vnames = c("ID", "GRADE_2016",
                          "GRADE_2017","SS_2016", "SS_2017"),
    sgp.labels=list(my.year=2017, my.subject="ELA"),
    #percentile.cuts=c(1,35,65,99),
    grade.progression=my.grade.sequences[[i]])
}

out_SGP_ELA <- my.sgpData_ELA_without_cut$SGPercentiles$ELA.2017 #ML: Same number of observations as sgp_all 


#***Save Student Growth Percentiles results to a .csv file:
setwd(output_dir)
write.csv(out_SGP_ELA,
          file="2017_ELA_SGPercentiles.csv", row.names=FALSE, quote=FALSE, na="")

