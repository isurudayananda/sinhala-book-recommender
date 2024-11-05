import joblib
import pandas as pd

# Load the trained model and scaler
knn = joblib.load('bin\\knn\\knn_model.joblib')
scaler = joblib.load('bin\\knn\\scaler.joblib')
gender_encoder = joblib.load('bin\\knn\\gender_encoder.joblib')
book_name_encoder = joblib.load('bin\\knn\\book_name_encoder.joblib')


# Book recommendation function
def recommend_book_single(age, gender):
    # Encode inputs to match training data encoding
    gender_encoded = gender_encoder.transform([gender])[0]
    # Prepare input for KNN
    input_data = pd.DataFrame([[age, gender_encoded]], columns=['age', 'gender'])
    input_scaled = scaler.transform(input_data)
    
    # Predict the book name
    book_name_encoded = knn.predict(input_scaled)
    book_name = book_name_encoder.inverse_transform(book_name_encoded)
    return book_name


def recommend_books(age, gender, num_recommendations=5):
    # Encode inputs to match training data encoding
    gender_encoded = gender_encoder.transform([gender])[0]
    # Prepare input for KNN
    input_data = pd.DataFrame([[age, gender_encoded]], columns=['age', 'gender'])
    input_scaled = scaler.transform(input_data)
    
    # Get the indices of the nearest neighbors
    distances, indices = knn.kneighbors(input_scaled, n_neighbors=num_recommendations)
    # Decode the recommended book names
    recommended_books_encoded = knn._y[indices[0]]
    recommended_books = book_name_encoder.inverse_transform(recommended_books_encoded)
    
    print(recommended_books[0] + " / " + recommended_books[1]+ " / "  + recommended_books[2])
    
    return recommended_books


def get_recommendations(age: int, gender: str):
    return recommend_books(age, gender)
