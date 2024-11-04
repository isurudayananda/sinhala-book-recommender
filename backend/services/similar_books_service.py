import pickle
import numpy as np

from dao.db_con import get_book_info_by_name

# Load the saved files
pt = pickle.load(open('bin/df/pt.pkl', 'rb'))
books = pickle.load(open('bin/df/books.pkl', 'rb'))
similarity_scores = pickle.load(open('bin/df/similarity_scores.pkl', 'rb'))


def recommend(book_name):
    # index fetch
    index = np.where(pt.index == book_name)[0][0]
    similar_items = sorted(list(enumerate(similarity_scores[index])), key=lambda x: x[1], reverse=True)[1:5]
    
    data = []
    for i in similar_items:
        item = []
        temp_df = books[books['Book_Title'] == pt.index[i[0]]]
        item.extend(list(temp_df.drop_duplicates('Book_Title')['Book_Title'].values))
        item.extend(list(temp_df.drop_duplicates('Book_Title')['Author'].values))

        data_item = get_book_info_by_name(item[0]).to_dict()
        data_item['image_url'] = f"http://localhost:8000/images/{data_item['ISBN']}.jpg"
        data.append(data_item)
    
    return data


def get_similar_books(book_name: str):
    return recommend(book_name)
