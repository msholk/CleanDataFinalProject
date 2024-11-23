create_codebook <- function(data, file_name = "codebook.txt") {
  
  # Ensure that the number of rows match the number of variables (columns)
  codebook <- list()
  
  # Document Variable Names, Data Types, and Units
  codebook$variables <- data.frame(
    Variable = names(data),  # Get column names from the data
    Type = sapply(data, class),  # Get the type of each variable
    Units = c(rep("N/A", 6),    # For Activity and Subject
              "m/s"),  # Set default units for the remaining columns
    Description = c(
      "Activity being performed (e.g., walking, running)",
      "Subject performing the activity (1-30)",
      "Domain (Time/Frequency)",
      "Feature (tBodyAcc,tGravityAcc) ",
      "Average function (mean, std)",
      "Axis function (X,Y,Z)",
      "Measurement value"
    )
  )
  
  # Add Summary Statistics to the Codebook (for numeric variables)
  summary_stats <- data.frame(
    Variable = names(data),
    Mean = sapply(data, function(x) if(is.numeric(x)) mean(x, na.rm = TRUE) else NA),
    Median = sapply(data, function(x) if(is.numeric(x)) median(x, na.rm = TRUE) else NA),
    Min = sapply(data, function(x) if(is.numeric(x)) min(x, na.rm = TRUE) else NA),
    Max = sapply(data, function(x) if(is.numeric(x)) max(x, na.rm = TRUE) else NA),
    SD = sapply(data, function(x) if(is.numeric(x)) sd(x, na.rm = TRUE) else NA)
  )
  
  # Combine variables and summary stats
  codebook$summary <- merge(codebook$variables, summary_stats, by = "Variable")
  print(paste("Saving codebook to",file_name))
  # Write to a text file
  write.table(codebook$summary, file = file_name, sep = "\t", row.names = FALSE, col.names = TRUE)
  
  return(codebook)
}
