from dao.db_con import mydb
from models.user_model import User

class UserService:
    def get_user(self, username):
        user_dict = mydb["users"].find_one({"username": username})
        if user_dict:
            return User.from_dict(user_dict)
        else:
            return None
        
    def user_exists(self, username):
        user_dict = mydb["users"].find_one({"username": username})
        return user_dict is not None
    
    def add_new_user(self, user: User):
        user_dict = user.to_dict()
        mydb["users"].insert_one(user_dict)

user_service = UserService()


def get_user(username):
    return user_service.get_user(username)


def user_exists(username):
    return user_service.user_exists(username)

def add_new_user(user: User):
    user_service.add_new_user(user)
