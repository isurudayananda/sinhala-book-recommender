from fastapi import APIRouter, Depends, Form

from dao.db_con import get_book_info_by_name
from services.book_info_service import get_info
from services.books_service import get_recommendations
from services.similar_books_service import get_similar_books
from auth.authorize import get_current_user, oauth2_scheme, credentials_exception

router = APIRouter(
    prefix="/api/books",
    tags=["books"],
    responses={404: {"description": "The requested uri was not found"}},
)


@router.get("/get-recommendations")
async def get_recommend_auth(
    token: str = Depends(oauth2_scheme)
):
    if await get_current_user(token) is None:
        raise credentials_exception
    
    current_user = await get_current_user(token)

    books = list(get_recommendations(current_user.age, current_user.gender))
    print(books)
    
    book_info = get_book_info_by_name(books[0])
    
    return book_info.to_dict()


@router.post("/get-recommendations")
async def get_recommend(
        age: int = Form(...),
        gender: str = Form(...)
):
    return get_recommendations(age, gender)


@router.post("/get-similar")
async def get_similar(
        book_name: str = Form(...)
):
    return get_similar_books(book_name)


@router.post("/get-book-info")
async def get_book_info(
        isbn: str = Form(...)
):
    return dict(get_info(isbn))
