from fastapi import FastAPI
import uvicorn


app = FastAPI()


@app.get("/")
async def read_root():
    return {"message": "Hello! World"}

@app.get("/users/{user}")
async def hello_to_user(user: str):
    return {"message": f"Hello! {user}"}

if __name__ == "__main__":
    uvicorn.run(app, port=80, reload=True)
