from fastapi import APIRouter, Depends, Form, HTTPException
import logging ,os
logging.basicConfig(level=logging.INFO)

from services.retrain import like_book
from dao.db_con import get_book_info_by_name, search_book
from services.book_info_service import get_info
from services.books_service import get_recommendations
from services.similar_books_service import get_similar_books
from auth.authorize import get_current_user, oauth2_scheme, credentials_exception
from fastapi.security import OAuth2PasswordBearer
from fastapi.staticfiles import StaticFiles


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


router = APIRouter(
    prefix="/api/books",
    tags=["books"],
    responses={404: {"description": "The requested uri was not found"}},
)


@router.get("/get-recommendations")
async def get_recommend_auth(
    token: str = Depends(oauth2_scheme)
):
    
    # Ensure the user is authenticated
    if await get_current_user(token) is None:
        raise credentials_exception
    
    current_user = await get_current_user(token)
    # Get the top 3 book recommendations based on user's age and gender
    recommended_books = get_recommendations(current_user.age, current_user.gender)[:4]
    
    # Gather details for each recommended book
    book_details = []
    for book in recommended_books:
        book_info = get_book_info_by_name(book)
        if book_info:
            # Convert to dict and add image URL for each book
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



@router.post('/search')
async def search_book_handler(
    query: str = Form(...)
):
    search_results = search_book(query)

    # Convert each Book instance to a dictionary and return
    search_results_with_images = [book for book in search_results]
    print('-----------------------')
    print(search_results_with_images)
    return search_results_with_images


@router.post('/like')
async def increment_book_reviews(
    token: str = Depends(oauth2_scheme),
    book_id: str = Form(...)
):
    print(token)
    current_user = await get_current_user(token)
    if current_user is None:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    print('current user: ' + str(current_user.age) + " - " + current_user.gender)
    if like_book(book_id, current_user.age, current_user.gender):
        return {"message": "Liked successfully"}
    else:
        return {"message": "Like unsuccessful"}


@router.post('/increment-book-reviews')
async def increment_book_reviews(
        token: str = Depends(oauth2_scheme),
        isbn: str = Form(...)
):
    if await get_current_user(token) is None:
        raise credentials_exception
    
    if increment_book_reviews(isbn):
        # TODO retrain knn
        return "incremented successfully"
    else:
        return "book not found"
