import pymongo
from bson import ObjectId

from models.book_model import Book
from models.user_model import User

# MongoDB connection
myclient = pymongo.MongoClient("mongodb://localhost:27017/")
db_name = 'BooksDB'
mydb = myclient[db_name]

# Check if the database exists
dblist = myclient.list_database_names()
if db_name in dblist:
    print("The database exists.")
else:
    raise Exception("The database connection failed, DB not found!")

# Check if the collections exist
user_collection_name = 'users'
book_collection_name = 'books'

collist = mydb.list_collection_names()
if user_collection_name not in collist:
    raise Exception("User collection doesn't exist in the DB!")
if book_collection_name not in collist:
    raise Exception("Book collection doesn't exist in the DB!")

# Collections
user_collection = mydb[user_collection_name]
book_collection = mydb[book_collection_name]


# User operations
def insert_user(user):
    if isinstance(user, User):
        user_dict = user.to_dict()
        if '_id' in user_dict:
            user_dict.pop('_id')  # Remove _id if present
        user_collection.insert_one(user_dict)
    else:
        raise TypeError("Expected a User instance")


def update_user(user_id, update_data):
    user_collection.update_one({"_id": ObjectId(user_id)}, {"$set": update_data})


def get_user(user_id):
    user_data = user_collection.find_one({"_id": ObjectId(user_id)})
    return User.from_dict(user_data) if user_data else None


# Book operations
def insert_book(book):
    if isinstance(book, Book):
        book_collection.insert_one(book.to_dict())
    else:
        raise TypeError("Expected a Book instance")
    
    
def search_book(query):
    print('searching: ' + query + '...')
    
    # Perform a case-insensitive search on 'Book_Name', 'Author', and 'Category', excluding '_id'
    name_author_results = book_collection.find({
        "$or": [
            {"Book_Name": {"$regex": query, "$options": "i"}},  # Case-insensitive search on 'Book_Name'
            {"Author": {"$regex": query, "$options": "i"}}      # Case-insensitive search on 'Author'
        ]
    }, {
        "_id": 0  # Exclude '_id' field
    })

    # Separate search specifically for categories
    category_results = book_collection.find({
        "Category": {"$regex": query, "$options": "i"}  # Case-insensitive search on 'Category'
    }, {
        "_id": 0  # Exclude '_id' field
    })

    # Convert search results to lists of Book instances
    name_author_books = [Book.from_dict(book) for book in name_author_results]
    category_books = [Book.from_dict(book) for book in category_results]

    # Combine both lists and remove duplicates based on a unique attribute, e.g., 'ISBN'
    combined_books = {book.isbn: book for book in name_author_books + category_books}

    # Return the list of unique Book instances
    return list(combined_books.values())



def update_book(book_id, update_data):
    book_collection.update_one({"_id": ObjectId(book_id)}, {"$set": update_data})


def get_book(book_id):
    book_data = book_collection.find_one({"_id": ObjectId(book_id)})
    return Book.from_dict(book_data) if book_data else None


def increment_book_reviews(isbn):
    book_data = book_collection.find_one({"ISBN": int(isbn)})
    if book_data:
        new_num_reviews = book_data["num_reviews"] + 1
        book_collection.update_one({"ISBN": int(isbn)}, {"$set": {"num_reviews": new_num_reviews}})
        return True
    else:
        return False


def get_book_info_by_name(book_name): 
    book_data = book_collection.find_one({"Book_Name": book_name})
    print(book_data)
    return Book.from_dict(book_data) if book_data else None


def get_book_by_isbn(isbn):
    book_data = book_collection.find_one({"ISBN": int(isbn)})
    print('-----' +book_data)
    return book_data if book_data else None
