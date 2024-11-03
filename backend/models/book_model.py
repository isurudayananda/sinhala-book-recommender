from bson import ObjectId

class Book:
    def __init__(self, _id=None, book_name=None, isbn=None, author=None, url=None, categories=None, img_url=None):
        self._id = ObjectId(_id) if _id else None
        self.book_name = book_name
        self.isbn = isbn
        self.author = author
        self.url = url
        self.categories = categories
        self.img_url = img_url

    def to_dict(self):
        return {
            "_id": str(self._id) if self._id else None,
            "Book_Name": self.book_name,
            "ISBN": self.isbn,
            "Author": self.author,
            "URL": self.url,
            "Category": self.categories,
            "img_url": self.img_url
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            _id=data.get("_id"),
            book_name=data.get("Book_Name"),
            isbn=data.get("ISBN"),
            author=data.get("Author"),
            url=data.get("URL"),
            categories=data.get("Category"),
            img_url=data.get("img_url")
        )
