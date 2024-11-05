import joblib
import pandas as pd

# Load the trained model and scaler
knn = joblib.load('D:\\Projects\\Bite\\sinhala-book-recommendation-system\\backend\\bin\\knn\\knn_model.joblib')
scaler = joblib.load('D:\\Projects\\Bite\\sinhala-book-recommendation-system\\backend\\bin\\knn\\scaler.joblib')
gender_encoder = joblib.load('D:\\Projects\\Bite\\sinhala-book-recommendation-system\\backend\\bin\\knn\\gender_encoder.joblib')
book_name_encoder = joblib.load('D:\\Projects\\Bite\\sinhala-book-recommendation-system\\backend\\bin\\knn\\book_name_encoder.joblib')

# Load the dataset for reference
data = pd.read_csv("D:\\Projects\\Bite\\sinhala-book-recommendation-system\\ml2\\data.csv")

# Book recommendation function
def recommend_book(age, gender, n_recommendations=5):
    # Encode inputs to match training data encoding
    gender_encoded = gender_encoder.transform([gender])[0]
    # Prepare input for KNN
    input_data = pd.DataFrame([[age, gender_encoded]], columns=['age', 'gender'])
    input_scaled = scaler.transform(input_data)
    # Get the indices of the nearest neighbors
    distances, indices = knn.kneighbors(input_scaled, n_neighbors=n_recommendations)
    # Get the recommended book names using the indices
    recommended_books = data.iloc[indices[0]].drop_duplicates(subset=['book name']).head(n_recommendations)
    return recommended_books

# Test recommendations
test_cases = [(25, 'Male'), (30, 'Female'), (45, 'Female'), (60, 'Male')]
for age, gender in test_cases:
    recommendations = recommend_book(age, gender)
    print(f"Recommendations for Age {age}, Gender {gender}:")
    if 'isbn' in recommendations.columns and 'book name' in recommendations.columns:
        print(recommendations[['isbn', 'book name']])
    else:
        print("Required columns are not present in the dataset.")