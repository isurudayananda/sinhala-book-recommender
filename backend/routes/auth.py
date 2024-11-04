from datetime import timedelta

from typing import Annotated

from fastapi import APIRouter, Form, HTTPException, status, Depends
from fastapi.security import OAuth2PasswordRequestForm

from auth.authorize import authenticate_user, oauth2_scheme
from auth.hashing import get_password_hash, ACCESS_TOKEN_EXPIRE_MINUTES, create_access_token
from models.user_model import User
from services.user_service import add_new_user, user_exists

"""
    API router for auth endpoint
    
    Attributes:
        router (APIRouter): the router for the endpoint

    Methods:
        [POST] /api/auth/register
        register_user: the endpoint for registering a new user

        [POST] /api/auth/login
        login_for_access_token: the endpoint for logging in a user

        [POST] /api/auth/logout
        logout: the endpoint for logging out a user
"""

router = APIRouter(
    prefix="/api/auth",
    tags=["auth"],
    responses={404: {"description": "The requested page was not found"}},
)


@router.post("/register")
async def register_user(
        username: str = Form(...),
        email: str = Form(...),
        password: str = Form(...),
        gender: str = Form(...),
        age: int = Form(...),
        interested_categories: str = Form(...)
):
    if user_exists(username):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username already exists",
        )
    hashed_password = get_password_hash(password)
    user = User(
        username=username,
        email=email,
        hashed_password=hashed_password,
        gender=gender,
        age=age,
        interested_categories=interested_categories
    )
    add_new_user(user)
    return user


@router.post("/login")
async def login_for_access_token(
        form_data: Annotated[OAuth2PasswordRequestForm, Depends()]
):
    print('username: ', form_data.username)
    user = authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires.seconds
        # Unresolved attribute reference 'username' for class 'bool'
    )

    return {"access_token": access_token, "token_type": "bearer"}
