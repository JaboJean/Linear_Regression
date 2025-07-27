import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import SGDRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.metrics import mean_squared_error
import pickle

print("Creating sample temperature change data...")

# Create sample data since we don't have the original CSV
# This simulates temperature change data from 1961 to 2020
years = list(range(1961, 2021))
# Simulate temperature change with some trend and randomness
np.random.seed(42)
temp_changes = []

for year in years:
    # Create a trend that shows increasing temperature change over time
    base_change = (year - 1961) * 0.02  # Gradual increase
    noise = np.random.normal(0, 0.3)    # Add some random variation
    temp_change = base_change + noise
    temp_changes.append(temp_change)

# Create DataFrame
df_avg = pd.DataFrame({
    'Year': years,
    'AvgTempChange': temp_changes
})

print(f"Created dataset with {len(df_avg)} records")
print(f"Year range: {df_avg['Year'].min()} - {df_avg['Year'].max()}")
print(f"Temperature change range: {df_avg['AvgTempChange'].min():.3f} - {df_avg['AvgTempChange'].max():.3f}")

# Data Preprocessing
print("\nPreparing data for training...")
X = df_avg[['Year']]
y = df_avg['AvgTempChange']

# Split Data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train models
print("\nTraining models...")
models = {
    'Linear Regression (GD)': SGDRegressor(max_iter=1000, tol=1e-3, learning_rate='optimal', random_state=42),
    'Random Forest': RandomForestRegressor(n_estimators=100, random_state=42),
    'Decision Tree': DecisionTreeRegressor(random_state=42)
}

errors = {}
trained_models = {}

for name, model in models.items():
    print(f"Training {name}...")
    model.fit(X_train, y_train)
    predictions = model.predict(X_test)
    mse = mean_squared_error(y_test, predictions)
    errors[name] = mse
    trained_models[name] = model
    print(f"  MSE: {mse:.6f}")

print(f"\nModel performance comparison:")
for name, error in errors.items():
    print(f"  {name}: {error:.6f}")

# Save the best model
best_model_name = min(errors, key=errors.get)
best_model = trained_models[best_model_name]

print(f"\nBest model: {best_model_name}")
print(f"Saving model as '{best_model_name}.pkl'...")

with open(f"{best_model_name}.pkl", "wb") as f:
    pickle.dump(best_model, f)

print(f"Model saved successfully!")

# Test the saved model
print(f"\nTesting saved model...")
with open(f"{best_model_name}.pkl", "rb") as f:
    loaded_model = pickle.load(f)

test_years = [2019, 2025, 2030]
print(f"Sample predictions:")
for year in test_years:
    prediction = loaded_model.predict([[year]])[0]
    print(f"  Year {year}: {prediction:.3f}°C change")

print(f"\nModel is ready for use in the API!")
print(f"File created: {best_model_name}.pkl")