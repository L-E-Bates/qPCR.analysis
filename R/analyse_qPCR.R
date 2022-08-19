analyse_qPCR <- function(qPCR_file){
  metadata <- read.csv(qPCR_file,header=FALSE, sep=",", encoding="UTF-8")

  size <- metadata[metadata == "Block Type",2]
  chemistry <- metadata[metadata == "Chemistry",2]
  method <- metadata[metadata == "Quantification Cycle Method",2]
  plex <- metadata[metadata == "Analysis Type",2]
  ctrl_gene <- metadata[metadata == "Endogenous Control",2]
  ctrl_line <- metadata[metadata == "Reference Sample", 2]

  W96 <- ifelse(size == "96well", TRUE, FALSE)
  W384 <- ifelse(size == "384-Well Block", TRUE, FALSE)
  multiplex <- ifelse(plex == "Multiplex", TRUE, ifelse(plex == "Singleplex",FALSE,NA))

  data <- read.csv(qPCR_file, sep=",",skip = ifelse(W96 | W384, ifelse(W96,7,29),0), encoding="UTF-8")
  colnames(data) <- data[1,]
  data <- data[-1,]


  data <- data[1:(match("Analysis Type", data$Well)-1),]
  ctrl_gene="ACTB"
  data_small <- data[,c("Sample Name","Target Name","CT")]
  colnames(data_small) <- c("Sample_Name","Target_Name","CT")
  data_small$CT <- as.numeric(data_small$CT)
  stat.summary <- na.omit(data_small) %>% group_by(Sample_Name, Target_Name) %>% summarise(mean=mean(CT), sd=sd(CT), lower_bound=mean(CT)-2*sd(CT), upper_bound=mean(CT)+2*sd(CT), outliers=CT<mean(CT)-2*sd(CT)|CT>mean(CT)+2*sd(CT))
  data_small$CT[is.na(data_small$CT)] <- 40
  data_small$dCT <- data_small$CT-stat.summary$mean[match(paste(data_small$Sample_Name, ctrl_gene), paste(stat.summary$Sample_Name, stat.summary$Target_Name))]
  data_small$Exp_NegdCT <- 2^(-data_small$dCT)
  dCT.summary <- na.omit(data_small) %>% group_by(Sample_Name, Target_Name) %>% summarise(mean=mean(dCT))
  data_small$ddCT <- data_small$dCT-dCT.summary$mean[match(paste(ctrl_line,data_small$Target_Name), paste(dCT.summary$Sample_Name, dCT.summary$Target_Name))]
  data_small$Exp_NegddCT <- 2^(-data_small$ddCT)
  data.summary <- na.omit(data_small) %>% group_by(Sample_Name, Target_Name) %>% summarise(mean_d=mean(Exp_NegdCT), sd_d=sd(Exp_NegdCT), mean_dd=mean(Exp_NegddCT), sd_dd=sd(Exp_NegddCT))
  data.summary
}

