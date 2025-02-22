# Energy Consumption Analysis and Prediction on Housing Data

## Project Description
This project aims to analyze historical housing data to identify patterns and trends in energy consumption. Using machine learning techniques, we develop predictive models to provide insights into optimizing energy usage.

## Research Question
How does occupant behavior in using appliances impact overall energy consumption in residential buildings?

## Business Questions
1. How do energy reduction efforts align with sustainability goals and commitments?
2. What solutions can be provided to eSC to support energy efficiency projects?
3. Which household factors contribute the most to high energy usage, particularly in July?

## Objectives & Significance
Energy consumption in residential buildings accounts for a significant portion of total energy usage. Understanding consumption patterns can help homeowners and policymakers make informed decisions to promote energy efficiency, reduce costs, and mitigate environmental impact.

## Exploratory Data Analysis & Feature Engineering

### Heating Set Points
- The boxplot shows energy consumption across different heating set points.
- Energy consumption is significantly higher for heating set points above 55°F.

### Cooling Set Points
- During summer, energy consumption is high at lower cooling set points and lower at higher cooling set points.

### Wall Insulation
- Good wall insulation helps maintain indoor comfort by reducing heat transfer from outside.

### Cooking Range
- Boxplot analysis shows propane usage at 80% results in the least energy consumption.
- Switching from electric or gas to propane-based cooking contributes to energy savings.

### Types of Lighting
- CFL and LED bulbs consume similar amounts of energy, whereas incandescent bulbs use slightly more.
- Changing light bulbs can significantly impact energy consumption.

## Modeling Approach
Significant features for modeling include thermostat setpoints, insulation types, lighting types, and cooking range.

### Linear Regression Model
- R-Squared Value: **0.698**
- Statistical significance supports model reliability.

### Light Gradient Boosting Model (LGBM)
- RMSE: **0.33**
- Did not surpass Linear Regression in performance.

### Support Vector Regression (SVR)
- R-Squared Value: **0.75**
- RMSE: **0.21**
- Outperformed other models in accuracy.

## Model Evaluation
Comparison of model performances:
- **Linear Regression**: R² = 0.698, good predictive power.
- **LightGBM**: RMSE = 0.33, underperformed compared to other models.
- **Support Vector Regression**: R² = 0.75, best performing model.

## Conclusion
Support Vector Regression proved to be the most precise model for predicting energy consumption. Insights from the study can help optimize household energy usage, reduce costs, and improve energy efficiency.

## Installation & Usage
1. Clone this repository:
   ```bash
   git clone https://github.com/your-repo-name.git
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Run the analysis:
   ```bash
   python main.py
   ```

## License
This project is licensed under the MIT License.

