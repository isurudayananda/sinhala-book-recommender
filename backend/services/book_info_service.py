from dao.db_con import get_book_by_isbn


def get_info(isbn: str):
    book_data = get_book_by_isbn(isbn)
    if book_data:
        book_dict = book_data
        del book_dict["_id"]
        return book_dict
    else:
        return None
    
    
def get_book_info_by_name(book_name):
    book_data = get_book_info_by_name(book_name)
    if book_data:
        book_dict = book_data
        del book_dict["_id"]
        return book_dict
    else:
        return None        
