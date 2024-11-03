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
    book = get_recommendations(current_user.age, current_user.gender)[0]
    
    # Assume get_book_info_by_name returns a list of book details
    book_details = []
    book_info = get_book_info_by_name(book)
    if book_info:
        # Build URL for image based on ISBN
        book_info_dict = book_info.to_dict()
        book_info_dict['image_url'] = f"http://localhost:8000/images/{book_info_dict['ISBN']}.jpg"
        book_details.append(book_info_dict)
        
    print(book_details)
    
    return book_details


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
