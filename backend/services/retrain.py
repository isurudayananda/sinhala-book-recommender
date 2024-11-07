import pandas as pd
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.neighbors import KNeighborsClassifier
import joblib
import os

# Define the function
def like_book(book_id, age, gender):
    # Ensure gender input is a string
    gender_str = "Male" if gender == 1 else "Female"

    # File paths
    data_path = "D:\\projects\\sinhala-book-recommender\\ml2\\data.csv"
    scaler_path = 'D:\\projects\\sinhala-book-recommender\\backend\\bin\\knn\\scaler.joblib'
    gender_encoder_path = 'D:\\projects\\sinhala-book-recommender\\backend\\bin\\knn\\gender_encoder.joblib'
    book_name_encoder_path = 'D:\\projects\\sinhala-book-recommender\\backend\\bin\\knn\\book_name_encoder.joblib'
    model_path = 'D:\\projects\\sinhala-book-recommender\\backend\\bin\\knn\\knn_model.joblib'

    # Load the dataset
    if os.path.exists(data_path):
        data = pd.read_csv(data_path)
    else:
        raise FileNotFoundError("The data CSV file was not found.")

    # Load or initialize encoders
    if os.path.exists(gender_encoder_path) and os.path.exists(book_name_encoder_path):
        gender_encoder = joblib.load(gender_encoder_path)
        book_name_encoder = joblib.load(book_name_encoder_path)
    else:
        # Initialize and fit encoders with default classes
        gender_encoder = LabelEncoder()
        gender_encoder.fit(["Male", "Female"])
        book_name_encoder = LabelEncoder()
        book_name_encoder.fit(data['book name'])
        
    print('----------------gen str - ' + gender_str)

    # Append the new entry to the dataset
    new_entry = pd.DataFrame({
        'book name': [book_id],
        'age': [age],
        'gender': 1 if gender_str == 'Male' else 0
    })
    data = pd.concat([data, new_entry], ignore_index=True)
    data.to_csv(data_path, index=False)

    # Re-encode updated dataset
    data['gender'] = 1 if gender_str == 'Male' else 0
    data['book_name'] = book_name_encoder.fit_transform(data['book name'])

    # Select features and target
    X = data[['age', 'gender']]
    y = data['book_name']

    # Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    # Train KNN model
    knn = KNeighborsClassifier(n_neighbors=5, algorithm='auto')
    knn.fit(X_scaled, y)

    # Save the updated scaler, encoders, and model
    joblib.dump(scaler, scaler_path)
    joblib.dump(gender_encoder, gender_encoder_path)
    joblib.dump(book_name_encoder, book_name_encoder_path)
    joblib.dump(knn, model_path)

    print("New review added, model retrained, and saved successfully.")
