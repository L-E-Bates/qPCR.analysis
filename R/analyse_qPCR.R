

#' Analyse qPCR file
#'
#' @param qPCR_file The path to a csv file of the Results page of a qPCR run.
#' @param ctrl_gene Name of the control gene to normalize to if not included or different to that stated in the file.
#' @param ctrl_line Name of the control line to normalize to if not included or different to that stated in the file.
#' @param out_data Logical. Set to true to output the full analysed dataset rather than the summary statistics.
#'
#' @return A tibble containing the mean, SD, and SEM for the delta and delta delta values for each gene in each sample.
#' @export
#'
#' @examples
#'
#' x <- system.file("extdata", "SYBR 384W example.csv", package = "qPCR.analysis")
#' analyse_qPCR(x)
#'


analyse_qPCR <- function(qPCR_file, ctrl_gene=FALSE, ctrl_line=FALSE, out_data=FALSE){
  metadata <- utils::read.csv(qPCR_file,header=FALSE, sep=",", encoding="UTF-8")
  if (! is.na(match("Block Type", metadata[,1]))){
    size <- metadata[metadata == "Block Type",2]
    chemistry <- metadata[metadata == "Chemistry",2]
    if (chemistry=="SYBR_GREEN"){
      print("Detected SybrGreen run. Analysing.")
    } else if(chemistry=="TAQMAN"){
      stop("Detected Taqman run. Analysis pipeline not yet established. Quitting.")
    }
    method <- metadata[metadata == "Quantification Cycle Method",2]
    if (method=="Comparative C? (??C?)"){
      print("Performing Delta-Delta CT analysis.")
    } else {
      print("Assuming analysis method is Delta-Delta CT. Performing analysis.")
    }
    plex <- metadata[metadata == "Analysis Type",2]
    if (! is.character(ctrl_gene)){
      ctrl_gene <- metadata[metadata == "Endogenous Control",2]
    }
    print(paste("Control gene is",ctrl_gene))
    if (! is.character(ctrl_line)){
      ctrl_line <- metadata[metadata == "Reference Sample", 2]
    }
    print(paste("Control line is",ctrl_line))

    W96 <- ifelse(size == "96well", TRUE, FALSE)
    W384 <- ifelse(size == "384-Well Block", TRUE, FALSE)
    multiplex <- ifelse(plex == "Multiplex", TRUE, ifelse(plex == "Singleplex",FALSE,NA))

    data <- utils::read.csv(qPCR_file, sep=",",skip = ifelse(W96 | W384, match("Well", metadata[,1])-1,0), encoding="UTF-8", header=TRUE)
    data <- data[1:(match("Analysis Type", data$Well)-2),]
    data_small <- data[,c("Sample.Name","Target.Name","CT")]
    colnames(data_small) <- c("Sample_Name","Target_Name","CT")


  } else {
    print("File is not the results page output. Will try to analyse anyway.")
    formatcheck <- readline(prompt="Input should have 3 columns, \"Sample\", \"Target\", \"CT\" (exact header names not required). Confirm (Y/N)")

    if (grep("Y", formatcheck, ignore.case = TRUE) == 1){
      data <- utils::read.csv(qPCR_file, sep=",", encoding="UTF-8", header=TRUE)
      data_small <- data
      colnames(data_small) <- c("Sample_Name","Target_Name","CT")
    } else {
      stop("Please correct file format before submitting. Quitting.")
    }


  }

  data_small$Sample_Name <- factor(data_small$Sample_Name)
  data_small$Target_Name <- factor(data_small$Target_Name)
  data_small$CT[data_small$CT=="Undetermined"] <- NA
  data_small$CT <- as.numeric(data_small$CT)
  data_small <- stats::na.omit(data_small)

  data_table <- data.frame(Sample_Name=character(), Target_Name=character(),CT=numeric(),CTr=numeric(),p.value=numeric())

  for (a in levels(data_small$Sample_Name)){
    for (b in levels(data_small$Target_Name)){
      if (length(data_small[data_small$Sample_Name==a & data_small$Target_Name==b,"CT"])>0){
        table <- data.frame(Sample_Name=a,Target_Name=b,CT=data_small[data_small$Sample_Name==a & data_small$Target_Name==b,"CT"],CTr=data_small[data_small$Sample_Name==a & data_small$Target_Name==b,"CT"]-mean(data_small[data_small$Sample_Name==a & data_small$Target_Name==b,"CT"]), p.value=1)
        if (length(data_small[data_small$Sample_Name==a & data_small$Target_Name==b,"CT"])>2){
          table <- table[order(table$CT),]
          n <- length(table$CT)
          value <- outliers::dixon.test(table$CT)$p.value
          if ((table[n,"CT"] - mean(table[,"CT"])) < (mean(table[,"CT"]) - table[1,"CT"])) {
            table[1,"p.value"] <- value
          } else {
            table[n,"p.value"] <- value
          }
          if (value < 0.05) {
            print(paste(as.character(a), as.character(b), "is an outlier; p=",value,". Excluding."))
          }
        }
        data_table <- rbind(data_table,table[table$p.value>0.05,])
      }
    }
  }

  stat.summary <- data_table %>% dplyr::group_by(Sample_Name, Target_Name) %>% dplyr::summarise(mean=mean(CT), sd=stats::sd(CT))
  data_table$dCT <- data_table$CT-stat.summary$mean[match(paste(data_table$Sample_Name, ctrl_gene), paste(stat.summary$Sample_Name, stat.summary$Target_Name))]
  data_table$Exp_NegdCT <- 2^(-data_table$dCT)
  dCT.summary <- data_table %>% dplyr::group_by(Sample_Name, Target_Name) %>% dplyr::summarise(mean=mean(dCT))
  data_table$ddCT <- data_table$dCT-dCT.summary$mean[match(paste(ctrl_line,data_table$Target_Name), paste(dCT.summary$Sample_Name, dCT.summary$Target_Name))]
  data_table$Exp_NegddCT <- 2^(-data_table$ddCT)
  data.summary <- data_table %>% dplyr::group_by(Sample_Name, Target_Name) %>% dplyr::summarise(mean_d=mean(Exp_NegdCT), sd_d=stats::sd(Exp_NegdCT), sem_d=stats::sd(Exp_NegdCT)/dplyr::n(), mean_dd=mean(Exp_NegddCT), sd_dd=stats::sd(Exp_NegddCT), sem_dd=stats::sd(Exp_NegddCT)/dplyr::n(),nrep=dplyr::n())
  if (out_data){
    return(data_table)
  } else {
    return(data.summary)
  }

}
