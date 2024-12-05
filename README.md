# Group 3 Final Project
#### *Authors: Kyndall Skelton, Deepa Chaudhary, and Aishwarya Goli*

## Final Project Instructions

**Important Deadlines:**
- **GitHub Repository Creation:**  
  Create your GitHub repository on the **AU-R-Programming** organization by **Monday, Nov. 11th 2024 at 2:00 PM**. Use this repository to work on the assignment.
  
- **Final Submission:**  
  Submit via **Canvas** in a single **HTML file** by **Friday, Dec. 6th 2024 at 11:59 PM**.  
  - The HTML file must specify the name of the corresponding GitHub repository.  
  - No late work will be accepted.  
  - The version submitted on Canvas must correspond to the last version on GitHub.  
  - **No modifications** to the GitHub repository after **Dec. 6th 2024 at 11:59 PM**. Any changes will result in **zero points**.

---

### Project Overview
The goal is to develop an **R package** implementing supervised binary classification using numerical optimization. The package should include functions for performing classification (e.g., estimating the coefficient vector \( \beta \)) and generating the required outputs.

#### Estimation Procedure
The estimator is computed using **numerical optimization** for the following formula:

$$
\hat{\beta} := \arg\min_{\beta} \sum_{i=1}^{n} \left( -y_i \cdot \ln(p_i) - (1 - y_i) \cdot \ln(1 - p_i) \right),
$$

where

$$
p_i := \frac{1}{1 + \exp(-x_i^T \beta)}.
$$

and \( y_i \) and \( x_i \) represent the \( i^{th} \) observation and row of the response and predictors, respectively.

#### Requirements
**Do not use any pre-existing classification functions in R.** All outputs must be computed using the formulas provided in this document.

---

### Outputs
Your package must include the following functionalities:

1. **Initial Values for Optimization:**  
   Use the least-squares formula:

$$
\beta = (X^T X)^{-1} X^T y
$$

3. **Bootstrap Confidence Intervals:**  
   - Allow the user to specify:  
     - The **number of bootstraps** (default: 20).  
     - The **significance level** &alpha; for 1-&alpha; confidence intervals.

4. **Confusion Matrix:**  
   Using a cut-off value of **0.5** for predictions:
   - Assign 1 for predictions > 0.5, and 0 otherwise.
   - Compute and output the following metrics:  
     - Prevalence  
     - Accuracy  
     - Sensitivity  
     - Specificity  
     - False Discovery Rate  
     - Diagnostic Odds Ratio  

5. **Help Documentation:**  
   Provide help documentation for all functions (e.g., using the **roxygen2** package).

6. **Package Availability:**  
   The package must be available for download via a public GitHub repository in the **AU-R-Programming** organization. It should be installable using the `install_github()` function.

---

### Final Submission
Submit an **HTML file** as a vignette. This file must:
- Specify the name of the GitHub repository and package.
- Explain how to use the package functions.
- Provide examples of all desired outputs using one of the datasets on the Canvas course page.

---

## Bonus Points
Up to **2 bonus points** can be earned for adding other useful features, such as:
- A **website** with the vignette.
- An **example Shiny app** using the package.

---

## Donwloads
R Package

Download directly from the github
```R
devtools::install_github("AU-R-Programming/FinalProject_Group3", subdir = "binaryClassifier")
```
or

Download from the release that is a part of the github repository
```R
devtools::install_github("https://github.com/AU-R-Programming/FinalProject_Group3/releases/download/v0.1.0/binaryClassifier_0.1.0.tar.gz")
```
Shiny App:

```R
shiny::runUrl("https://github.com/AU-R-Programming/FinalProject_Group3/raw/main/Shiny_App.zip")
```


---

### Sources

1. [Kyndall ChatGpt ShinyApp](https://chatgpt.com/share/6752070d-8c00-800c-8861-6cca77e63edc)
2. [Kyndall ChatGpt Everything Else](https://chatgpt.com/share/674ce00f-c60c-800c-bced-b59ec7e60786)
3. [Kyndall Chatgpt for Checking Matrix](https://chatgpt.com/share/675207d0-02d4-800c-b361-f50706ad87bd)


