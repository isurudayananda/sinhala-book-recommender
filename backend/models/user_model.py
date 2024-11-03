from bson import ObjectId

class User:
    def __init__(self, _id=None, username=None, hashed_password=None, email=None, gender=None, age=None, interested_categories=None):
        self._id = _id
        self.username = username
        self.hashed_password = hashed_password
        self.email = email
        self.gender = gender
        self.age = age
        self.interested_categories = interested_categories

    def to_dict(self):
        return {
            "_id": self._id,
            "username": self.username,
            "hashed_password": self.hashed_password,
            "email": self.email,
            "gender": self.gender,
            "age": self.age,
            "interested_categories": self.interested_categories
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            _id=data["_id"],
            username=data["username"],
            hashed_password=data["hashed_password"],
            email=data["email"],
            gender=data["gender"],
            age=data["age"],
            interested_categories=data["interested_categories"]
        )
        